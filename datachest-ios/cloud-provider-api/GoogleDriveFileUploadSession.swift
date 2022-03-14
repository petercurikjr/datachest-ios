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
        GoogleDriveService.shared.getResumableUploadURL { data, response, error in
            if response != nil {
                self.sessionId = response!.headers.dictionary["Location"]
                self.upload()
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
            ) { data, response, error in
                if error != nil {
                    print("remote is down. details: ", error!)
                }
                
                if response != nil {
                    if !(200...299).contains(response!.statusCode) && !(response!.statusCode == 308) {
                        print("unacceptable response code: ", response!.statusCode)
                    }
                    
                    else {
                        print("good", response!.statusCode)
                        if self.ds!.hasBytesAvailable {
                            self.bytesTransferred += readStreamBytes
                            self.upload()
                        }
                        else {
                            print("finished: ", data!)
                        }
                    }
                }
            }
        }
    }
}
