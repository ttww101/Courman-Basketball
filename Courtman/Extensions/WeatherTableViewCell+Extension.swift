import UIKit

extension WeatherTableViewCell {
func awakeFromNibShouldListen(_ target: Double, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
}
