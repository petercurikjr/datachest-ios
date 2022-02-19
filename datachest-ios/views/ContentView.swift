//
//  ContentView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 25/11/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var googleAuthService: GoogleAuthService
    @EnvironmentObject var microsoftAuthService: MicrosoftAuthService
    @EnvironmentObject var dropboxAuthService: DropboxAuthService
    
    var body: some View {
        Button(action: googleAuthService.signInGoogle) {
            Text("Sign in with Google")
        }
        Button(action: googleAuthService.signOutGoogle) {
            Text("Sign out from Google")
        }.padding(.bottom)
        Button(action: microsoftAuthService.signInMicrosoft) {
            Text("Sign in with Microsoft")
        }
        Button(action: microsoftAuthService.signOutMicrosoft) {
            Text("Sign out from Microsoft")
        }.padding(.bottom)
        Button(action: dropboxAuthService.signInDropbox) {
            Text("Sign in with Dropbox")
        }
        Button(action: dropboxAuthService.signOutDropbox) {
            Text("Sign out from Dropbox")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
