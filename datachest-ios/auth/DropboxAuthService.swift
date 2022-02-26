//
//  DropboxAuthService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 19/02/2022.
//

import SwiftyDropbox

class DropboxAuthService: ObservableObject {
    
    init() {
        DropboxClientsManager.setupWithAppKey("l53u25g8913p5mg")
    }
    
    func signInDropbox() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }

        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read files.content.read files.content.write files.metadata.read"], includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(UIApplication.shared, controller: rootViewController, loadingStatusDelegate: nil, openURL: { _ in }, scopeRequest: scopeRequest)
    }
    
    func signOutDropbox() {
        print("DROPBOX signed out.")
        DropboxClientsManager.unlinkClients()
    }
    
    func getDropboxAccessTokenFromKeychain() {
        let db = DropboxOAuthManager(appKey: "l53u25g8913p5mg")
        print((db.getFirstAccessToken()?.accessToken) ?? "no access token")
    }
}

