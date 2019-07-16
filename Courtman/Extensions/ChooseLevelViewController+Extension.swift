import UIKit
import Firebase
import FSPagerView
import LTMorphingLabel

extension ChooseLevelViewController {
func viewDidLoadDontClimb(_ listener: String, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(listener, forKey: "listener")
}
func numberOfItemsDontSing(_ message: Int, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(message, forKey: "message")
}
func pagerViewDontPattern(_ sender: Bool, isOk: Bool) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
func setViewDoSleep(_ message: Double, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(message, forKey: "message")
}
}
