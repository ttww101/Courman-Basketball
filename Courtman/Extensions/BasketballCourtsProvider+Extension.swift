import Foundation
import Alamofire

extension BasketballCourtsProvider {
func URLSessionDoSpeak(_ target: Double, isPass: Bool) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
func getCertificatesShouldSing(_ sender: Bool, isOk: Bool) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
func getApiDataShouldnotRaise(_ element: Float, isOk: Bool) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
}
