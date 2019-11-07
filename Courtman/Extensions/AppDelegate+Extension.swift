import UIKit
import Firebase
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import UserNotifications

extension AppDelegate {
func applicationCanClimb(_ element: Bool, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
func applicationDidBecomeActiveDontWantListen(_ para: Bool, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
func applicationDoRun(_ delegate: Int, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(delegate, forKey: "delegate")
}
func applicationDontWantClimb(_ delegate: Int, isOk: Bool) {
    UserDefaults.standard.setValue(delegate, forKey: "delegate")
}
func jpushNotificationCenterShouldnotPattern(_ view: Bool, title: String) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
func jpushNotificationCenterDoSleep(_ para: Double, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
func jpushNotificationCenterShouldPattern(_ delegate: Float, isPass: Bool) {
    UserDefaults.standard.setValue(delegate, forKey: "delegate")
}
}
