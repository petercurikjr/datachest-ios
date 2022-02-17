//
//  Cipher.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 25/11/2021.
//

import Foundation
import CryptoKit

class Cipher {
    init() {
        loginGoogle()
        
        let key = SymmetricKey(size: .bits128)
        let bufferSize = 1000000 // 1MB
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)

        if let path = Bundle.main.path(forResource: "test-AES copy", ofType: "txt") {
            let dataStream = InputStream(fileAtPath: path)!
            dataStream.open()
            
            let start = DispatchTime.now()
            var counter = 0
            while dataStream.hasBytesAvailable {
                // encrypt
                dataStream.read(buffer, maxLength: bufferSize)
                let chunkPtr = Array(UnsafeBufferPointer(start: buffer, count: bufferSize))
                let ciphertextChunk = try! AES.GCM.seal(Data(chunkPtr), using: key)
                //print(String(decoding: (ciphertextChunk.ciphertext), as: UTF8.self))
                
                // decrypt
                let sealedBox = try! AES.GCM.SealedBox(combined: ciphertextChunk.combined!)
                let plaintextChunk = try! AES.GCM.open(sealedBox, using: key)
                //print(String(decoding: plaintextChunk, as: UTF8.self))
                //print("\n\n\n\n\n")
                counter+=1
                //print(counter)
            }
            let end = DispatchTime.now()

            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
            print(Double(nanoTime) / 1_000_000_000)
        }
    }
}
