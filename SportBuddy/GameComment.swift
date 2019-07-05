//
//  GameComment.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/5/4.
//  Copyright © 2017年 stevenchou. All rights reserved.
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
