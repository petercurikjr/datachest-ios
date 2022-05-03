//
//  LoginView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 03/05/2022.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    Text("You have to sign in to all accounts before using Datachest.")
                }
                Spacer()
                VStack {
                    Button(action: GoogleAuthService.shared.signInGoogle) {
                        HStack {
                            VStack {
                                Image("google")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25, alignment: .center)
                            }
                            Text("Sign in with Google")
                        }
                    }.buttonStyle(DatachestButton())
                }.padding()
                VStack {
                    Button(action: MicrosoftAuthService.shared.signInMicrosoft) {
                        HStack {
                            VStack {
                                Image("microsoft")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25, alignment: .center)
                            }
                            Text("Sign in with Microsoft")
                        }
                    }.buttonStyle(DatachestButton())
                }.padding()
                VStack {
                    Button(action: DropboxAuthService.shared.signInDropbox) {
                        HStack {
                            VStack {
                                Image("dropbox")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25, alignment: .center)
                            }
                            Text("Sign in with Dropbox")
                        }
                    }.buttonStyle(DatachestButton())
                }.padding()
                Spacer()
                Spacer()
            }.padding(30).navigationTitle("Sign in")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
