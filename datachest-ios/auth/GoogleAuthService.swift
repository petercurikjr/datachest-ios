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
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                print("GOOGLE signed in.", (user?.authentication.accessToken)!, (user?.grantedScopes)!)
                self.handleUser(user)
            }
        }
        else {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }

            GIDSignIn.sharedInstance.signIn(with: self.config, presenting: rootViewController) { user, error in
                print("GOOGLE signed in.", (user?.authentication.accessToken)!, (user?.grantedScopes)!)
                GIDSignIn.sharedInstance.addScopes(["https://www.googleapis.com/auth/drive"], presenting: rootViewController, callback: { user, error in
                    self.handleUser(user)
                })
            }
        }
    }
    
    func signOutGoogle() {
        GIDSignIn.sharedInstance.signOut()
        print("GOOGLE signed out.")
    }
    
    private func handleUser(_ user: GIDGoogleUser?) {
        guard user != nil else {
            return
        }
        
        let accessToken = user!.authentication.accessToken
        
        KeychainHelper.shared.saveToKeychain(string: accessToken, service: "access-token", account: "google")
        SignedUser.shared.googleAccessToken = accessToken
    }
}
