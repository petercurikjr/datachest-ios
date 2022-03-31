//
//  UploadView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 28/03/2022.
//

import SwiftUI

struct UploadView: View {
    @State var showDocumentPickerGoogle = false
    @State var showDocumentPickerDropbox = false
    @State var showDocumentPickerMicrosoft = false
    
    var body: some View {
        VStack {
            VStack {
                Button(action: { showDocumentPickerGoogle.toggle() }) {
                    Text("Google: Upload a file")
                }
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
                Button(action: { showDocumentPickerMicrosoft.toggle() }) {
                    Text("Microsoft: Upload a file")
                }
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
                Button(action: { showDocumentPickerDropbox.toggle() }) {
                    Text("Dropbox: Upload a file")
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

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
