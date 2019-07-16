//
//  Weather.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
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
