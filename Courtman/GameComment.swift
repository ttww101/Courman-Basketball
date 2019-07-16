//
//  GameComment.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import Foundation

struct GameComment {

    let commentOwner: String
    let comment: String

    init(commentOwner: String, comment: String) {

        self.commentOwner = commentOwner
        self.comment = comment
    }
}
