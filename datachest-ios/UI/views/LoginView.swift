//
//  LoginView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 03/05/2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var state: ApplicationStore
    var description: String
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    Text(self.description)
                }
                Spacer()
                if !self.state.uistate.signedInGoogle {
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
                }

                if !self.state.uistate.signedInMicrosoft {
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
                }
                
                if !self.state.uistate.signedInDropbox {
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
                }
                Spacer()
                Spacer()
            }.padding(30).navigationTitle("Sign in")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(description: "Test desc")
    }
}
