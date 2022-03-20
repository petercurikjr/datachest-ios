//
//  DropboxFileUploadSession.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 13/03/2022.
//

import CryptoKit
import Foundation

class DropboxFileUploadSession: FileUploadSession {
    var bytesTransferred = 0
    var finishUpload = false
    
    init(fileUrl: URL) {
        super.init(fileUrl: fileUrl, bufferSize: 4*262144)
        DropboxService.shared.startUploadSession { response in
            let jsonRawObject = try? JSONSerialization.jsonObject(with: response.data, options: [])
            if let dictionary = jsonRawObject as? [String: Any] {
                if let sid = dictionary["session_id"] as? String {
                    self.sessionId = sid
                    self.upload()
                }
            }
        }
    }
    
    private func upload() {
        if self.ds != nil && self.sessionId != nil {
            let readStreamBytes = self.ds!.read(self.buffer, maxLength: self.bufferSize)
            if readStreamBytes < bufferSize { self.finishUpload = true }
            
            let chunkPtr = Array(UnsafeBufferPointer(start: self.buffer, count: readStreamBytes))
            let ciphertextChunk = try! AES.GCM.seal(Data(chunkPtr), using: self.aesKey)
            
            if !finishUpload {
                let sessionArg = DropboxUploadFileMetadata(
                    cursor: DropboxUploadFileCursor(session_id: self.sessionId!, offset: self.bytesTransferred),
                    close: false
                )

                if let jsonData = try? JSONEncoder().encode(sessionArg) {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        print(jsonString)
                        DropboxService.shared.uploadFile(chunk: ciphertextChunk.ciphertext, sessionArg: jsonString) { _ in
                            if self.ds!.hasBytesAvailable {
                                self.bytesTransferred += readStreamBytes
                                self.upload()
                            }
                        }
                    }
                }
            }
            
            else {
                let sessionArg = DropboxFinishUploadMetadata(
                    cursor: DropboxUploadFileCursor(session_id: self.sessionId!, offset: self.bytesTransferred),
                    commit: DropboxUploadFileCommit(path: "/Datachest/Files/filename", mode: "add", autorename: true)
                )
                
                if let jsonData = try? JSONEncoder().encode(sessionArg) {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        DropboxService.shared.finishUploadSession(chunk: ciphertextChunk.ciphertext, sessionArg: jsonString) { _ in
                            // empty closure
                        }
                    }
                }
            }
        }
    }
}
