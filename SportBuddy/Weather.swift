//
//  Weather.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/3/31.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import Foundation

struct Weather {

    var desc: String            // 天氣敘述
    var weatherPicName: String // 天氣所用的照片
    var temperature: Int        // 溫度
    var time: String            // 更新時間

    init(desc: String, weatherPicName: String, temperature: Int, time: String) {
        self.desc = desc
        self.weatherPicName = weatherPicName
        self.temperature = temperature
        self.time = time
    }
}
