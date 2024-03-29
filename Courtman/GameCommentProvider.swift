//
//  GameCommentProvider.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import Foundation
import Firebase

class GameCommentProvider {

    static let sharded = GameCommentProvider()

    typealias GetCommentCompletion = ([GameComment]) -> Void

    func getComments(gameID: String, completion: @escaping GetCommentCompletion) {

        var comments: [GameComment] = []

        let ref = Database.database().reference()
            .child(Constant.FirebaseGameMessage.nodeName)
            .child(gameID)

        ref.observeSingleEvent(of: .value, with: { (snapshot) in

            for childSnap in snapshot.children.allObjects {

                guard
                    let snap = childSnap as? DataSnapshot
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
