import UIKit

extension BasketballCourtsNavigationController {
func viewDidLoadShouldnotDrink(_ sender: Double, title: String) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
}
