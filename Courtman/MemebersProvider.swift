//
//  MemebersProvider.swift
//  Courtman
//
//  Created by steven.chou on 2017/4/22.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import Foundation
import Firebase

class MemebersProvider {

    static let sharded = MemebersProvider()

    typealias GetMembersCompletion = ([String]) -> Void

    func getMembers(gameID: String, completion: @escaping GetMembersCompletion) {

        var members: [String] = []

        let ref = Database.database().reference()
            .child(Constant.FirebaseGame.nodeName)
            .child(gameID)
            .child(Constant.FirebaseGame.members)

        ref.observeSingleEvent(of: .value, with: { (snapshot) in

            if snapshot.exists() {

                if let membersData = snapshot.value as? [String] {
                    members = membersData
                }

            } else {
                print("=== Can't get the members in MemebersProvider")
            }

            completion(members)
        })
    }
}
