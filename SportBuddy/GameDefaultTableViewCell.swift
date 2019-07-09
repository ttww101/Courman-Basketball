//
//  GameDefaultTableViewCell.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/4/30.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit

class GameDefaultTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var defaultStringLabel: UILabel!

    static let height: CGFloat = 300.0

    override func awakeFromNib() {
        super.awakeFromNib()

        cellView.backgroundColor = .clear
        defaultStringLabel.textColor = .white
        defaultStringLabel.text = "您所在地區尚未有球團開啟\n來創建第一個球團!"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
