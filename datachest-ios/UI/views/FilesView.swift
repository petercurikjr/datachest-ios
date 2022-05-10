//
//  FilesView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 28/03/2022.
//

import SwiftUI

struct FilesView: View {
    @EnvironmentObject private var state: ApplicationStore
    @StateObject private var vm = FilesViewModel()
    
    var body: some View {
        if [self.state.uistate.signedInGoogle, self.state.uistate.signedInMicrosoft, self.state.uistate.signedInDropbox].filter({$0}).count < 2 {
            LoginView(description: "To download files, you have to be signed to at least two accounts.")
        }
        else {
            NavigationView {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Only files uploaded and encrypted by Datachest are listed below.").padding(.horizontal, 20)
                    }.padding(.bottom)
                    List {
                        VStack {
                            HStack {
                                VStack {
                                    Image("google-drive")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .padding(.horizontal)
                                }.frame(width: 68, height: 50, alignment: .center)
                                Text("Google Drive")
                                Spacer()
                                if self.state.uistate.signedInGoogle {
                                    Text("\(self.vm.googleDriveFiles.count) files")
                                }
                            }.padding()
                            if self.state.uistate.signedInGoogle {
                                VStack {
                                    Section {
                                        ForEach(vm.googleDriveFiles) { file in
                                            HStack {
                                                Text(file.name)
                                                Spacer()
                                                Button(action: { vm.googleDriveDownloadFile(file: file) }) {
                                                    Image(systemName: "arrow.down.circle").foregroundColor(.blue)
                                                }
                                            }.padding()
                                        }
                                    }.buttonStyle(BorderlessButtonStyle())
                                }.onAppear {
                                    self.vm.listFilesOnGoogleDrive()
                                }
                            }
                            else {
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
                        }
                        
                        VStack {
                            HStack {
                                VStack {
                                    Image("microsoft-onedrive")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40, alignment: .trailing)
                                        .padding(.horizontal).padding(.bottom, 7)
                                }.frame(width: 68, height: 50, alignment: .center)
                                Text("Microsoft OneDrive")
                                Spacer()
                                if self.state.uistate.signedInMicrosoft {
                                    Text("\(self.vm.microsoftOneDriveFiles.count) files")
                                }
                            }.padding()
                            if self.state.uistate.signedInMicrosoft {
                                VStack {
                                    Section {
                                        ForEach(vm.microsoftOneDriveFiles) { file in
                                            HStack {
                                                Text(file.name)
                                                Spacer()
                                                Button(action: { vm.microsoftOneDriveDownloadFile(file: file) }) {
                                                    Image(systemName: "arrow.down.circle").foregroundColor(.blue)
                                                }
                                            }.padding()
                                        }
                                    }.buttonStyle(BorderlessButtonStyle())
                                }.onAppear {
                                    self.vm.listFilesOnMicrosoftOneDrive()
                                }
                            }
                            else {
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
                        }
                        
                        VStack {
                            HStack {
                                VStack {
                                    Image("dropbox")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 35, height: 35, alignment: .trailing)
                                        .padding(.horizontal)
                                }
                                Text("Dropbox")
                                Spacer()
                                if self.state.uistate.signedInDropbox {
                                    Text("\(self.vm.dropboxFiles.count) files")
                                }
                            }.padding()
                            if self.state.uistate.signedInDropbox {
                                VStack {
                                    Section {
                                        ForEach(vm.dropboxFiles) { file in
                                            HStack {
                                                Text(file.name)
                                                Spacer()
                                                Button(action: { vm.dropboxDownloadFile(file: file) }) {
                                                    Image(systemName: "arrow.down.circle").foregroundColor(.blue)
                                                }
                                            }.padding()
                                        }
                                    }.buttonStyle(BorderlessButtonStyle())
                                }.onAppear {
                                    self.vm.listFilesOnDropbox()
                                }
                            }
                            else {
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
                        }
                    }
                }.navigationTitle("Your files on cloud")
                .toolbar {
                    HStack {
                        Button(action: { self.vm.refresh() }) {
                            Image(systemName: "arrow.counterclockwise")
                        }
                        if self.state.uistate.ongoingDownloads.contains(where: {$0.finished == false}) {
                            HStack {
                                Spacer()
                                Text("Download is in progress")
                                VStack {
                                    NavigationLink(destination: DownloadListView()) {
                                        VStack {
                                            Image(systemName: "arrow.right")
                                        }
                                    }.navigationViewStyle(StackNavigationViewStyle())
                                }
                            }
                        }
                    }
                }
            }.listStyle(PlainListStyle()).navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct FilesView_Previews: PreviewProvider {
    static var previews: some View {
        FilesView()
    }
}
