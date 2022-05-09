//
//  ProfileView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 25/11/2021.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var state: ApplicationStore
    @StateObject private var vm = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                VStack {
                    HStack(alignment: .bottom) {
                        Text("Google").font(.title)
                        Spacer()
                    }.padding(.bottom, 5)
                    HStack(alignment: .bottom) {
                        if self.state.uistate.signedInGoogle {
                            VStack(alignment: .leading) {
                                Text("Signed in as")
                                Text(self.vm.googleName).font(.headline)
                            }.onAppear { self.vm.getProfileNameGoogleDrive() }
                        }
                        else {
                            Text("Not signed in.")
                        }
                        Spacer()
                        if self.state.uistate.signedInGoogle {
                            Button(action: GoogleAuthService.shared.signOutGoogle) {
                                HStack {
                                    VStack {
                                        Image("google")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25, alignment: .center)
                                    }
                                    Text("Sign out")
                                }
                            }.buttonStyle(DatachestButton())
                        }
                        else {
                            Button(action: GoogleAuthService.shared.signInGoogle) {
                                HStack {
                                    VStack {
                                        Image("google")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25, alignment: .center)
                                    }
                                    Text("Sign in")
                                }
                            }.buttonStyle(DatachestButton())
                        }
                    }
                }.padding().background(Color("grey")).overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                Spacer()
                VStack {
                    HStack(alignment: .bottom) {
                        Text("Microsoft").font(.title)
                        Spacer()
                    }.padding(.bottom, 5)
                    HStack(alignment: .bottom) {
                        if self.state.uistate.signedInMicrosoft {
                            VStack(alignment: .leading) {
                                Text("Signed in as")
                                Text(self.vm.microsoftName).font(.headline)
                            }.onAppear { self.vm.getProfileNameMicrosoftOneDrive() }
                        }
                        else {
                            Text("Not signed in.")
                        }
                        Spacer()
                        if self.state.uistate.signedInMicrosoft {
                            Button(action: MicrosoftAuthService.shared.signOutMicrosoft) {
                                HStack {
                                    VStack {
                                        Image("microsoft")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25, alignment: .center)
                                    }
                                    Text("Sign out")
                                }
                            }.buttonStyle(DatachestButton())
                        }
                        else {
                            Button(action: MicrosoftAuthService.shared.signInMicrosoft) {
                                HStack {
                                    VStack {
                                        Image("microsoft")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25, alignment: .center)
                                    }
                                    Text("Sign in")
                                }
                            }.buttonStyle(DatachestButton())
                        }
                    }
                }.padding().background(Color("grey")).overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                Spacer()
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom) {
                        Text("Dropbox").font(.title)
                        Spacer()
                    }.padding(.bottom, 5)
                    HStack(alignment: .bottom) {
                        if self.state.uistate.signedInDropbox {
                            VStack(alignment: .leading) {
                                Text("Signed in as")
                                Text(self.vm.dropboxName).font(.headline)
                            }.onAppear { self.vm.getProfileNameDropbox() }
                        }
                        else {
                            Text("Not signed in.")
                        }
                        Spacer()
                        if self.state.uistate.signedInDropbox {
                            Button(action: DropboxAuthService.shared.signOutDropbox) {
                                HStack {
                                    VStack {
                                        Image("dropbox")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25, alignment: .center)
                                    }
                                    Text("Sign out")
                                }
                            }.buttonStyle(DatachestButton())
                        }
                        else {
                            Button(action: DropboxAuthService.shared.signInDropbox) {
                                HStack {
                                    VStack {
                                        Image("dropbox")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25, alignment: .center)
                                    }
                                    Text("Sign in")
                                }
                            }.buttonStyle(DatachestButton())
                        }
                    }
                }.padding().background(Color("grey")).overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                Spacer()
                Spacer()
                Spacer()
            }.padding(30).navigationTitle("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
