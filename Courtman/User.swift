//
//  User.swift
//  Courtman
//
//  Created by steven.chou on 2017/3/28.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import Foundation

struct User {

    var email: String
    var name: String
    var gender: String
    var photoURL: String
    var lastTimePlayedGame: String
    var playedGamesCount: Int
    var userID: String

    // todo: 區分各運動項目的 lastTimePlayedGame & playedGamesCount

    init(userID: String, email: String, name: String, gender: String, photoURL: String, lastTimePlayedGame: String, playedGamesCount: Int) {

        self.userID = userID
        self.email = email
        self.name = name
        self.gender = gender
        self.photoURL = photoURL
        self.lastTimePlayedGame = lastTimePlayedGame
        self.playedGamesCount = playedGamesCount
    }
}
