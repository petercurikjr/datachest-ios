//
//  MicrosoftAuthService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 19/02/2022.
//

import SwiftUI
import MSAL

class MicrosoftAuthService {
    static let shared = MicrosoftAuthService()
    private init() {
        do {
            self.authority = try MSALB2CAuthority(url: URL(string: "https://login.microsoftonline.com/common")!)
            self.pcaConfig = MSALPublicClientApplicationConfig(clientId: "b2b3ccb2-a174-4834-9ad3-bc7f68accdf7", redirectUri: nil, authority: authority)
            self.application = try MSALPublicClientApplication(configuration: pcaConfig!)
        }
        catch {
            print(error)
        }
    }
    
    var authority: MSALB2CAuthority?
    var pcaConfig: MSALPublicClientApplicationConfig?
    var application: MSALPublicClientApplication?
    var signedInAccount: MSALAccount?
    
    func signInMicrosoft() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        let webViewParameters = MSALWebviewParameters(authPresentationViewController: rootViewController)
        let interactiveParameters = MSALInteractiveTokenParameters(scopes: ["User.Read", "Files.ReadWrite"], webviewParameters: webViewParameters)
        
        application?.acquireToken(with: interactiveParameters) { result, error in
            self.handleUser(result)
            self.signedInAccount = result?.account
        }
    }
    
    func signOutMicrosoft() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        let webViewParameters = MSALWebviewParameters(authPresentationViewController: rootViewController)
        let signOutParameters = MSALSignoutParameters(webviewParameters: webViewParameters)
        
        guard let accountToSignOut = self.signedInAccount else { return }
        application?.signout(with: accountToSignOut, signoutParameters: signOutParameters) { success, error in
            if let error = error {
                print(error)
                return
            }
            
            ApplicationStore.shared.uistate.signedInMicrosoft = false
            UserDefaults.standard.setValue(true, forKey: "signed-out-microsoft")
            print("MICROSOFT signed out.")
        }
    }
    
    private func handleUser(_ user: MSALResult?) {
        if let user = user, let expireDate = user.expiresOn, let id = user.account.identifier {
            let keychainItem = DatachestMicrosoftAuthKeychainItem(accessTokenExpirationDate: expireDate, accountId: id)
            if let jsonData = try? JSONEncoder().encode(keychainItem) {
                KeychainHelper.shared.saveToKeychain(value: jsonData, service: "datachest-auth-keychain-item", account: "microsoft")
            }
            
            ApplicationStore.shared.setMicrosoftAccessToken(token: user.accessToken)
            UserDefaults.standard.setValue(false, forKey: "signed-out-microsoft")
            print("MICROSOFT signed in.", (user.accessToken))
        }
    }
    
    func signInMicrosoftSilently() {
        if let keychainItem = KeychainHelper.shared.loadFromKeychain(service: "datachest-auth-keychain-item", account: "microsoft"),
           let object = try? JSONDecoder().decode(DatachestMicrosoftAuthKeychainItem.self, from: keychainItem) {
            guard let account = try? application?.account(forIdentifier: object.accountId) else {
                ApplicationStore.shared.uistate.signedInMicrosoft = false
                return
            }
            let silentParameters = MSALSilentTokenParameters(scopes: ["User.Read", "Files.ReadWrite"], account: account)
            application?.acquireTokenSilent(with: silentParameters) { result, error in
                self.handleUser(result)
            }
        }
        else {
            ApplicationStore.shared.uistate.signedInMicrosoft = false
        }
    }
}
