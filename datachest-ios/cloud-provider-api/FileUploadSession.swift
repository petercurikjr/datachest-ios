//
//  FileUploadSession.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 13/03/2022.
//

import Foundation
import CryptoKit

class FileUploadSession: CommonCloudContainer {
    let url: URL
    let buffer: UnsafeMutablePointer<UInt8>
    let bufferSize: Int
    let aesKey: SymmetricKey
    let nonce: AES.GCM.Nonce
    let fileExtension: String
    let fileName: String
    
    var ds: InputStream?
    var sessionId: String?
    var fileSize: Int?
    
    var fileAESTags: [Data] = []
    var uploadedFileID = ""
    var uploadedGoogleDriveKeyShareFileId = ""
    var uploadedMicrosoftOneDriveKeyShareFileId = ""
    var uploadedDropboxKeyShareFileId = ""
    
    init(fileUrl: URL, bufferSize: DatachestFileBufferSizes) {
        self.url = fileUrl
        self.bufferSize = bufferSize.size
        self.buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: self.bufferSize)
        self.aesKey = SymmetricKey(size: .bits128)
        self.nonce = AES.GCM.Nonce()
        self.fileName = fileUrl.deletingPathExtension().lastPathComponent
        self.fileExtension = fileUrl.pathExtension
        
        do {
            let fs = try fileUrl.resourceValues(forKeys: [.fileSizeKey]).fileSize
            self.fileSize = fs
            if fs != nil {
                self.ds = InputStream(url: fileUrl)!
                self.ds!.open()
            }
        }
        catch {
            ApplicationStore.shared.uistate.error = ApplicationError(error: .readIO)
        }
    }
    
    func splitAESKey() -> [String] {
        let keyb64 = self.aesKey.withUnsafeBytes { rawKey in
            return Data(Array(rawKey)).base64EncodedString()
        }
        
        return ShamirSecretSharingService.shared.split(secretInput: keyb64)
    }
    
    func distributeKeyShares(fileOwningCloud: DatachestSupportedClouds) {
        let keyShares = self.splitAESKey()
        let rawNonce = self.nonce.withUnsafeBytes { raw in Data(Array(raw)).base64EncodedString() }
        var keyShareFiles: [DatachestKeyShareFile] = []
        var keyShareFilesJson: [Data?] = []
        
        for i in 0..<DatachestSupportedClouds.allValues.count {
            if DatachestSupportedClouds.allValues[i] == fileOwningCloud {
                keyShareFiles.append(DatachestKeyShareFile(keyShare: keyShares[i], mappedFileData: DatachestMappedFileData(fileId: self.uploadedFileID, aesTag: self.fileAESTags, aesNonce: rawNonce, fileType: self.fileExtension)))
            }
            else {
                keyShareFiles.append(DatachestKeyShareFile(keyShare: keyShares[i], mappedFileData: nil))
            }
            keyShareFilesJson.append(try? JSONEncoder().encode(keyShareFiles[i]))
        }
        
        let group = DispatchGroup()
        group.enter()
        let _ = GoogleDriveFileUploadSession(fileUrl: self.url) { gd in
            gd.createNewUploadSession(destinationFolder: .keyshareAndMetadata, fileName: self.uploadedFileID) { resumableURL in
                if resumableURL != nil {
                    GoogleDriveService.shared.uploadKeyShareFile(file: keyShareFilesJson[0], resumableURL: resumableURL!) { response in
                        guard let keyShareFile = try? JSONDecoder().decode(GoogleDriveFileResponse.self, from: response.data) else {
                            DispatchQueue.main.async {
                                ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                            }
                            return
                        }
                        self.uploadedGoogleDriveKeyShareFileId = keyShareFile.id
                        group.leave()
                    }
                }
                else {
                    // err
                }
            }
        }
        group.enter()
        MicrosoftOneDriveService.shared.uploadKeyShareFile(file: keyShareFilesJson[1], fileName: self.uploadedFileID) { response in
            guard let keyShareFile = try? JSONDecoder().decode(MicrosoftOneDriveFileResponse.self, from: response.data) else {
                DispatchQueue.main.async {
                    ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                }
                return
            }
            self.uploadedMicrosoftOneDriveKeyShareFileId = keyShareFile.id
            group.leave()
        }
        group.enter()
        let uploadArg = DropboxCreateItemCommit(path: "\(DatachestFolders.keyshareAndMetadata.full)/\(self.uploadedFileID)", mode: "add", autorename: true)
        if let jsonData = try? JSONEncoder().encode(uploadArg) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                DropboxService.shared.uploadKeyShareFile(file: keyShareFilesJson[2], uploadArg: jsonString) { response in
                    guard let keyShareFile = try? JSONDecoder().decode(DropboxFileResponse.self, from: response.data) else {
                        DispatchQueue.main.async {
                            ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                        }
                        return
                    }
                    self.uploadedDropboxKeyShareFileId = keyShareFile.id
                    group.leave()
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.writeDocumentToFirestore(documentName: (fileOwningCloud == .dropbox ? "id:" : "") + self.uploadedFileID)
        }
    }
    
    private func writeDocumentToFirestore(documentName: String) {
        self.db.collection(FirestoreCollections.files.rawValue).document(documentName).setData([
            "googleDriveShare": self.uploadedGoogleDriveKeyShareFileId,
            "microsoftOneDriveShare": self.uploadedMicrosoftOneDriveKeyShareFileId,
            "dropboxShare": self.uploadedDropboxKeyShareFileId
        ]) { err in
            if err != nil {
                ApplicationStore.shared.uistate.error = ApplicationError(error: .db)
            }
        }
    }
}
