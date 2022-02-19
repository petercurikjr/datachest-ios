//
//  datachest_iosApp.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 25/11/2021.
//

import SwiftUI
import Firebase

@main
struct datachest_iosApp: App {
    @StateObject var googleAuthService = GoogleAuthService()
    @StateObject var microsoftAuthService = MicrosoftAuthService()
    @StateObject var dropboxAuthService = DropboxAuthService()
    
    var test = Cipher()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(googleAuthService)
                .environmentObject(microsoftAuthService)
                .environmentObject(dropboxAuthService)
        }
    }
}
