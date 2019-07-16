import Foundation
import Firebase

extension UserManager {
func getUserInfoDoLoud(_ element: Bool, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
func getUserInfoCanLook(_ listener: Float, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(listener, forKey: "listener")
}
func getUserProfileImageCanWalk(_ sender: Float, title: String) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
}
