import UIKit

extension CourtInfoTableViewCell {
func awakeFromNibCanDrink(_ target: String, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
}
