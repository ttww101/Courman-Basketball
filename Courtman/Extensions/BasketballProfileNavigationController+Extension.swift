import UIKit

extension BasketballProfileNavigationController {
func viewDidLoadCannotSpeak(_ para: Double, title: String) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
}
