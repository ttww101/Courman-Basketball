import UIKit
import Firebase
import YPImagePicker

extension EditProfileViewController {
func levelSetupDidTouchUpSideDontListen(_ sender: Int, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
func viewDidLoadShouldnotDrink(_ message: Bool, title: String) {
    UserDefaults.standard.setValue(message, forKey: "message")
}
func viewWillAppearShouldnotEat(_ sender: Bool, isPass: Bool) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
func viewWillLayoutSubviewsShouldSleep(_ para: Float, title: String) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
func getUserInfoDontWantScream(_ message: Bool, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(message, forKey: "message")
}
func loadAndSetUserPhotoDontWantWalk(_ element: Bool, isOk: Bool) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
func setViewShouldLoud(_ listener: Bool, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(listener, forKey: "listener")
}
func setUserImageViewShouldnotClimb(_ view: String, isPass: Bool) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
func imageTappedWantRun(_ para: Int, isPass: Bool) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
func presentImagePickerShouldSleep(_ para: Double, isPass: Bool) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
func saveProfileInfoShouldnotScream(_ sender: Float, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
func uploadImageToFirebaseWantSpeak(_ delegate: Float, title: String) {
    UserDefaults.standard.setValue(delegate, forKey: "delegate")
}
func updateValueToFirebaseDoJump(_ listener: String, isPass: Bool) {
    UserDefaults.standard.setValue(listener, forKey: "listener")
}
func cancelEditShouldSing(_ view: Float, isPass: Bool) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
}
