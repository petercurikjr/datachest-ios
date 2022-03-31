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
                            Button(action: { vm.downloadFile(fileId: file.id, fileName: file.name) }) {
                                Image(systemName: "arrow.down.circle").foregroundColor(.blue)
                            }
                        }
                    }
                }.buttonStyle(BorderlessButtonStyle())
            }.onAppear {
                vm.listFilesOnCloud()
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
