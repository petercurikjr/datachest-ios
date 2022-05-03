//
//  ProfileView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 25/11/2021.
//

import SwiftUI

struct ProfileView: View {
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
                        VStack(alignment: .leading) {
                            Text("Signed in as")
                            Text(self.vm.googleName).font(.headline)
                        }
                        Spacer()
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
                }.padding().background(Color("grey")).overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                Spacer()
                VStack {
                    HStack(alignment: .bottom) {
                        Text("Microsoft").font(.title)
                        Spacer()
                    }.padding(.bottom, 5)
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            Text("Signed in as")
                            Text(self.vm.microsoftName).font(.headline)
                        }
                        Spacer()
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
                }.padding().background(Color("grey")).overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                Spacer()
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom) {
                        Text("Dropbox").font(.title)
                        Spacer()
                    }.padding(.bottom, 5)
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            Text("Signed in as")
                            Text(self.vm.dropboxName).font(.headline)
                        }
                        Spacer()
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
                }.padding().background(Color("grey")).overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                Spacer()
                Spacer()
                Spacer()
            }.padding(30).navigationTitle("Profile")
        }.onAppear {
            self.vm.getProfileNames()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
