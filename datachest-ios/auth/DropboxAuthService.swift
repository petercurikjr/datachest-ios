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
        
    func signInDropboxSilently() {
        if let accessTokenProvider = DropboxClientsManager.authorizedClient?.auth.client.accessTokenProvider {
            if self.isTokenValid() {
                ApplicationStore.shared.setDropboxAccessToken(token: accessTokenProvider.accessToken)
                print("DROPBOX signed in.", accessTokenProvider.accessToken)
            }
            
            else {
                accessTokenProvider.refreshAccessTokenIfNecessary { res in
                    switch res {
                    case .success(let token):
                        print("refreshed Dropbox sign in. token \(token.accessToken)")
                        let keychainItem = DatachestDropboxAuthKeychainItem(accessTokenExpirationDate: Date().addingTimeInterval(TimeInterval(14400)))
                        if let jsonData = try? JSONEncoder().encode(keychainItem) {
                            KeychainHelper.shared.saveToKeychain(value: jsonData, service: "datachest-auth-keychain-item", account: "dropbox")
                        }
                        
                        ApplicationStore.shared.setDropboxAccessToken(token: token.accessToken)
                        UserDefaults.standard.setValue(false, forKey: "signed-out-dropbox")
                    case .error(_, _): break
                    case .cancel: break
                    case .none: break
                    }
                }
            }
        }
        else {
            ApplicationStore.shared.uistate.signedInDropbox = false
        }
    }
    
    func signOutDropbox() {
        print("DROPBOX signed out.")
        ApplicationStore.shared.uistate.signedInDropbox = false
        UserDefaults.standard.setValue(true, forKey: "signed-out-dropbox")
        DropboxClientsManager.unlinkClients()
    }
    
    func isTokenValid() -> Bool {
        if let keychainItem = KeychainHelper.shared.loadFromKeychain(service: "datachest-auth-keychain-item", account: "dropbox"),
           let object = try? JSONDecoder().decode(DatachestDropboxAuthKeychainItem.self, from: keychainItem) {
            let dateNow = Date()
            let diffMinutes = (Int(object.accessTokenExpirationDate.timeIntervalSince1970 - dateNow.timeIntervalSince1970)) / 60
            print("dbtoken", diffMinutes)
            if diffMinutes < 3 {
                return false
            }
        }
        
        return true
    }
}

