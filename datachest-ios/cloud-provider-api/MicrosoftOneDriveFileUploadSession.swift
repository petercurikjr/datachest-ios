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
        super.init(fileUrl: fileUrl, bufferSize: .microsoftOneDrive)
        let metadata = MicrosoftOneDriveCreateItemRequest(item: MicrosoftOneDriveCreateItem(name: self.fileName, folder: nil, conflictBehavior: "rename"))
        if let jsonData = try? JSONEncoder().encode(metadata) {
            MicrosoftOneDriveService.shared.createUploadSession(fileName: self.fileName, fileMetadata: jsonData) { response in
                guard let resumableUploadResponse = try? JSONDecoder().decode(MicrosoftOneDriveResumableUploadResponse.self, from: response.data) else {
                    DispatchQueue.main.async {
                        if ApplicationStore.shared.uistate.error == nil {
                            ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                        }
                    }
                    return
                }
                
                self.sessionId = resumableUploadResponse.uploadUrl
                self.uploadFile()
            }
        }

    }
    
    private func uploadFile() {
        if self.ds != nil && self.sessionId != nil {
            let readStreamBytes = self.ds!.read(self.buffer, maxLength: self.bufferSize)
            if readStreamBytes == 0 { return }
            
            let chunkPtr = Array(UnsafeBufferPointer(start: self.buffer, count: readStreamBytes))
            let ciphertextChunk = try! AES.GCM.seal(Data(chunkPtr), using: self.aesKey, nonce: self.nonce)
            self.fileAESTags.append(ciphertextChunk.tag)
                        
            let startRange = self.bytesTransferred
            let endRange = self.bytesTransferred + readStreamBytes - 1
            MicrosoftOneDriveService.shared.uploadFileInChunks(
                chunk: ciphertextChunk.ciphertext,
                bytes: "\(startRange)-\(endRange)/\(self.fileSize!)",
                chunkSize: readStreamBytes,
                resumableURL: self.sessionId!
            ) { response in
                if self.ds!.hasBytesAvailable {
                    self.bytesTransferred += readStreamBytes
                    self.uploadFile()
                }
                if (200...201).contains(response.code) {
                    guard let fileInfo = try? JSONDecoder().decode(MicrosoftOneDriveFileResponse.self, from: response.data) else {
                        DispatchQueue.main.async {
                            if ApplicationStore.shared.uistate.error == nil {
                                ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                            }
                        }
                        return
                    }
                    self.uploadedFileID = fileInfo.id
                    self.distributeKeyShares(fileOwningCloud: .microsoft)
                }
            }
        }
    }
}
