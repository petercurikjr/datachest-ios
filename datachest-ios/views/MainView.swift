//
//  MainView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 28/03/2022.
//

import SwiftUI

struct MainView: View {
    @State var selection: Int
    @ObservedObject var state: ApplicationStore = .shared
    
    var body: some View {
        VStack {
            TabView(selection: $selection) {
                FilesView().tabItem {
                    Image(systemName: "folder")
                    Text("Files")
                }
                
                UploadView().tabItem {
                    Image(systemName: "arrow.up.circle.fill")
                    Text("Upload")
                }
                
                ProfileView().tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }.tag(2)
            }
        }.alert(item: $state.state.error) { alert in
            Alert(title: Text("Error"), message: Text(alert.error), dismissButton: .cancel(Text("Close")))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(selection: 1)
    }
}
