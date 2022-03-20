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
    
    init(fileUrl: URL) {
        super.init(fileUrl: fileUrl, bufferSize: 4*262144)
        self.getOrCreateFolder(folderName: "Datachest", parentId: nil) { datachestFolderId in
            self.getOrCreateFolder(folderName: "Files", parentId: datachestFolderId) { filesFolderId in
                let metadata = GoogleDriveCreateItemMetadata(
                    name: "testfilename",
                    mimeType: GoogleDriveItemMimeType.file.rawValue,
                    parents: [filesFolderId]
                )
                let jsonEncoder = JSONEncoder()
                jsonEncoder.outputFormatting = .withoutEscapingSlashes
                if let jsonData = try? jsonEncoder.encode(metadata) {
                    GoogleDriveService.shared.getResumableUploadURL(metadata: jsonData) { response in
                        if response.headers != nil {
                            self.sessionId = response.headers!["Location"]
                            self.upload()
                        }
                    }
                }
            }
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
            GoogleDriveService.shared.uploadFile(
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
    
    private func getOrCreateFolder(folderName: String, parentId: String?, completion: @escaping (String) -> Void) {
        let query = "?q=name+%3d+%27\(folderName)%27+and+mimeType+%3d+%27\(GoogleDriveItemMimeType.folder.rawValue)%27+and+trashed+%3d+false" +
            (parentId != nil ? "+and+%27\(parentId!)%27+in+parents" : "")
        
        GoogleDriveService.shared.listFiles(q: query) { response in
            guard let items = try? JSONDecoder().decode(GoogleDriveListFilesResponse.self, from: response.data) else {
                print("error decoding")
                return
            }

            if items.files.contains(where: { item in item.name == folderName }) {
                completion(items.files.first(where: { item in item.name == folderName })!.id)
            }
            else {
                let metadata = GoogleDriveCreateItemMetadata(
                    name: folderName,
                    mimeType: GoogleDriveItemMimeType.folder.rawValue,
                    parents: parentId != nil ? [parentId!] : nil
                )
                let jsonEncoder = JSONEncoder()
                jsonEncoder.outputFormatting = .withoutEscapingSlashes
                if let jsonData = try? jsonEncoder.encode(metadata) {
                    GoogleDriveService.shared.createFolder(metadata: jsonData) { response in
                        guard let createdFolder = try? JSONDecoder().decode(GoogleDriveFileResponse.self, from: response.data) else {
                            print("error decoding")
                            return
                        }

                        if createdFolder.name == folderName {
                            completion(createdFolder.id)
                        }
                    }
                }
            }
        }
    }
}
