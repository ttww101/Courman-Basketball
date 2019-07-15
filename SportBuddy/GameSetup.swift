//
//  GameSetup.swift
//  SportBuddy
//
//  Created by Wu on 2019/7/15.
//  Copyright © 2019 AGT. All rights reserved.
//

import Foundation

struct GameSetup {
    static var chooseLevel = "S"
    
    static func switchGameStringToInt(_ switchString: String) -> Int {
        switch switchString {
        case "S":
            return 0
        case "A":
            return 1
        case "B":
            return 2
        case "C":
            return 3
        case "D":
            return 4
        case "E":
            return 5
        case "F":
            return 6
        default:
            return 0
        }
    }
}
