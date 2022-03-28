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
    
    var ds: InputStream?
    var fileSize: Int?
    var sessionId: String?
    
    var fileAESTags: [Data] = []
    var uploadedFileID = ""
    
    init(fileUrl: URL, bufferSize: Int) {
        self.url = fileUrl
        self.bufferSize = bufferSize
        self.buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: self.bufferSize)
        self.aesKey = SymmetricKey(size: .bits128)
        self.nonce = AES.GCM.Nonce()
        
        do {
            let fs = try fileUrl.resourceValues(forKeys: [.fileSizeKey]).fileSize
            self.fileSize = fs
            if fs != nil {
                self.ds = InputStream(url: fileUrl)!
                self.ds!.open()
            }
        }
        catch {
            print("error while getting file size.")
        }
    }
    
    func splitAESKey() -> [String] {
        let keyb64 = self.aesKey.withUnsafeBytes { rawKey in
            return Data(Array(rawKey)).base64EncodedString()
        }
        
        return ShamirSecretSharingService.shared.split(secretInput: keyb64)
    }
    
    func distributeKeyShares() {
        // TODO METADATA VLOZIT KU CLOUDU KTORY MA POVODNY SUBOR
        let rand = Int.random(in: 0..<DatachestSupportedClouds.allValues.count)
        let keyShares = self.splitAESKey()
        let rawNonce = self.nonce.withUnsafeBytes { raw in Data(Array(raw)).base64EncodedString() }
        var keyShareFiles: [DatachestKeyShareFile] = []
        var keyShareFilesJson: [Data?] = []
        
        for i in 0..<DatachestSupportedClouds.allValues.count {
            if i == rand {
                keyShareFiles.append(DatachestKeyShareFile(keyShare: keyShares[i], mappedFileData: DatachestMappedFileData(fileId: self.uploadedFileID, aesTag: self.fileAESTags, aesNonce: rawNonce)))
            }
            else {
                keyShareFiles.append(DatachestKeyShareFile(keyShare: keyShares[i], mappedFileData: nil))
            }
            keyShareFilesJson.append(try? JSONEncoder().encode(keyShareFiles[i]))
        }
        
        let gd = GoogleDriveFileUploadSession(fileUrl: self.url)
        gd.createNewUploadSession(destinationFolder: .keyshareAndMetadata, fileName: self.uploadedFileID) { resumableURL in
            if resumableURL != nil {
                GoogleDriveService.shared.uploadKeyShareFile(file: keyShareFilesJson[0], resumableURL: resumableURL!)
            }
            else {
                // err
            }
        }
        MicrosoftOneDriveService.shared.uploadKeyShareFile(file: keyShareFilesJson[1], fileName: self.uploadedFileID)
        let uploadArg = DropboxUploadFileCommit(path: "/Datachest/Keys/\(self.uploadedFileID)", mode: "add", autorename: true)
        if let jsonData = try? JSONEncoder().encode(uploadArg) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                DropboxService.shared.uploadKeyShareFile(file: keyShareFilesJson[2], uploadArg: jsonString)
            }
        }
    }
}
