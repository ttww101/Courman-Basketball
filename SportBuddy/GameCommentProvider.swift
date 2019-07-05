//
//  GameCommentProvider.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/5/5.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import Foundation
import Firebase

class GameCommentProvider {

    static let sharded = GameCommentProvider()

    typealias GetCommentCompletion = ([GameComment]) -> Void

    func getComments(gameID: String, completion: @escaping GetCommentCompletion) {

        var comments: [GameComment] = []

        let ref = FIRDatabase.database().reference()
            .child(Constant.FirebaseGameMessage.nodeName)
            .child(gameID)

        ref.observeSingleEvent(of: .value, with: { (snapshot) in

            for childSnap in snapshot.children.allObjects {

                guard
                    let snap = childSnap as? FIRDataSnapshot
                    else {
                        print("=== Can't get the comment in GameCommentProvider")
                        return
                }

                if let snapshotDictionary = snapshot.value as? NSDictionary,
                    let commentData = snapshotDictionary[snap.key] as? [String: String],
                    let userID = commentData[Constant.FirebaseGameMessage.userID],
                    let comment = commentData[Constant.FirebaseGameMessage.comment] {

                    let gameComment = GameComment(commentOwner: userID, comment: comment)
                    comments.append(gameComment)
                }
            }

            completion(comments)
        })
    }
}
