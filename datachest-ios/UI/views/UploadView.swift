//
//  UploadView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 28/03/2022.
//

import SwiftUI

struct UploadView: View {
    @EnvironmentObject private var state: ApplicationStore
    @StateObject private var vm = UploadViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Spacer()
                HStack(alignment: .top) {
                    VStack {
                        Image("google-drive")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50, alignment: .center)
                            .padding(.horizontal)
                    }.frame(width: 68, height: 50, alignment: .center)
                    VStack {
                        Button(action: { vm.showDocumentPickerGoogle.toggle() }) {
                            Text("Upload")
                        }
                        .buttonStyle(DatachestButton())
                        .fileImporter(isPresented: $vm.showDocumentPickerGoogle, allowedContentTypes: [.text, .pdf]) { res in
                            vm.handleSelectedFile(cloudProvider: .google, result: res)
                        }
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color("grey"))
                                .frame(width: 170, height: 4)
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.blue)
                                .frame(width: CGFloat(self.vm.googleDriveStorageProgressBarValue), height: 4)
                        }.opacity(self.vm.isUnlimitedStorageGoogle ? 0 : 100)
                        Text(self.vm.remainingSizeGoogle + " available")
                    }.padding(.top, 7)
                }.padding(.trailing, 30)
                Spacer()
                HStack(alignment: .top) {
                    VStack {
                        Image("microsoft-onedrive")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40, alignment: .trailing)
                            .padding(.horizontal).padding(.bottom, 7)
                    }.frame(width: 68, height: 50, alignment: .center)
                    VStack {
                        Button(action: { vm.showDocumentPickerMicrosoft.toggle() }) {
                            Text("Upload")
                        }
                        .buttonStyle(DatachestButton())
                        .fileImporter(isPresented: $vm.showDocumentPickerMicrosoft, allowedContentTypes: [.text, .pdf]) { res in
                            vm.handleSelectedFile(cloudProvider: .microsoft, result: res)
                        }
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color("grey"))
                                .frame(width: 170, height: 4)
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.blue)
                                .frame(width: CGFloat(self.vm.microsoftOneDriveStorageProgressBarValue), height: 4)
                        }
                        Text(self.vm.remainingSizeMicrosoft + " available")
                    }.padding(.top, 7)
                }.padding(.trailing, 30)
                Spacer()
                HStack(alignment: .top) {
                    VStack {
                        Image("dropbox")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35, alignment: .trailing)
                            .padding(.horizontal)
                    }.frame(width: 68, height: 50, alignment: .center)
                    VStack {
                        Button(action: { vm.showDocumentPickerDropbox.toggle() }) {
                            Text("Upload")
                        }
                        .buttonStyle(DatachestButton())
                        .fileImporter(isPresented: $vm.showDocumentPickerDropbox, allowedContentTypes: [.text, .pdf]) { res in
                            vm.handleSelectedFile(cloudProvider: .dropbox, result: res)
                        }
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color("grey"))
                                .frame(width: 170, height: 4)
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.blue)
                                .frame(width: CGFloat(self.vm.dropboxStorageProgressBarValue), height: 4)
                        }

                        Text(self.vm.remainingSizeDropbox + " available")
                    }.padding(.top, 7)
                }.padding(.trailing, 30)
                Spacer()
                Spacer()
                Spacer()
            }.navigationTitle("Upload your files")
            .toolbar {
                if self.state.uistate.ongoingUploads.contains(where: {$0.finished == false}) {
                    HStack {
                        Spacer()
                        Text("Upload is in progress")
                        VStack {
                            NavigationLink(destination: UploadListView()) {
                                VStack {
                                    Image(systemName: "arrow.right")
                                }
                            }.navigationViewStyle(StackNavigationViewStyle())
                        }
                    }
                }
            }
            .onAppear {
                self.vm.getCloudQuotas()
            }
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
