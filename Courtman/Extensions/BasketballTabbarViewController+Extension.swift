import UIKit

extension BasketballTabbarViewController {
func viewDidLoadCannotListen(_ message: Bool, isOk: Bool) {
    UserDefaults.standard.setValue(message, forKey: "message")
}
}
