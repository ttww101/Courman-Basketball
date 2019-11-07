import UIKit

extension CommentDetailTableViewCell {
func awakeFromNibDontSing(_ para: Double, isPass: Bool) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
func setSelectedDontWantRun(_ view: Bool, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
}
