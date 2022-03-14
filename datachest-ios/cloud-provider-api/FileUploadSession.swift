//
//  FileUploadSession.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 13/03/2022.
//

import Foundation
import CryptoKit

class FileUploadSession {
    let url: URL
    let buffer: UnsafeMutablePointer<UInt8>
    let bufferSize: Int
    let aesKey: SymmetricKey
    
    var ds: InputStream?
    var fileSize: Int?
    var sessionId: String?
    
    init(fileUrl: URL, bufferSize: Int) {
        self.url = fileUrl
        self.bufferSize = bufferSize
        self.buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: self.bufferSize)
        self.aesKey = SymmetricKey(size: .bits128)
        
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
}
