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
            print("GOOGLE signed in.", (user?.authentication.accessToken)!, (user?.grantedScopes)!)
            GIDSignIn.sharedInstance.addScopes(["https://www.googleapis.com/auth/drive"], presenting: rootViewController, callback: { _, _ in })
            self.handleUser(user)
        }
    }
    
    func signOutGoogle() {
        GIDSignIn.sharedInstance.signOut()
        print("GOOGLE signed out.")
    }
    
    private func handleUser(_ user: GIDGoogleUser?) {
        if let user = user {
            let keychainItem = DatachestGoogleAuthKeychainItem(accessTokenExpirationDate: user.authentication.accessTokenExpirationDate)
            if let jsonData = try? JSONEncoder().encode(keychainItem) {
                KeychainHelper.shared.saveToKeychain(value: jsonData, service: "datachest-auth-keychain-item", account: "google")
            }
            SignedUser.shared.googleAccessToken = user.authentication.accessToken
        }
    }
    
    // toto staci zavolat na refresh tokenu
    // google drzi access token po dobu 1 hodiny
    // do keychainu treba ulozit user!.authentication.accessTokenExpirationDate
    // a checkovat expirationDate pred kazdym API volanim. ak bude token uz presne pred expiraciou, zavolaj tuto metodu
    // pozor. token ktory nie je tesne pred vyprsanim/vyprsany nebude googlom obnoveny
    
    // ak sa nepodari ziskat token silently, setnut do storu flag ktory bude v UI indikovat ze sa treba prihlasit
    func signInGoogleSilently() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                print("GOOGLE signed in.", (user?.authentication.accessToken)!, (user?.grantedScopes)!)
                self.handleUser(user)
            }
        }
    }
}
