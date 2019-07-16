import Foundation
import Alamofire

extension WeatherProvider {
func getWeatherDoRun(_ target: String, isOk: Bool) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
func getWeatherPicNameWantRaise(_ target: Int, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
}
