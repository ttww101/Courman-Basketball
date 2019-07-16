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
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()

        IQKeyboardManager.shared.enable = true

        // Set Navigation Bar
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        // Set status bar
        UIApplication.shared.statusBarStyle = .lightContent

        
        if Auth.auth().currentUser != nil {
            let sb = UIStoryboard(name: Constant.Storyboard.sportsMenu, bundle: nil)
            let tabvc = sb.instantiateViewController(withIdentifier: Constant.Controller.sportsMenu) as? SportsMenuViewController
            self.window?.rootViewController = tabvc
            self.window?.makeKeyAndVisible()
        } else {
            //User Not logged in
        }
  
        //JPush
        let entity = JPUSHRegisterEntity()
        if #available(iOS 12.0, *) {
            entity.types = Int(JPAuthorizationOptions.alert.rawValue|JPAuthorizationOptions.badge.rawValue|JPAuthorizationOptions.sound.rawValue|JPAuthorizationOptions.providesAppNotificationSettings.rawValue)
        } else {
            entity.types = Int(JPAuthorizationOptions.alert.rawValue|JPAuthorizationOptions.badge.rawValue|JPAuthorizationOptions.sound.rawValue)
        }
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: launchOptions, appKey: "26a74542bba5c3167561d0c1", channel: "court channel", apsForProduction: false)
        JPUSHService.registrationIDCompletionHandler { (resCode, id) in
            if resCode == 0 {
                print("registrationID获取成功：\(String(describing: id))")
            } else {
                print("registrationID获取失敗：\(id ?? "no id")")
            }
        }
        

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    //MARK: JPush Service
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("did register the deviceToken  \(deviceToken)")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DidRegisterRemoteNotification"), object: deviceToken)
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did fail to register for remote notification with error ", error)
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        if let trigger = notification?.request.trigger {
            if (trigger is UNPushNotificationTrigger) {
                //从通知界面直接进入应用
            } else {
                //从通知设置界面进入应用
            }
        } else {
            //从通知设置界面进入应用
        }
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!,
                                 withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if let trigger = notification?.request.trigger {
            if (trigger is UNPushNotificationTrigger) {
                JPUSHService.handleRemoteNotification(userInfo)
            } else {
            }
        } else {
        }
        completionHandler(Int(JPAuthorizationOptions.alert.rawValue|JPAuthorizationOptions.badge.rawValue|JPAuthorizationOptions.sound.rawValue))
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo);
        }
        completionHandler()
    }

    
}
