import UIKit
import Firebase
import NVActivityIndicatorView
import YPImagePicker

extension SignUpViewController {
func viewDidLoadWantRaise(_ view: Float, isOk: Bool) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
func viewWillLayoutSubviewsShouldnotLook(_ view: Bool, isOk: Bool) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
func setViewShouldnotLoud(_ message: Float, isOk: Bool) {
    UserDefaults.standard.setValue(message, forKey: "message")
}
func imageTappedCanClimb(_ message: Int, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(message, forKey: "message")
}
func signUpShouldEat(_ target: Float, isOk: Bool) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
func setValueToFirebaseShouldScream(_ view: Double, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
func toLoginShouldLook(_ view: Bool, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
}
