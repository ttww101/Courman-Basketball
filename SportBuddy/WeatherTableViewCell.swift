//
//  WeatherTableViewCell.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/3/29.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell, Identifiable {

    // MARK: Property

    @IBOutlet weak var weatherCellTitle: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var rainRateLabel: UILabel!
    @IBOutlet weak var feelLabel: UILabel!

    class var identifier: String { return String(describing: self) }

    static let gameDefaultHeight: CGFloat = 40.0
    static let gameCellHeight: CGFloat = 180.0
    static let courtCellHeight: CGFloat = 150.0

    override func awakeFromNib() {
        super.awakeFromNib()
        weatherCellTitle.textColor = .white
        weatherLabel.textColor = .white
        temperatureLabel.textColor = .white
        rainRateLabel.textColor = .white
        feelLabel.textColor = .white
    }
}
