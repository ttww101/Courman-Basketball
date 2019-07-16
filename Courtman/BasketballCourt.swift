//
//  BasketballCourt.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import Foundation

struct BasketballCourt: BasketballCourtModel {

    var courtID: Int
    var name: String
    var tel: String?
    var address: String
    var rate: Int
    var rateCount: Int
    var gymFuncList: String
    var latitude: String
    var longitude: String

    init(courtID: Int, name: String, tel: String?,
         address: String, rate: Int, rateCount: Int,
         gymFuncList: String, latitude: String, longitude: String) {

        self.courtID = courtID
        self.name = name
        self.tel = tel
        self.address = address
        self.rate = rate
        self.rateCount = rateCount
        self.gymFuncList = gymFuncList
        self.latitude = latitude
        self.longitude = longitude
    }
}
