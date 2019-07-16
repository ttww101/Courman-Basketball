import UIKit

extension MemberCollectionViewCell {
func awakeFromNibShouldDance(_ delegate: Float, title: String) {
    UserDefaults.standard.setValue(delegate, forKey: "delegate")
}
}
