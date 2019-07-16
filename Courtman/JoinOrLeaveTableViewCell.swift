//
//  JoinOrLeaveTableViewCell.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import UIKit
import LGButton

class JoinOrLeaveTableViewCell: UITableViewCell, Identifiable {

    @IBOutlet weak var eventButton: LGButton!

    class var identifier: String { return String(describing: self) }

    static let height: CGFloat = 75

}
