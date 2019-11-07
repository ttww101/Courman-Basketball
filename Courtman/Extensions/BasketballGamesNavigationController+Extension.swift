import UIKit

extension BasketballGamesNavigationController {
func viewDidLoadDoDrink(_ delegate: String, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(delegate, forKey: "delegate")
}
}
