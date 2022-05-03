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
        super.init(fileUrl: fileUrl, bufferSize: .dropbox)
        DropboxService.shared.startUploadSession { response in
            let jsonRawObject = try? JSONSerialization.jsonObject(with: response.data, options: [])
            if let dictionary = jsonRawObject as? [String: Any] {
                if let sid = dictionary["session_id"] as? String {
                    self.sessionId = sid
                    self.uploadFile()
                }
            }
        }
    }
    
    private func uploadFile() {
        if self.ds != nil && self.sessionId != nil {
            let readStreamBytes = self.ds!.read(self.buffer, maxLength: self.bufferSize)
            if readStreamBytes < bufferSize { self.finishUpload = true }
            
            let chunkPtr = Array(UnsafeBufferPointer(start: self.buffer, count: readStreamBytes))
            let ciphertextChunk = try! AES.GCM.seal(Data(chunkPtr), using: self.aesKey, nonce: self.nonce)
            self.fileAESTags.append(ciphertextChunk.tag)
            
            if !finishUpload {
                let sessionArg = DropboxUploadFileMetadata(
                    cursor: DropboxUploadFileCursor(session_id: self.sessionId!, offset: self.bytesTransferred),
                    close: false
                )

                if let jsonData = try? JSONEncoder().encode(sessionArg) {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        DropboxService.shared.uploadFileInChunks(chunk: ciphertextChunk.ciphertext, sessionArg: jsonString) { _ in
                            if self.ds!.hasBytesAvailable {
                                self.bytesTransferred += readStreamBytes
                                self.uploadFile()
                            }
                        }
                    }
                }
            }
            
            else {
                let sessionArg = DropboxFinishUploadMetadata(
                    cursor: DropboxUploadFileCursor(session_id: self.sessionId!, offset: self.bytesTransferred),
                    commit: DropboxCreateItemCommit(path: "\(DatachestFolders.files.full)/\(self.fileName)", mode: "add", autorename: true)
                )
                
                if let jsonData = try? JSONEncoder().encode(sessionArg) {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        DropboxService.shared.finishUploadSession(chunk: ciphertextChunk.ciphertext, sessionArg: jsonString) { response in
                            guard let fileInfo = try? JSONDecoder().decode(DropboxFileResponse.self, from: response.data) else {
                                DispatchQueue.main.async {
                                    if ApplicationStore.shared.uistate.error == nil {
                                        ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                                    }
                                }
                                return
                            }
                            self.uploadedFileID = String(fileInfo.id.dropFirst(3))
                            self.distributeKeyShares(fileOwningCloud: .dropbox)
                        }
                    }
                }
            }
        }
    }
}
