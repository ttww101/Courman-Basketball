//
//  BasketballGameParser.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import Firebase

class BasketballGameParser {

    func parserGame(_ snap: DataSnapshot) -> BasketballGame? {

        if let gameInfo = snap.value as? NSDictionary,
            let gameCourt = gameInfo[Constant.FirebaseGame.court] as? NSDictionary,
            let gameID = gameInfo[Constant.FirebaseGame.gameID] as? String,
            let gameItem = gameInfo[Constant.FirebaseGame.item] as? String,
            let gameLevel = gameInfo[Constant.FirebaseGame.level] as? String,
            let gameName = gameInfo[Constant.FirebaseGame.name] as? String,
            let gameOwner = gameInfo[Constant.FirebaseGame.owner] as? String,
            let gameMembers = gameInfo[Constant.FirebaseGame.members] as? [String],
            let gameTime = gameInfo[Constant.FirebaseGame.time] as? String {

            if let address = gameCourt[Constant.CourtInfo.address] as? String,
                let name = gameCourt[Constant.CourtInfo.name] as? String,
                let gymFuncList = gameCourt[Constant.CourtInfo.gymFuncList] as? String,
                let courtID = gameCourt[Constant.CourtInfo.courtID] as? Int,
                let latitude = gameCourt[Constant.CourtInfo.latitude] as? String,
                let longitude = gameCourt[Constant.CourtInfo.longitude] as? String,
                let tel = gameCourt[Constant.CourtInfo.tel] as? String?,
                let rate = gameCourt[Constant.CourtInfo.rate] as? Int,
                let rateCount = gameCourt[Constant.CourtInfo.rateCount] as? Int {

                let basketballCourt = BasketballCourt(courtID: courtID, name: name, tel: tel, address: address, rate: rate, rateCount: rateCount, gymFuncList: gymFuncList, latitude: latitude, longitude: longitude)

                let basketballGame = BasketballGame(gameID: gameID, owner: gameOwner, item: gameItem, name: gameName, time: gameTime, court: basketballCourt, level: gameLevel, members: gameMembers)

                return basketballGame
            }
            return nil
        }
        return nil
    }
}
