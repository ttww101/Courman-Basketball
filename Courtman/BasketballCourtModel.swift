//
//  BasketballCourtModel.swift
//  Courtman
//
//  Created by steven.chou on 2017/3/27.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import Foundation

protocol BasketballCourtModel {

    var courtID: Int { get }

    var name: String { get }

    var tel: String? { get }

    var address: String { get }

    var rate: Int { get }

    var rateCount: Int { get }

    var gymFuncList: String { get }

    var latitude: String { get }

    var longitude: String { get }
}
