//
//  AppDelegate.swift
//  UsingFMDB-Swift
//
//  Created by akabeko on 2016/12/17.
//  Copyright © 2016年 akabeko. All rights reserved.
//

import UIKit

/// Manager for the application.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    /// Main window.
    var window: UIWindow?

    /// Manager fot the application data.
    private(set) var appDAO = AppDAO()

    /// Tells the delegate that the launch process is almost done and the app is almost ready to run.
    ///
    /// - Parameters:
    ///   - application: Your singleton app object.
    ///   - launchOptions: A dictionary indicating the reason the app was launched (if any). The contents of this dictionary may be empty in situations where the user launched the app directly. For information about the possible keys in this dictionary and how to handle them, see Launch Options Keys.
    /// - Returns: false if the app cannot handle the URL resource or continue a user activity, otherwise return true. The return value is ignored if the app is launched as a result of a remote notification.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

