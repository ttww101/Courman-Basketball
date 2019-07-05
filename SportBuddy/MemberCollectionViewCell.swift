//
//  MemberCollectionViewCell.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/4/19.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit

class MemberCollectionViewCell: UICollectionViewCell, Identifiable {

    // MARK: Property

    class var identifier: String { return String(describing: self) }

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        userName.textColor = .white
    }

}
