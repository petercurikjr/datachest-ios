//
//  ProfileView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 25/11/2021.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            VStack {
                Button(action: GoogleAuthService.shared.signInGoogle) {
                    Text("Sign in with Google")
                }
                Button(action: GoogleAuthService.shared.signOutGoogle) {
                    Text("Sign out from Google")
                }.padding(.bottom)
            }
            
            VStack {
                Button(action: MicrosoftAuthService.shared.signInMicrosoft) {
                    Text("Sign in with Microsoft")
                }
                Button(action: MicrosoftAuthService.shared.signOutMicrosoft) {
                    Text("Sign out from Microsoft")
                }.padding(.bottom)
            }
            
            VStack {
                Button(action: DropboxAuthService.shared.signInDropbox) {
                    Text("Sign in with Dropbox")
                }
                Button(action: DropboxAuthService.shared.signOutDropbox) {
                    Text("Sign out from Dropbox")
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
