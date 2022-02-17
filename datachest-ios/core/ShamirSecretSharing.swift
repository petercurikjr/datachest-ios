//
//  ShamirSecretSharing.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 25/11/2021.
//

import Foundation
import SwiftySSS

class ShamirSecretSharing {
    init() {
        let shares = split(secretInput: "toto je tajna informacia")
        combine(secretInput: shares)
        
        if let path = Bundle.main.path(forResource: "test", ofType: "txt") {
          do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            splitData(data: data)
          } catch let error {
            print(error)
          }
        }
    }
    
    func split(secretInput: String) -> [String] {
        let message = Data([UInt8](secretInput.utf8))
        let secret = try! Secret(data: message, threshold: 2, shares: 3)
        let shares = try! secret.split()
            
        var ret = [String]()
        
        shares.forEach { share in
            //print(share.description)
            ret.append(share.description)
        }
        
        return ret
    }
    
    func combine(secretInput: [String]) {
        let sharesObjects = secretInput.compactMap { try? Secret.Share(string: $0) }
        let someShares = [Secret.Share](sharesObjects[1...2])

        let secretData = try!  Secret.combine(shares: someShares)
        let secret = String(data: secretData, encoding: .utf8)

        //print(secret!)
    }
    
    func splitData(data: Data) -> [Secret.Share] {
        let secret = try! Secret(data: data, threshold: 2, shares: 3)
        print("before split")
        let start = DispatchTime.now()
        let shares = try! secret.split()
        let end = DispatchTime.now()
        print("after split")
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        print(timeInterval)
        
        return shares
    }
    
    func combineData(secretInput: [Secret.Share]) -> Data {
        let someShares = [Secret.Share](secretInput[1...2])

        let secretData = try!  Secret.combine(shares: someShares)
        let secret = String(data: secretData, encoding: .utf8)

        print(secret!)
        
        return secretData
    }
}

