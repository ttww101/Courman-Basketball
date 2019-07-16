//
//  MapTableViewCell.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell, Identifiable {

    // MARK: Property
    @IBOutlet weak var mapCellTitle: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    class var identifier: String { return String(describing: self) }

    static let aspectRatio: CGFloat = 3.0 / 2.0
//
    static let gameDefaultHeight: CGFloat = 40.0
    static let gameCellHeight: CGFloat = 180.0
    static let courtCellHeight: CGFloat = 150.0

    override func awakeFromNib() {
        super.awakeFromNib()

        mapCellTitle.textColor = .white

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
