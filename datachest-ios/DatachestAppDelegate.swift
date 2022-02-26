//
//  DatachestAppDelegate.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 20/02/2022.
//
///  This class is needed to perform UIKit related tasks.
///  In this scenario, the class attaches the SceneDelegate to the ApplicationDelegate.
///  The SceneDelegate is needed to handle redirection from Dropbox Authentication back to the app,
///      since SwiftyDropbox is a UIKit implemented library and no SwiftUI equivalents of this library
///      were implemented to this date.

import UIKit

class DatachestAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = DatachestSceneDelegate.self
        return sceneConfig
    }
}
