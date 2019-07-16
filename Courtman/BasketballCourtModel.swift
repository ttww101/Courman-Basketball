//
//  BasketballCourtModel.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
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
