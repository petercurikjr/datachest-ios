//
//  datachest_iosApp.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 25/11/2021.
//

import SwiftUI

@main
struct datachest_iosApp: App {
    // attach the UIKit's AppDelegate to the SwiftUI main application
    @UIApplicationDelegateAdaptor(DatachestAppDelegate.self) var datachestAppDelegate
    
    @StateObject var googleAuthService = GoogleAuthService()
    @StateObject var microsoftAuthService = MicrosoftAuthService()
    @StateObject var dropboxAuthService = DropboxAuthService()
    
    var test = Cipher()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(googleAuthService)
                .environmentObject(microsoftAuthService)
                .environmentObject(dropboxAuthService)
        }
    }
}
