//
//  LevelManager.swift
//  Courtman
//
//  Created by steven.chou on 2017/4/27.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import Foundation
import Firebase

class LevelManager {

    static let shared = LevelManager()

    typealias LevelHandler = (Level?, String?, Error?) -> Void

    func getUserLevel(currentUserUID: String, completion: @escaping LevelHandler) {

        var level: Level?
        let newUser = "newUser"

        let ref = Database.database().reference()
            .child(Constant.FirebaseLevel.nodeName)
            .child(currentUserUID)

        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            //test
//            completion(nil, newUser, nil)
//            return
            //production
            if snapshot.exists() {

                guard
                    let userLevel = snapshot.value as? [String: Any]
                    else { return }

                guard
                    let baseball = userLevel[Constant.FirebaseLevel.baseball] as? String,
                    let basketball = userLevel[Constant.FirebaseLevel.basketball] as? String,
                    let jogging = userLevel[Constant.FirebaseLevel.jogging] as? String
                    else { return }

                if baseball == "" && basketball == "" && jogging == "" {
                    completion(nil, newUser, nil)
                } else {
                    level = Level(baseball: baseball, basketball: basketball, jogging: jogging)
                    completion(level, nil, nil)
                }

            } else {
                completion(nil, newUser, nil)
            }

        }) { (error) in
            completion(nil, nil, error)
        }
    }

    func updateUserLevel(currentUserUID: String, values: [String: String], completion: @escaping (Error?) -> Void) {

        let ref = Database.database().reference()
            .child(Constant.FirebaseLevel.nodeName)
            .child(currentUserUID)

        ref.updateChildValues(values) { (error, _) in
            if error != nil {
                completion(error)
            }
        }
    }

    func checkLevelStatus(userID: String, playedGamesCount: Int, completion: @escaping (Bool?, Level?) -> Void) {

        getUserLevel(currentUserUID: userID) { (level, _, error) in

            if level != nil {

                var isEnoughToUpgrade: Bool {
                    switch level!.basketball {
                        case "S": return playedGamesCount >= 300
                        case "A": return playedGamesCount >= 150
                        case "B": return playedGamesCount >= 100
                        case "C": return playedGamesCount >= 80
                        case "D": return playedGamesCount >= 60
                        case "E": return playedGamesCount >= 40
                        case "F": return playedGamesCount >= 10
                        default:
                            return playedGamesCount >= 10
                    }
                }

                completion(isEnoughToUpgrade, level)
            }

            if error != nil {
                print("=== Error in checkLevelStatus(): \(String(describing: error))")
            }
        }
    }

    func upgradeBasketballLevel(currentUserUID: String, userCorrentBasketballLevel: String, completion: @escaping (String?, Error?) -> Void) {

        let ref = Database.database().reference()
            .child(Constant.FirebaseLevel.nodeName)
            .child(currentUserUID)

        var nextLevel: String {
            switch userCorrentBasketballLevel {
            case "S": return "SS"
            case "A": return "S"
            case "B": return "A"
            case "C": return "B"
            case "D": return "C"
            case "E": return "D"
            case "F": return "E"
            default:
                return "F"
            }
        }

        let value = [Constant.FirebaseLevel.basketball: nextLevel]

        ref.updateChildValues(value) { (error, _) in
            if error != nil {
                completion(nil, error)
            } else {
                completion(nextLevel, nil)
            }
        }
    }
}
