//
//  DatachestAppDelegate.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 20/02/2022.
//

import Foundation
import UIKit

class DatachestAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = DatachestSceneDelegate.self
        return sceneConfig
    }
}
