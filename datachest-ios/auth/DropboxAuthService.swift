//
//  DropboxAuthService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 19/02/2022.
//

import SwiftyDropbox

class DropboxAuthService {
    static let shared = DropboxAuthService()
    private init() {
        DropboxClientsManager.setupWithAppKey("l53u25g8913p5mg")
    }
    
    func signInDropbox() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }

        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read files.content.read files.content.write files.metadata.read"], includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(UIApplication.shared, controller: rootViewController, loadingStatusDelegate: nil, openURL: { _ in }, scopeRequest: scopeRequest)
    }
    
    // platnost db tokenu 4 hodiny
    
    // ak sa nepodari ziskat token silently, setnut do storu flag ktory bude v UI indikovat ze sa treba prihlasit
    func signInDropboxSilently() {
        if let accessTokenProvider = DropboxClientsManager.authorizedClient?.auth.client.accessTokenProvider {
            // apparently toto s tym refreshAcessTokenIfNecessary tu vobec netreba
            accessTokenProvider.refreshAccessTokenIfNecessary { res in
                switch res {
                case .success(let token): break
                    //print("refreshed Dropbox sign in. token \(token.accessToken), valid until \(Date(timeIntervalSinceNow: token.tokenExpirationTimestamp!))")
                    //SignedUser.shared.dropboxAccessToken = token.accessToken
                case .error(_, _): break
                case .cancel: break
                case .none: break
                }
            }
            
            ApplicationStore.shared.state.dropboxAccessToken = accessTokenProvider.accessToken
        }
    }
    
    func signOutDropbox() {
        print("DROPBOX signed out.")
        DropboxClientsManager.unlinkClients()
    }
}

