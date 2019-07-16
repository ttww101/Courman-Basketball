//
//  CourtInfoTableViewCell.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/3/29.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit

class CourtInfoTableViewCell: UITableViewCell, Identifiable {

    // MARK: Property

    class var identifier: String { return String(describing: self) }

    static let height: CGFloat = 220.0

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var courtName: UILabel!
    @IBOutlet weak var courtAddress: UILabel!
    @IBOutlet weak var courtTel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var courtLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        cellView.backgroundColor = .clear
    }
}
