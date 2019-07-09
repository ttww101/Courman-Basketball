//
//  AppDelegate.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/3/20.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()

        IQKeyboardManager.shared.enable = true

        // Set Navigation Bar
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        // Set status bar
        UIApplication.shared.statusBarStyle = .lightContent

        // Set UserNotification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in

            if granted {
                print("User notifications are allowed")
            } else {
                print("User notifications are not allowed")
            }
        }
//        let basketballStorybard = UIStoryboard(name: Constant.Storyboard.basketball, bundle: nil)
//        let basketballTabbarViewController = basketballStorybard.instantiateViewController(withIdentifier: Constant.Controller.basketballTabbar) as? BasketballTabbarViewController
//        self.window?.rootViewController = basketballTabbarViewController
//        self.window?.makeKeyAndVisible()

        Fabric.with([Crashlytics.self])

        return true
    }

}
