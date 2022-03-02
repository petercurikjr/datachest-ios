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
    
    @EnvironmentObject var googleDriveService: GoogleDriveService
    
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
                Button(action: { showDocumentPicker.toggle() }) {
                    Text("Upload to Google")
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
            }.fileImporter(isPresented: $showDocumentPicker, allowedContentTypes: [.text]) { (res) in
                do {
                    let fileUrl = try res.get()
                    self.googleDriveService.uploadFile(url: fileUrl)
                }
                catch {
                    // error
                }
            }
        }.onAppear {
            self.googleAuthService.setGoogleDriveService(service: self.googleDriveService)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
