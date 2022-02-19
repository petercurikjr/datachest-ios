//
//  MicrosoftAuthService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 19/02/2022.
//

import Foundation
import MSAL
import SwiftUI

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
            print((result?.accessToken) ?? "no token")
            self.signedInAccount = result?.account
        }
        
//        provider = OAuthProvider(providerID: "microsoft.com")
//
//        provider?.getCredentialWith(nil) { credential, error in
//            if let error = error {
//                print(error)
//            }
//            if credential != nil {
//                Auth.auth().signIn(with: credential!) { authResult, error in
//                    print(authResult)
//                }
//            }
//        }
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
            
            print("signed out from Microsoft")
        }
    }
}
