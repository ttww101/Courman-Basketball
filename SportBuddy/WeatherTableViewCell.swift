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
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!

    class var identifier: String { return String(describing: self) }

    static let gameDefaultHeight: CGFloat = 40.0
    static let gameCellHeight: CGFloat = 180.0
    static let courtCellHeight: CGFloat = 150.0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        weatherCellTitle.textColor = .white
        weatherLabel.textColor = .white
        temperatureLabel.textColor = .white
        updateTimeLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        weatherCellTitle.text = "▼ 天氣資訊"
    }

}
