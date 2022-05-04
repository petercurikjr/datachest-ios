//
//  FilesView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 28/03/2022.
//

import SwiftUI

struct FilesView: View {
    @StateObject private var vm = FilesViewModel()
    
    var body: some View {
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
                            Text("\(self.vm.googleDriveFiles.count) files")
                        }.padding()
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
                            Text("\(self.vm.microsoftOneDriveFiles.count) files")
                        }.padding()
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
                            Text("\(self.vm.dropboxFiles.count) files")
                        }.padding()
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
                    }
                }
            }.navigationTitle("Your files on cloud")
            .onAppear {
                vm.listFilesOnCloud()
            }
        }.listStyle(PlainListStyle())
    }
}

struct FilesView_Previews: PreviewProvider {
    static var previews: some View {
        FilesView()
    }
}
