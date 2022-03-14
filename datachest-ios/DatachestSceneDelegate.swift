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
                    print("DROPBOX signed in.", token.accessToken)
                    self.handleToken(token)
                  case .cancel:
                    print("Authorization flow was manually canceled by user!")
                  case .error(_, let description):
                    print("Error: \(String(describing: description))")
                }
            }
        }
        
        for context in URLContexts {
            // stop iterating after the first handle-able url
            if DropboxClientsManager.handleRedirectURL(context.url, completion: oauthCompletion) { break }
        }
    }
    
    private func handleToken(_ token: DropboxAccessToken?) {
        guard token != nil else {
            return
        }
        
        let accessToken = token!.accessToken
        
        KeychainHelper.shared.saveToKeychain(string: accessToken, service: "access-token", account: "dropbox")
        SignedUser.shared.dropboxAccessToken = accessToken
    }
}
