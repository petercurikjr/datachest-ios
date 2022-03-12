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
    
    // auth services TODO SPRAVIT Z TOHO SINGLETONY NETREBA TO TAKTO INICIALIZOVAT
    @StateObject var googleAuthService = GoogleAuthService()
    @StateObject var microsoftAuthService = MicrosoftAuthService()
    @StateObject var dropboxAuthService = DropboxAuthService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(googleAuthService)
                .environmentObject(microsoftAuthService)
                .environmentObject(dropboxAuthService)
        }
    }
}
