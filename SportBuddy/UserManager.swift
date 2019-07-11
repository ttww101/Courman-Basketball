//
//  UserManager.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/4/27.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import Foundation
import Firebase

class UserManager {

    static let shared = UserManager()

    typealias UserHandler = (User?, Error?) -> Void
    
    typealias ProfileImageHandler = (UIImage?, Error?) -> Void

    func getUserInfo(currentUserUID: String, completion: @escaping UserHandler) {

        var user: User?

        let ref = Database.database().reference()
            .child(Constant.FirebaseUser.nodeName)
            .child(currentUserUID)

        ref.observeSingleEvent(of: .value, with: { (snapshot) in

            if snapshot.exists() {

                guard
                    let userData = snapshot.value as? [String: Any]
                    else { return }

                guard
                     let userID = userData[Constant.FirebaseUser.userID] as? String,
                    let name = userData[Constant.FirebaseUser.name] as? String,
                    let email = userData[Constant.FirebaseUser.email] as? String,
                    let gender = userData[Constant.FirebaseUser.gender] as? String,
                    let photoURL = userData[Constant.FirebaseUser.photoURL] as? String,
                    let lastTimePlayedGame = userData[Constant.FirebaseUser.lastTimePlayedGame] as? String,
                    let playedGamesCount = userData[Constant.FirebaseUser.playedGamesCount] as? Int
                    else { return }

                user = User(userID:userID, email: email, name: name, gender: gender,
                            photoURL: photoURL, lastTimePlayedGame: lastTimePlayedGame,
                            playedGamesCount: playedGamesCount)

            } else {
                print("=== Firebase Can't find this user")
            }

            completion(user, nil)

        }) { (error) in

            completion(nil, error)
        }
    }
    
//    func getUserInfo(currentUserUID: String, completion: @escaping UserHandler) {
    
    func getUserProfileImage(from url: String, completion: @escaping ProfileImageHandler) {
            
        let storageRef = Storage.storage().reference()
        
        let islandRef = storageRef.child(url)
        
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(nil, error)
            } else {
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    completion(image, nil)
                }
            }
        }
    }
}
