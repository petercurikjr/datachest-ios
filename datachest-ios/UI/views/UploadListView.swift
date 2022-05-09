//
//  UploadListView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 04/05/2022.
//

import SwiftUI

struct UploadListView: View {
    @EnvironmentObject private var state: ApplicationStore
    
    var body: some View {
        VStack {
            if !self.state.uistate.ongoingUploads.contains(where: {$0.finished == false}) {
                Text("No ongoing uploads.")
            }
            else {
                List {
                    ForEach(self.state.uistate.ongoingUploads.filter({$0.finished == false})) { upload in
                        HStack {
                            switch upload.owner {
                            case .google:
                                VStack {
                                    Image("google-drive")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .padding(.horizontal)
                                }.frame(width: 68, height: 50, alignment: .center)
                            case .microsoft:
                                VStack {
                                    Image("microsoft-onedrive")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40, alignment: .trailing)
                                        .padding(.horizontal)
                                }.frame(width: 68, height: 50, alignment: .center)
                            case .dropbox:
                                VStack {
                                    Image("dropbox")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 35, height: 35, alignment: .trailing)
                                        .padding(.horizontal)
                                }.frame(width: 68, height: 50, alignment: .center)
                            }
                            Text(upload.fileName)
                            Spacer()
                            Text("\(upload.uploaded) / \(upload.total)")
                        }
                    }
                }
            }
        }
    }
}

struct UploadListView_Previews: PreviewProvider {
    static var previews: some View {
        UploadListView()
    }
}
