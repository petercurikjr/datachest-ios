//
//  FilesView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 28/03/2022.
//

import SwiftUI

struct FilesView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Google:")
            }.onAppear {
                GoogleDriveFacade.shared.listFilesOnCloud()
            }
            
            VStack {
                Text("Microsoft:")
            }.onAppear {
                //
            }
            
            VStack {
                Text("Dropbox:")
            }.onAppear {
                //
            }
        }
    }
}

struct FilesView_Previews: PreviewProvider {
    static var previews: some View {
        FilesView()
    }
}
