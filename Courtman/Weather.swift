//
//  Weather.swift
//  Courtman
//
//  Created by steven.chou on 2017/3/31.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import Foundation

struct Weather {

    var description: String
    var temperature: String
    var rainRate: String
    var feel: String

    init(description: String, temperature: String, rainRate: String, feel: String) {
        self.description = description
        self.temperature = temperature
        self.rainRate = rainRate
        self.feel = feel
    }
}
