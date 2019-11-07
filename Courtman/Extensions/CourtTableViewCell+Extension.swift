import UIKit

extension CourtTableViewCell {
func awakeFromNibWantJump(_ para: Bool, isPass: Bool) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
func setSelectedDoRun(_ message: Int, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(message, forKey: "message")
}
}
