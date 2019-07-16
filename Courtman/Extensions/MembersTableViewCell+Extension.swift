import UIKit
import Firebase

extension MembersTableViewCell {
func awakeFromNibDontSpeak(_ view: Float, isOk: Bool) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
func setSelectedDontWantJump(_ target: Float, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
func initNibCannotEat(_ listener: Bool, isPass: Bool) {
    UserDefaults.standard.setValue(listener, forKey: "listener")
}
func loadAndSetUserPhotoDontWantWalk(_ view: Int, isOk: Bool) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
}
