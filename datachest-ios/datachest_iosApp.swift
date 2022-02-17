//
//  datachest_iosApp.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 25/11/2021.
//

import SwiftUI

@main
struct datachest_iosApp: App {
    var secret = Cipher()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
