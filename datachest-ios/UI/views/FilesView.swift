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
        VStack {
            VStack {
                Text("Google:")
                List {
                    ForEach(vm.googleDriveFiles) { file in
                        HStack {
                            Text(file.name)
                            Spacer()
                            Button(action: { vm.googleDriveDownloadFile(file: file) }) {
                                Image(systemName: "arrow.down.circle").foregroundColor(.blue)
                            }
                        }
                    }
                }.buttonStyle(BorderlessButtonStyle())
            }
            
            VStack {
                Text("Microsoft:")
                List {
                    ForEach(vm.microsoftOneDriveFiles) { file in
                        HStack {
                            Text(file.name)
                            Spacer()
                            Button(action: { vm.microsoftOneDriveDownloadFile(file: file) }) {
                                Image(systemName: "arrow.down.circle").foregroundColor(.blue)
                            }
                        }
                    }
                }.buttonStyle(BorderlessButtonStyle())
            }
            
            VStack {
                Text("Dropbox:")
            }
        }.onAppear {
            vm.listFilesOnCloud()
        }
    }
}

struct FilesView_Previews: PreviewProvider {
    static var previews: some View {
        FilesView()
    }
}
