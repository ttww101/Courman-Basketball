//
//  CommentDetailTableViewCell.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/5/4.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit

class CommentDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var commaLabel: UILabel!

    class var identifier: String { return String(describing: self) }

    override func awakeFromNib() {
        super.awakeFromNib()

        comment.textColor = .white
        commaLabel.textColor = .white
        userImage.layer.cornerRadius = userImage.bounds.size.height / 2.0
        userImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
