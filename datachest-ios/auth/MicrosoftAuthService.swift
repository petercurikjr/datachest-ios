//
//  MicrosoftAuthService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 19/02/2022.
//

import SwiftUI
import MSAL

class MicrosoftAuthService: ObservableObject {
    var authority: MSALB2CAuthority?
    var pcaConfig: MSALPublicClientApplicationConfig?
    var application: MSALPublicClientApplication?
    var signedInAccount: MSALAccount?
    
    init() {
        do {
            self.authority = try MSALB2CAuthority(url: URL(string: "https://login.microsoftonline.com/common")!)
            self.pcaConfig = MSALPublicClientApplicationConfig(clientId: "b2b3ccb2-a174-4834-9ad3-bc7f68accdf7", redirectUri: nil, authority: authority)
            self.application = try MSALPublicClientApplication(configuration: pcaConfig!)
        }
        catch {
            print(error)
        }
    }
    
    func signInMicrosoft() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        let webViewParameters = MSALWebviewParameters(authPresentationViewController: rootViewController)
        let interactiveParameters = MSALInteractiveTokenParameters(scopes: ["User.Read", "Files.ReadWrite"], webviewParameters: webViewParameters)
        
        application?.acquireToken(with: interactiveParameters) { result, error in
            print("MICROSOFT signed in.", (result?.accessToken) ?? "no token")
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
            
            print("MICROSOFT signed out.")
        }
    }
    
    private func handleUser(_ user: MSALResult?) {
        guard user != nil else {
            return
        }
        
        let accessToken = user!.accessToken
        
        KeychainHelper.shared.saveToKeychain(string: accessToken, service: "access-token", account: "microsoft")
        SignedUser.shared.microsoftAccessToken = accessToken
    }
}
