//
//  GoogleAuthService.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 15/02/2022.
//

import Foundation
import GoogleSignIn
import SwiftUI
//OTAZKA CI BUDEME VOBEC FIREBASE NAKONIEC POTREBOVAT
//LEBO MY POTREBUJEME REALNE ZISKAT IBA ACCESS TOKENY NEPOTREBUJEME SI TYCH PRIHLASENYCH USEROV NIKDE EVIDOVAT A VYUZIVAT PODOBNE FIREBASE-OVSKE VYCHYTAVKY
//DALSIA VEC JE ZE ZREJME BUDEME NUTENI POUZIVAT PRIAMO KNIZNICE OD KAZDEHO CLOUD PROVIDERA, NIE FIREBASE-OVSKE KNIZNICE... LEBO TAM MAJU CHYBY (NAPR PO AUTENTIFIKACII NEVIEM ZISKAT ACCESS TOKEN LEBO JE TO PRIVATE ATTRIBUTE TRIEDY)
import Firebase
import MSAL

class GoogleAuthService: ObservableObject {
    @Published var loggedInGoogle = false
    var provider: OAuthProvider?
    
    func signInGoogle() {
        // sign in user without interaction if there is a previously authenticated user in the keychain
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUserGoogle(user: user, error: error)
            }
        }
        else {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let config = GIDConfiguration(clientID: clientID)

            // set a view where to show the authentication screen
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }

            GIDSignIn.sharedInstance.signIn(with: config, presenting: rootViewController) { [unowned self] user, error in
                authenticateUserGoogle(user: user, error: error)
            }
        }
    }
    
    private func authenticateUserGoogle(user: GIDGoogleUser?, error: Error?) {
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                print(error)
            }
            else {
                print("signed in.", authentication.accessToken)
                self.loggedInGoogle = true
            }
        }
    }
    
    func signOutGoogle() {
        GIDSignIn.sharedInstance.signOut()
        
        do {
            try Auth.auth().signOut()
            print("signed out.")
            self.loggedInGoogle = false
        }
        catch {
            print(error)
        }
    }
}
