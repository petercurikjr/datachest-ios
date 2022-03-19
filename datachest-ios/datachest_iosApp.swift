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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
