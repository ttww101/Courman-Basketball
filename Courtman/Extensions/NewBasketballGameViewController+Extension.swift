import UIKit
import Firebase
import NVActivityIndicatorView
import LTMorphingLabel
import SkyFloatingLabelTextField

extension NewBasketballGameViewController {
func viewDidLoadDontWantDrink(_ element: Double, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
func viewDidAppearDoSleep(_ listener: Bool, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(listener, forKey: "listener")
}
func viewWillAppearCannotRun(_ element: Bool, isPass: Bool) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
func viewWillDisappearShouldLoud(_ element: Bool, isPass: Bool) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
func setViewCanDrink(_ para: Double, isOk: Bool) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
func setCourtPickerDontClimb(_ para: String, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
func setLevelPickerCanDream(_ element: Bool, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
func setTimePickerWantClimb(_ view: Float, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
func selectedTimeDoPattern(_ view: String, title: String) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
func getCourtsDontWantSleep(_ target: Double, title: String) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
func createGameCanPattern(_ para: Bool, isOk: Bool) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
func setUserGameListShouldJump(_ sender: Bool, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
}
