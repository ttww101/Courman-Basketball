import Foundation

extension DataLoader {
func getDataShouldRaise(_ sender: Float, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
func urlSessionShouldnotSpeak(_ target: String, isOk: Bool) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
}
