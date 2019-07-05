//
//  JoinOrLeaveTableViewCell.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/4/19.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit

class JoinOrLeaveTableViewCell: UITableViewCell, Identifiable {

    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var cancelGameButton: UIButton!

    // MARK: Property

    class var identifier: String { return String(describing: self) }

    static let height: CGFloat = 100.0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
