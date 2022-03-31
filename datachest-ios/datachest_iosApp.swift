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
    // attach the UIKit's AppDelegate to the SwiftUI main application
    @UIApplicationDelegateAdaptor(DatachestAppDelegate.self) var datachestAppDelegate
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(selection: 1)
        }
    }
}
