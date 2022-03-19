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
        /// Pravdepodobne netreba telo requestu pri ziadani resumable URL
//        let fileMetadata = MicrosoftOneDriveResumableUploadRequest(
//            item: MicrosoftOneDriveResumableUploadItemMetadata(
//                conflictBehaviour: "rename",
//                name: "testFileName.dat")
//        )
//        guard let fileMetadataJson = try? JSONEncoder().encode(fileMetadata) else {
//            print("error encoding")
//            return
//        }
        
        MicrosoftOneDriveService.shared.createUploadSession(fileName: "testfilename", fileMetadata: nil) { data, response, error in
            if data != nil {
                //print(String(data: data!, encoding: .utf8)!)
                guard let resumableUploadResponse = try? JSONDecoder().decode(MicrosoftOneDriveResumableUploadResponse.self, from: data!) else {
                    print("error decoding")
                    return
                }
                
                self.sessionId = resumableUploadResponse.uploadUrl
                self.upload()
            }
        }
//        MicrosoftOneDriveService.shared.getFolderContents() { data, response, error in
//            if data != nil {
//                guard let myObj = try? JSONDecoder().decode(MicrosoftOneDriveResponse.self, from: data!) else {
//                    print("error")
//                    return
//                }
//                if myObj.value.contains(where: { child in child.name == "Datachest" }) {
//                    self.upload()
//                }
//                else {
//                    // vytvor priecinok Datachest
//                }
//            }
//        }
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
            ) { data, response, error in
                print(response!.statusCode)
                print(String(data: data!, encoding: .utf8)!)
                if self.ds!.hasBytesAvailable {
                    self.bytesTransferred += readStreamBytes
                    self.upload()
                }
            }
        }
    }
}

//if data != nil {
//    let jsonRawObject = try? JSONSerialization.jsonObject(with: data!, options: [])
//    if let dictionary = jsonRawObject as? [String: Any] {
//        if let children = dictionary["value"] as? [Any] {
//            let hasRequiredFolder = children.contains { obj in
//                if let child = obj as? [String: Any] {
//                    if child["name"] as! String == "Datachest" {
//                        return true
//                    }
//                    else {
//                        return false
//                    }
//                }
//                else {
//                    return false
//                }
//            }
//
//            if hasRequiredFolder {
//                self.upload()
//            }
//            else {
//                let folderMetadata = Data()
//                MicrosoftOneDriveService.shared.createFolder(parentId: "root", folderMetadata: folderMetadata) { data, response, error in
//                    if error != nil {
//                        print("remote is down. details: ", error!)
//                    }
//
//                    if response != nil {
//                        if (200...299).contains(response!.statusCode) {
//                            print("unacceptable response code: ", response!.statusCode)
//                        }
//
//                        else {
//                            print("good", response!.statusCode)
//                            if self.ds!.hasBytesAvailable {
//                                self.bytesTransferred += readStreamBytes
//                                self.upload()
//                            }
//                            else {
//                                print("finished: ", data!)
//                            }
//                        }
//                    }
//                    self.upload()
//                }
//            }
//        }
//    }
//}
