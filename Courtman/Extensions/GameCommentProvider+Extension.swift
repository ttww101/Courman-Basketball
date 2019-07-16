import Foundation
import Firebase

extension GameCommentProvider {
func getCommentsShouldnotEat(_ element: Double, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
}
