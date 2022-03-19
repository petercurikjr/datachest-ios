//
//  ContentView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 25/11/2021.
//

import SwiftUI

struct ContentView: View {
    @State var showDocumentPickerGoogle = false
    @State var showDocumentPickerDropbox = false
    @State var showDocumentPickerMicrosoft = false
    
    @StateObject var networkService = NetworkService.shared
    
    var body: some View {
        VStack {
            VStack {
                Button(action: GoogleAuthService.shared.signInGoogle) {
                    Text("Sign in with Google")
                }
                Button(action: GoogleAuthService.shared.signOutGoogle) {
                    Text("Sign out from Google")
                }
                Button(action: { showDocumentPickerGoogle.toggle() }) {
                    Text("Upload a file")
                }.padding(.bottom)
            }.fileImporter(isPresented: $showDocumentPickerGoogle, allowedContentTypes: [.text, .pdf]) { res in
                do {
                    let fileUrl = try res.get()
                    GoogleDriveFacade.shared.uploadFile(fileUrl: fileUrl)
                }
                catch {
                    // error
                }
            }
            
            VStack {
                Button(action: MicrosoftAuthService.shared.signInMicrosoft) {
                    Text("Sign in with Microsoft")
                }
                Button(action: MicrosoftAuthService.shared.signOutMicrosoft) {
                    Text("Sign out from Microsoft")
                }
                Button(action: { showDocumentPickerMicrosoft.toggle() }) {
                    Text("Upload a file")
                }.padding(.bottom)
            }.fileImporter(isPresented: $showDocumentPickerMicrosoft, allowedContentTypes: [.text, .pdf]) { res in
                do {
                    let fileUrl = try res.get()
                    MicrosoftOneDriveFacade.shared.uploadFile(fileUrl: fileUrl)
                }
                catch {
                    // error
                }
            }
            
            VStack {
                Button(action: DropboxAuthService.shared.signInDropbox) {
                    Text("Sign in with Dropbox")
                }
                Button(action: DropboxAuthService.shared.signOutDropbox) {
                    Text("Sign out from Dropbox")
                }
                Button(action: { showDocumentPickerDropbox.toggle() }) {
                    Text("Upload a file")
                }
            }.fileImporter(isPresented: $showDocumentPickerDropbox, allowedContentTypes: [.text, .pdf]) { res in
                do {
                    let fileUrl = try res.get()
                    DropboxFacade.shared.uploadFile(fileUrl: fileUrl)
                }
                catch {
                    // error
                }
            }
        }
        .alert(item: $networkService.networkError) { alert in
            Alert(title: Text("Error"), message: Text(alert.error), dismissButton: .cancel(Text("Close")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
