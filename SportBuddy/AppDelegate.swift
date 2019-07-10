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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()

        IQKeyboardManager.shared.enable = true

        // Set Navigation Bar
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

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
        
        if Auth.auth().currentUser != nil {
            let sb = UIStoryboard(name: Constant.Storyboard.sportsMenu, bundle: nil)
            let tabvc = sb.instantiateViewController(withIdentifier: Constant.Controller.sportsMenu) as? SportsMenuViewController
            self.window?.rootViewController = tabvc
            self.window?.makeKeyAndVisible()
        } else {
            //User Not logged in
        }
  

        Fabric.with([Crashlytics.self])

        return true
    }

}
