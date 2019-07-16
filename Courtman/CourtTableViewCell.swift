//
//  CourtTableViewCell.swift
//  Courtman
//
//  Created by steven.chou on 2017/3/24.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit

class CourtTableViewCell: UITableViewCell {

    @IBOutlet weak var courtName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
