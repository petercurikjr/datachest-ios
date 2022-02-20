//
//  DatachestSceneDelegate.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 20/02/2022.
//

import Foundation
import SwiftyDropbox

class DatachestSceneDelegate: NSObject, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
         let oauthCompletion: DropboxOAuthCompletion = {
            if let authResult = $0 {
                switch authResult {
                  case .success(let accessToken):
                    print(accessToken.accessToken)
                    print("Success! User is logged into DropboxClientsManager.")
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
}
