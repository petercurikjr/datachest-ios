//
//  MicrosoftOneDriveFileUploadSession.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 14/03/2022.
//

import Foundation
import CryptoKit

class MicrosoftOneDriveUploadSession: FileUploadSession {
    var bytesTransferred = 0
    
    init(fileUrl: URL) {
        super.init(fileUrl: fileUrl, bufferSize: 3*327680)
        MicrosoftOneDriveService.shared.createUploadSession(fileName: "testfilename", fileMetadata: nil) { response in
            guard let resumableUploadResponse = try? JSONDecoder().decode(MicrosoftOneDriveResumableUploadResponse.self, from: response.data) else {
                print("error decoding")
                return
            }
            
            self.sessionId = resumableUploadResponse.uploadUrl
            self.upload()
        }
    }
    
    private func upload() {
        if self.ds != nil && self.sessionId != nil {
            let readStreamBytes = self.ds!.read(self.buffer, maxLength: self.bufferSize)
            if readStreamBytes == 0 { return }
            
            let chunkPtr = Array(UnsafeBufferPointer(start: self.buffer, count: readStreamBytes))
            let ciphertextChunk = try! AES.GCM.seal(Data(chunkPtr), using: self.aesKey)
                        
            let startRange = self.bytesTransferred
            let endRange = self.bytesTransferred + readStreamBytes - 1
            MicrosoftOneDriveService.shared.uploadFile(
                chunk: ciphertextChunk.ciphertext,
                bytes: "\(startRange)-\(endRange)/\(self.fileSize!)",
                chunkSize: readStreamBytes,
                resumableURL: self.sessionId!
            ) { _ in
                if self.ds!.hasBytesAvailable {
                    self.bytesTransferred += readStreamBytes
                    self.upload()
                }
            }
        }
    }
}
