//
//  UserWithPhotoURL.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/5/6.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import Foundation

struct UserWithPhotoURL {

    var userID: String
    var photoURL: String

    init(userID: String, photoURL: String) {

        self.userID = userID
        self.photoURL = photoURL
    }
}
