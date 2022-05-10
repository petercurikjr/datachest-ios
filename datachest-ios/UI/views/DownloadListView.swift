//
//  DownloadListView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 10/05/2022.
//

import SwiftUI

struct DownloadListView: View {
    @EnvironmentObject private var state: ApplicationStore
    
    var body: some View {
        VStack {
            if !self.state.uistate.ongoingDownloads.contains(where: {$0.finished == false}) {
                Text("No ongoing downloads.")
            }
            else {
                List {
                    ForEach(self.state.uistate.ongoingDownloads.filter({$0.finished == false})) { download in
                        HStack {
                            switch download.owner {
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
                            Text(download.fileName)
                            Spacer()
                            Text("\(download.percentageDone)%")
                        }
                    }
                }
            }
        }
    }
}

struct DownloadListView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadListView()
    }
}
