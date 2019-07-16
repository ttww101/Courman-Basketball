import Foundation
import Firebase

extension MemebersProvider {
func getMembersDontWantSleep(_ listener: String, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(listener, forKey: "listener")
}
}
