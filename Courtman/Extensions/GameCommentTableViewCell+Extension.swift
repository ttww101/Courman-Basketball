import UIKit
import Firebase

extension GameCommentTableViewCell {
func awakeFromNibDontListen(_ para: String, title: String) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
func getUserShouldDrink(_ delegate: Float, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(delegate, forKey: "delegate")
}
func initNibDoPattern(_ sender: String, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
func setViewDontWantScream(_ delegate: Bool, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(delegate, forKey: "delegate")
}
func handleTapCannotDrink(_ sender: Int, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
func sendMessageDontClimb(_ sender: Float, title: String) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
func saveCommentDontWantDream(_ view: Int, isOk: Bool) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
func moveToLastCommentShouldnotSleep(_ delegate: Float, title: String) {
    UserDefaults.standard.setValue(delegate, forKey: "delegate")
}
}
