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
    
    @State var showDocumentPicker = false
    
    var body: some View {
        VStack {
            VStack {
                Button(action: googleAuthService.signInGoogle) {
                    Text("Sign in with Google")
                }
                Button(action: googleAuthService.signOutGoogle) {
                    Text("Sign out from Google")
                }
//                Button(action: { googleDriveService.listFiles(folderId: "root") }) {
//                    Text("List folders")
//                }
//                Button(action: { googleDriveService.listFiles(folderId: "root") }) {
//                    Text("List files")
//                }
                Button(action: { showDocumentPicker.toggle() }) {
                    Text("Upload a file")
                }.padding(.bottom)

                Button(action: microsoftAuthService.signInMicrosoft) {
                    Text("Sign in with Microsoft")
                }
                Button(action: microsoftAuthService.signOutMicrosoft) {
                    Text("Sign out from Microsoft")
                }.padding(.bottom)
                
                Button(action: dropboxAuthService.signInDropbox) {
                    Text("Sign in with Dropbox")
                }
                Button(action: dropboxAuthService.signOutDropbox) {
                    Text("Sign out from Dropbox")
                }
            }.fileImporter(isPresented: $showDocumentPicker, allowedContentTypes: [.text, .pdf]) { (res) in
                do {
                    let fileUrl = try res.get()
                    GoogleDriveFacade.shared.uploadLargeFile(fileUrl: fileUrl)
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
