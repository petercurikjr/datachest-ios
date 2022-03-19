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
    
    @State var showDocumentPickerGoogle = false
    @State var showDocumentPickerDropbox = false
    @State var showDocumentPickerMicrosoft = false
    
    var body: some View {
        VStack {
            VStack {
                Button(action: googleAuthService.signInGoogle) {
                    Text("Sign in with Google")
                }
                Button(action: googleAuthService.signOutGoogle) {
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
                Button(action: microsoftAuthService.signInMicrosoft) {
                    Text("Sign in with Microsoft")
                }
                Button(action: microsoftAuthService.signOutMicrosoft) {
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
                Button(action: dropboxAuthService.signInDropbox) {
                    Text("Sign in with Dropbox")
                }
                Button(action: dropboxAuthService.signOutDropbox) {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
