//
//  GoogleDriveFileUploadSession.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 12/03/2022.
//

import CryptoKit
import Foundation

class GoogleDriveFileUploadSession: FileUploadSession {
    var bytesTransferred = 0
    
    init(fileUrl: URL, completion: @escaping (GoogleDriveFileUploadSession) -> Void) {
        super.init(fileUrl: fileUrl, bufferSize: .googleDrive)
        self.googleDriveGetOrCreateAllFolders() { completion(self) }
    }
    
    func createNewUploadSession(destinationFolder: DatachestFolders, fileName: String?, completion: @escaping (String?) -> Void) {
        let metadata = GoogleDriveCreateItemMetadata(
            name: fileName == nil ? self.fileName : fileName!,
            mimeType: GoogleDriveItemMimeType.file.rawValue,
            parents: [ApplicationStore.shared.state.googleDriveFolderIds[destinationFolder] ?? ""]
        )
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .withoutEscapingSlashes
        if let jsonData = try? jsonEncoder.encode(metadata) {
            GoogleDriveService.shared.getResumableUploadURL(metadata: jsonData) { response in
                if response.headers != nil {
                    self.sessionId = response.headers!["Location"]
                    completion(response.headers!["Location"])
                }
            }
        }
    }
    
    func uploadFile() {
        if self.ds != nil && self.sessionId != nil {
            let readStreamBytes = self.ds!.read(self.buffer, maxLength: self.bufferSize)
            if readStreamBytes == 0 { return }

            let chunkPtr = Array(UnsafeBufferPointer(start: self.buffer, count: readStreamBytes))
            let ciphertextChunk = try! AES.GCM.seal(Data(chunkPtr), using: self.aesKey, nonce: self.nonce)
            self.fileAESTags.append(ciphertextChunk.tag)
            
            let startRange = self.bytesTransferred
            let endRange = self.bytesTransferred + readStreamBytes - 1
            GoogleDriveService.shared.uploadFileInChunks(
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
                    guard let fileInfo = try? JSONDecoder().decode(GoogleDriveFileResponse.self, from: response.data) else {
                        DispatchQueue.main.async {
                            ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                        }
                        return
                    }
                    self.uploadedFileID = fileInfo.id
                    self.createNewUploadSession(destinationFolder: .keyshareAndMetadata, fileName: self.uploadedFileID) { _ in
                        self.distributeKeyShares(fileOwningCloud: .google)
                    }
                }
            }
        }
    }
}
