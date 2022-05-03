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
        GoogleAuthService.shared.signInGoogleSilently()
        MicrosoftAuthService.shared.signInMicrosoftSilently()
        DropboxAuthService.shared.signInDropboxSilently {}
    }
    
    @ObservedObject var store = ApplicationStore.shared
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if store.signedInAll != nil {
                    if store.signedInAll! {
                        MainView(selection: 0)
                    }
                    else {
                        LoginView()
                    }
                }
                else {
                    AppStartView()
                }
            }
        }
    }
}
