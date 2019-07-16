//
//  BasketballGame.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import Foundation

struct BasketballGame {

    var gameID: String
    var owner: String
    var item: String
    var name: String
    var time: String
    var court: BasketballCourt
    var level: String
    var members: [String]

    init(gameID: String, owner: String, item: String,
         name: String, time: String,
         court: BasketballCourt, level: String,
         members: [String]) {

        self.gameID = gameID
        self.owner = owner
        self.item = item
        self.name = name
        self.time = time
        self.court = court
        self.level = level
        self.members = members
    }
}
