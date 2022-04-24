//
//  GoogleAuthService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 15/02/2022.
//

import SwiftUI
import GoogleSignIn

class GoogleAuthService {
    static let shared = GoogleAuthService()
    private init() {
        self.config = GIDConfiguration(clientID: "932213055425-c4r3gu990j7a6ncg0lsffktaf0vgln2m.apps.googleusercontent.com")
    }
    
    let config: GIDConfiguration
    
    func signInGoogle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(with: self.config, presenting: rootViewController) { user, error in
            print("GOOGLE signed in.", (user?.authentication.accessToken) ?? "no token", (user?.grantedScopes) ?? "no scopes")
            GIDSignIn.sharedInstance.addScopes(["https://www.googleapis.com/auth/drive"], presenting: rootViewController, callback: { _, _ in })
            self.handleUser(user)
        }
    }
    
    func signOutGoogle() {
        GIDSignIn.sharedInstance.signOut()
        ApplicationStore.shared.uistate.signedInGoogle = false
        UserDefaults.standard.setValue(true, forKey: "signed-out-google")
        print("GOOGLE signed out.")
    }
    
    private func handleUser(_ user: GIDGoogleUser?) {
        if let user = user {
            let keychainItem = DatachestGoogleAuthKeychainItem(accessTokenExpirationDate: user.authentication.accessTokenExpirationDate)
            if let jsonData = try? JSONEncoder().encode(keychainItem) {
                KeychainHelper.shared.saveToKeychain(value: jsonData, service: "datachest-auth-keychain-item", account: "google")
            }
            
            ApplicationStore.shared.setGoogleAccessToken(token: user.authentication.accessToken)
            UserDefaults.standard.setValue(false, forKey: "signed-out-google")
        }
    }
    
    func signInGoogleSilently() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                print("GOOGLE signed in.", (user?.authentication.accessToken)!, (user?.grantedScopes)!)
                self.handleUser(user)
            }
        }
        else {
            ApplicationStore.shared.uistate.signedInGoogle = false
        }
    }
}
