import Foundation
import Firebase

extension LevelManager {
func getUserLevelDontWantListen(_ delegate: Int, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(delegate, forKey: "delegate")
}
func updateUserLevelDoClimb(_ sender: Int, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
func checkLevelStatusCanClimb(_ delegate: Double, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(delegate, forKey: "delegate")
}
func upgradeBasketballLevelDontSing(_ listener: Float, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(listener, forKey: "listener")
}
}
