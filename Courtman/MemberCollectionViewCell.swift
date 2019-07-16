//
//  MemberCollectionViewCell.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
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
