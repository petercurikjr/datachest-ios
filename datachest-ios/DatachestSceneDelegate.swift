//
//  DatachestSceneDelegate.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 20/02/2022.
//

import SwiftyDropbox

class DatachestSceneDelegate: NSObject, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
         let oauthCompletion: DropboxOAuthCompletion = {
            if let authResult = $0 {
                switch authResult {
                  case .success(let token):
                    self.handleToken(token)
                  case .cancel:
                    print("Authorization flow was manually canceled by user!")
                  case .error(_, let description):
                    print("Error: \(String(describing: description))")
                }
            }
        }
        
        for context in URLContexts {
            if DropboxClientsManager.handleRedirectURL(context.url, completion: oauthCompletion) { break }
        }
    }
    
    private func handleToken(_ token: DropboxAccessToken?) {
        if let token = token {
            let keychainItem = DatachestDropboxAuthKeychainItem(accessTokenExpirationDate: Date().addingTimeInterval(TimeInterval(14400)))
            if let jsonData = try? JSONEncoder().encode(keychainItem) {
                KeychainHelper.shared.saveToKeychain(value: jsonData, service: "datachest-auth-keychain-item", account: "dropbox")
            }
            
            ApplicationStore.shared.setDropboxAccessToken(token: token.accessToken)
            UserDefaults.standard.setValue(false, forKey: "signed-out-dropbox")
            print("DROPBOX signed in.", token.accessToken)
        }
    }
}
