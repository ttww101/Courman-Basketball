//
//  User.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
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
