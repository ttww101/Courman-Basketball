//
//  MembersTableViewCell.swift
//  Courtman
//
//  Created by steven.chou on 2017/4/19.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit
import Firebase

class MembersTableViewCell: UITableViewCell, Identifiable {

    // MARK: Property
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var memberCellTitle: UILabel!

    class var identifier: String { return String(describing: self) }

    static let height: CGFloat = 185.0
    static let defaultHeight: CGFloat = 40.0

    var game: BasketballGame?
    var members: [User] = []

    let fullScreenSize = UIScreen.main.bounds.size

    override func awakeFromNib() {
        super.awakeFromNib()

        memberCellTitle.textColor = .white

        collectionView.dataSource = self
        collectionView.delegate = self

        initNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func initNib() {

        let memberNib = UINib(nibName: MemberCollectionViewCell.identifier, bundle: nil)
        collectionView.register(memberNib, forCellWithReuseIdentifier: MemberCollectionViewCell.identifier)
    }
    
    func loadAndSetUserPhoto(_ userImage: UIImageView, _ userPhotoUrlString: String) {

        DispatchQueue.global().async {
            
            let storageRef = Storage.storage().reference()
            
            let islandRef = storageRef.child(userPhotoUrlString)
            
            islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("=== \(error)")
                } else {
                    let image = UIImage(data: data!)
                    DispatchQueue.main.async {
                        userImage.layer.cornerRadius = userImage.bounds.size.height / 2.0
                        userImage.layer.masksToBounds = true
                        userImage.image = image
                    }
                }
            }
        }
    }
}

extension MembersTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return game?.members.count ?? 0
    }

    // swiftlint:disable force_cast
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard
            game != nil
            else { return UICollectionViewCell() }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCollectionViewCell.identifier, for: indexPath) as! MemberCollectionViewCell

        cell.userImage.layer.cornerRadius = cell.userImage.bounds.size.height / 2.0
        cell.userImage.layer.masksToBounds = true

        if members.count > indexPath.row {
//            for member in members {
//                if (comments[indexPath.row].commentOwner == member.userID) {
//                    self.loadAndSetUserPhoto(cell.userImage, member.photoURL)
//                    break
//                }
//
//            }
            cell.userName.text = members[indexPath.row].name
            loadAndSetUserPhoto(cell.userImage, (members[indexPath.row].photoURL))
        }
        return cell
    }
    // swiftlint:enable force_cast

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        guard
            let memberCell = cell as? MemberCollectionViewCell
            else { return }

        memberCell.userImage.layer.cornerRadius = memberCell.userImage.bounds.size.height / 2.0
        memberCell.userImage.layer.masksToBounds = true
    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let size = fullScreenSize.width / 3
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        return sectionInsets
    }
}
