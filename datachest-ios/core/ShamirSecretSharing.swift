//
//  ShamirSecretSharingService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 25/11/2021.
//

import Foundation
import SwiftySSS

class ShamirSecretSharingService {
    static let shared = ShamirSecretSharingService()
    private init() {}
    
    func split(secretInput: String) -> [String] {
        let message = Data([UInt8](secretInput.utf8))
        let secret = try! Secret(data: message, threshold: DatachestSupportedClouds.allValues.count - 1, shares: DatachestSupportedClouds.allValues.count)
        let shares = try! secret.split()
            
        var ret = [String]()
        
        shares.forEach { share in
            ret.append(share.description)
        }
        
        return ret
    }
    
    func combine(secretInput: [String]) -> String {
        let sharesObjects = secretInput.compactMap { try? Secret.Share(string: $0) }
        let someShares = [Secret.Share](sharesObjects[1...2])

        let secretData = try! Secret.combine(shares: someShares)
        return String(data: secretData, encoding: .utf8) ?? ""
    }
}

