//
//  KeychainHelper.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 08/03/2022.
//

import Foundation

class KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}
    
    func saveToKeychain(value: Data, service: String, account: String) {
        let query = [
            kSecValueData: value,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        if status == errSecDuplicateItem {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account,
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: value] as CFDictionary
            SecItemUpdate(query, attributesToUpdate)
        }
        else if status != errSecSuccess {
            print("Error when writing data to the keychain: \(status)")
        }
    }
    
    func loadFromKeychain(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return result as? Data
    }
}
