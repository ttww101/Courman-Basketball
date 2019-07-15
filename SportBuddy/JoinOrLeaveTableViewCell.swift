//
//  JoinOrLeaveTableViewCell.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/4/19.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit
import LGButton

class JoinOrLeaveTableViewCell: UITableViewCell, Identifiable {

    @IBOutlet weak var eventButton: LGButton!

    class var identifier: String { return String(describing: self) }

    static let height: CGFloat = 75

}
