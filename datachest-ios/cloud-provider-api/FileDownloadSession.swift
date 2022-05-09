//
//  FileDownloadSession.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 25/03/2022.
//

import Foundation
import CryptoKit

class FileDownloadSession: CommonCloudContainer {
    let fileId: String
    let fileName: String
    let bufferSize: Int
    
    var shares: [DatachestKeyShareFile] = []
    
    init(fileId: String, fileName: String, bufferSize: DatachestFileBufferSizes) {
        self.fileId = fileId
        self.fileName = fileName
        self.bufferSize = bufferSize.size
    }
    
    func decryptAndSaveFile(fileUrl: URL) {
        let aesKey = self.recoverAESKey()
        guard
            let nonce = self.getAESNonce(),
            let tags = self.getAESTags(),
            let fileExtension = self.getOriginalFileExtension(),
            let folderURL = DeviceHelper.shared.createOrGetFolder(folder: .files),
            let fileURL = DeviceHelper.shared.createFile(atLocation: folderURL, fileName: "\(self.fileName).\(fileExtension)"),
            let inp = InputStream(url: fileUrl),
            let out = OutputStream(url: fileURL, append: false)
        else {
            return
        }

        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: self.bufferSize)
        inp.open()
        out.open()
        
        var i = 0
        while inp.hasBytesAvailable {
            let readStreamBytes = inp.read(buffer, maxLength: self.bufferSize)
            let chunkPtr = Array(UnsafeBufferPointer(start: buffer, count: readStreamBytes))
            if readStreamBytes == 0 { break }
            
            do {
                let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: chunkPtr, tag: tags[i])
                let plaintextChunk = try AES.GCM.open(sealedBox, using: aesKey)
                plaintextChunk.withUnsafeBytes { unsafeBytes in
                    let bytes = unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
                    out.write(bytes, maxLength: readStreamBytes)
                    i += 1
                }
            }
            catch {
                DispatchQueue.main.async {
                    if ApplicationStore.shared.uistate.error == nil {
                        ApplicationStore.shared.uistate.error = ApplicationError(error: .decryption)
                    }
                }
            }
        }
        inp.close()
        out.close()
    }
    
    func recoverAESKey() -> SymmetricKey {
        let keyShares = self.shares.map { share in share.keyShare }
        let keyStr = ShamirSecretSharingService.shared.combine(secretInput: keyShares)
        return SymmetricKey(data: Data(base64Encoded: keyStr)!)
    }
    
    func getAESNonce() -> AES.GCM.Nonce? {
        var nonce: AES.GCM.Nonce?
        for share in shares {
            if let data = share.mappedFileData {
                nonce = try? AES.GCM.Nonce(data: Data(base64Encoded: data.aesNonce)!)
            }
        }
        return nonce
    }
    
    func getAESTags() -> [Data]? {
        var tags: [Data]?
        for share in shares {
            if let data = share.mappedFileData {
                tags = data.aesTag
            }
        }
        return tags
    }
    
    func getOriginalFileExtension() -> String? {
        var type: String?
        for share in shares {
            if let data = share.mappedFileData {
                type = data.fileType
            }
        }
        return type
    }
    
    func collectKeyShares(completion: @escaping () -> Void) {
        self.readDocumentFromFirestore() { sharesIds in
            let group = DispatchGroup()
            if ApplicationStore.shared.uistate.signedInGoogle {
                group.enter()
                GoogleDriveService.shared.downloadKeyShare(shareId: sharesIds[0]) { response in
                    guard let share = try? JSONDecoder().decode(DatachestKeyShareFile.self, from: response.data) else {
                        DispatchQueue.main.async {
                            if ApplicationStore.shared.uistate.error == nil {
                                ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                            }
                        }
                        return
                    }
                    self.shares.append(share)
                    group.leave()
                }
            }
            if ApplicationStore.shared.uistate.signedInMicrosoft {
                group.enter()
                MicrosoftOneDriveService.shared.downloadKeyShare(shareId: sharesIds[1]) { response in
                    guard let share = try? JSONDecoder().decode(DatachestKeyShareFile.self, from: response.data) else {
                        DispatchQueue.main.async {
                            if ApplicationStore.shared.uistate.error == nil {
                                ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                            }
                        }
                        return
                    }
                    self.shares.append(share)
                    group.leave()
                }
            }
            if ApplicationStore.shared.uistate.signedInDropbox {
                group.enter()
                let downloadArg = DropboxDownloadFileMetadata(path: sharesIds[2])
                if let jsonData = try? JSONEncoder().encode(downloadArg) {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        DropboxService.shared.downloadKeyShare(downloadArg: jsonString) { response in
                            guard let share = try? JSONDecoder().decode(DatachestKeyShareFile.self, from: response.data) else {
                                DispatchQueue.main.async {
                                    if ApplicationStore.shared.uistate.error == nil {
                                        ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                                    }
                                }
                                return
                            }
                            self.shares.append(share)
                            group.leave()
                        }
                    }
                }
            }
            group.notify(queue: DispatchQueue.main) {
                completion()
            }
        }
    }
    
    private func readDocumentFromFirestore(completion: @escaping ([String]) -> Void) {
        let documentRef = self.db.collection("files").document(fileId)
        documentRef.getDocument { document, error in
            if let document = document, document.exists {
                if let raw = try? JSONSerialization.data(withJSONObject: document.data()!, options: []) {
                    guard let data = try? JSONDecoder().decode(FirestoreFileDocument.self, from: raw) else {
                        if ApplicationStore.shared.uistate.error == nil {
                            ApplicationStore.shared.uistate.error = ApplicationError(error: .dataParsing)
                        }
                        return
                    }
                    completion([data.googleDriveShare, data.microsoftOneDriveShare, data.dropboxShare])
                }
            }
            else {
                if ApplicationStore.shared.uistate.error == nil {
                    ApplicationStore.shared.uistate.error = ApplicationError(error: .db)
                }
            }
        }
    }
}
