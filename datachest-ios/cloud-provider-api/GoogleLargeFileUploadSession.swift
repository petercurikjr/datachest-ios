//
//  GoogleLargeFileUploadSession.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 12/03/2022.
//

import CryptoKit
import Foundation

class GoogleLargeFileUploadSession {
    let url: URL
    let buffer: UnsafeMutablePointer<UInt8>
    let bufferSize = 4*262144 // 4*256 kB
    let aesKey: SymmetricKey
    
    var ds: InputStream?
    var fileSize: Int?
    var resumableUrl: String?
    var bytesTransferred = 0
    
    init(fileUrl: URL) {
        self.url = fileUrl
        self.buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: self.bufferSize)
        self.aesKey = SymmetricKey(size: .bits128)
        
        do {
            let fs = try fileUrl.resourceValues(forKeys: [.fileSizeKey]).fileSize
            self.fileSize = fs
            if fs != nil {
                self.ds = InputStream(url: fileUrl)!
                self.ds!.open()
                GoogleDriveService.shared.getResumableUploadURL { data, response, error in
                    if response != nil {
                        self.resumableUrl = response!.headers.dictionary["Location"]
                        self.upload()
                    }
                }
            }
        }
        catch {
            print("error while getting file size.")
        }
    }
    
    private func upload() {
        if self.ds != nil && self.resumableUrl != nil {
            let readStreamBytes = self.ds!.read(self.buffer, maxLength: self.bufferSize)
            if readStreamBytes == 0 { return }
            
            let chunkPtr = Array(UnsafeBufferPointer(start: self.buffer, count: readStreamBytes))
            let ciphertextChunk = try! AES.GCM.seal(Data(chunkPtr), using: self.aesKey)
            
            //print(ByteCountFormatter().string(fromByteCount: Int64(ciphertextChunk.ciphertext.count)), ByteCountFormatter().string(fromByteCount: Int64(Data(chunkPtr).count)))
            
            let startRange = self.bytesTransferred
            let endRange = self.bytesTransferred + readStreamBytes - 1
            GoogleDriveService.shared.uploadLargeFile(
                chunk: ciphertextChunk.ciphertext,
                bytes: "\(startRange)-\(endRange)/\(self.fileSize!)",
                chunkSize: readStreamBytes,
                resumableURL: self.resumableUrl!
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
                            print("finished")
                        }
                    }
                }
            }
        }
    }
}
/*
 var url
 var ds
 var buffer
 let bufferSize = 256000
 var key
 
 init(url) {
    self.url = url
    self.ds = InputStream(url)
    self.ds.open()
    self.key = SymmetricKey(size: .bits128)
    self.buffer = UnsafeMutablePointer<UInt8>.allocate(self.bufferSize)
    upload()
 }
 
 upload() {
    self.ds.read(self.buffer, self.bufferSize)
    let chunkPtr = Array(UnsafeBufferPointer(start: self.buffer, count: self.bufferSize))
    let ciphertextChunk = try! AES.GCM.seal(Data(chunkPtr), using: self.key)

    GoogleDriveService.shared.uploadLargeFile() {
        if error {
            // TODO upload has stopped
        }
 
        else {
             if self.ds.hasBytesAvailable {
                 upload()
             }
             else {
                 // TODO file uploaded successfully
             }
        }
    }
 }
 */
