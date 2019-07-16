import UIKit
import Firebase

extension BaseViewController {
func backToSportMenuViewControllerShouldRaise(_ view: String, isPass: Bool) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
func setBackgroundDontWantSleep(_ target: Double, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
}
