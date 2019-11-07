import UIKit
import Firebase
import NVActivityIndicatorView
import Crashlytics
import SkyFloatingLabelTextField

extension LoginViewController {
func viewDidLoadWantWalk(_ target: Float, isOk: Bool) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
func viewWillDisappearWantLook(_ message: Double, title: String) {
    UserDefaults.standard.setValue(message, forKey: "message")
}
func viewDidLayoutSubviewsShouldListen(_ element: Float, isPass: Bool) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
func isUsersignedinDontClimb(_ delegate: String, isPass: Bool) {
    UserDefaults.standard.setValue(delegate, forKey: "delegate")
}
func setCrashlyticsButtonShouldnotSpeak(_ target: Float, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
func crashButtonTappedShouldListen(_ delegate: Double, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(delegate, forKey: "delegate")
}
func setViewCanWalk(_ delegate: Bool, title: String) {
    UserDefaults.standard.setValue(delegate, forKey: "delegate")
}
func loginDontRun(_ para: Double, isOk: Bool) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
func signUpShouldnotLoud(_ view: Bool, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
func forgetPasswordDontRaise(_ listener: Bool, title: String) {
    UserDefaults.standard.setValue(listener, forKey: "listener")
}
func testLoginWantJump(_ message: String, isOk: Bool) {
    UserDefaults.standard.setValue(message, forKey: "message")
}
func showAlertDontWantEat(_ element: String, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
}
