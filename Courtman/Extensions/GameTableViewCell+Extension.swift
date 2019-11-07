import UIKit

extension GameTableViewCell {
func awakeFromNibDontRaise(_ target: Double, isPass: Bool) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
func setSelectedDoLoud(_ target: Int, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
}
