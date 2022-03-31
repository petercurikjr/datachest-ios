//
//  UploadView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 28/03/2022.
//

import SwiftUI

struct UploadView: View {
    @StateObject private var vm = UploadViewModel()
    
    var body: some View {
        VStack {
            VStack {
                Button(action: { vm.showDocumentPickerGoogle.toggle() }) {
                    Text("Google: Upload a file")
                }
            }.fileImporter(isPresented: $vm.showDocumentPickerGoogle, allowedContentTypes: [.text, .pdf]) { res in
                vm.handleSelectedFile(cloudProvider: .google, result: res)
            }
            
            VStack {
                Button(action: { vm.showDocumentPickerMicrosoft.toggle() }) {
                    Text("Microsoft: Upload a file")
                }
            }.fileImporter(isPresented: $vm.showDocumentPickerMicrosoft, allowedContentTypes: [.text, .pdf]) { res in
                vm.handleSelectedFile(cloudProvider: .microsoft, result: res)
            }
            
            VStack {
                Button(action: { vm.showDocumentPickerDropbox.toggle() }) {
                    Text("Dropbox: Upload a file")
                }
            }.fileImporter(isPresented: $vm.showDocumentPickerDropbox, allowedContentTypes: [.text, .pdf]) { res in
                vm.handleSelectedFile(cloudProvider: .dropbox, result: res)
            }
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
