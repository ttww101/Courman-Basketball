//
//  UserWithPhotoURL.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
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
