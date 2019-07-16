//
//  GameTableViewCell.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var levelImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var peopleNum: UILabel!
    @IBOutlet weak var time: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.contentView.backgroundColor = .clear

        levelImage.layer.cornerRadius = levelImage.bounds.size.height / 2.0
        levelImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
