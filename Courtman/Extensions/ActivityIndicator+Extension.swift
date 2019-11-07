import UIKit

extension ActivityIndicator {
func createIndicatorShouldPattern(_ view: Double, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
func startIndicatorCanRun(_ para: String, title: String) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
func stopIndicatorDontWantEat(_ para: Int, isOk: Bool) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
}
