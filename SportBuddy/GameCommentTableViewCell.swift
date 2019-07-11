//
//  GameCommentTableViewCell.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/5/4.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit
import Firebase

protocol CommentCallDelegate: class {
    func showAlert(title: String, message: String)
}

class GameCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentMainView: UIView!
    @IBOutlet weak var commentTitleLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var editCommentView: UIView!

    class var identifier: String { return String(describing: self) }

    weak var commentDelegate: CommentCallDelegate?

    static let defaultHeight: CGFloat = 40.0
    static let height: CGFloat = 240.0

    let loadingIndicator = LoadingIndicator()

    var currentUser: String?
    var game: BasketballGame?
    var members: [User] = []
    var comments: [GameComment] = []
    var commentOwnersPhoto: [String: UIImage] = [:]

    var isEndCell = false

    override func awakeFromNib() {
        super.awakeFromNib()

        commentTableView.dataSource = self
        commentTableView.delegate = self

        getUser()
        initNib()
        setView()
    }

    func getUser() {

        guard
            let uid = Auth.auth().currentUser?.uid
            else { return }

        currentUser = uid
    }

    func initNib() {

        let commentNib = UINib(nibName: CommentDetailTableViewCell.identifier, bundle: nil)
        commentTableView.register(commentNib, forCellReuseIdentifier: CommentDetailTableViewCell.identifier)
    }

    func setView() {

        commentTableView.separatorStyle = .none
        commentTableView.rowHeight = UITableView.automaticDimension
        commentTableView.estimatedRowHeight = 22

        commentTitleLabel.textColor = .white

        commentTextField.backgroundColor = .clear
        commentTextField.layer.cornerRadius = 8.0
        commentTextField.layer.masksToBounds = true
        commentTextField.layer.borderColor = UIColor.gray.cgColor
        commentTextField.layer.borderWidth = 2.0
        commentTextField.textColor = .white

        commentButton.tintColor = .white
        commentButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        editCommentView.addGestureRecognizer(tap)

        moveToLastComment()
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {}

    @objc func sendMessage() {

        var gameID = ""
        var isUserInGame = false

        if game != nil {
            gameID = (game?.gameID)!
        } else {
            return
        }

        for member in (game?.members)! {
            if currentUser == member {
                isUserInGame = true
            }
        }

        if commentTextField.text == "" {
            self.commentDelegate?.showAlert(title: "訊息", message: "請輸入留言內容")
        } else if !isUserInGame {
            self.commentDelegate?.showAlert(title: "訊息", message: "必須是球賽裡頭的成員才能留言")
        } else {
            saveComment(gameID)
            commentTextField.text = ""
        }
    }

    func saveComment(_ gameID: String) {

        let ref = Database.database().reference()
            .child(Constant.FirebaseGameMessage.nodeName)
            .child(gameID)
            .childByAutoId()

        let value: [String: String] = [Constant.FirebaseGameMessage.userID: currentUser!,
                     Constant.FirebaseGameMessage.comment: commentTextField.text!]

        ref.updateChildValues(value) { (error, _) in
            if error != nil {
                print("=== Error in GameCommentTableViewCell: \(String(describing: error))")
            }
        }

        let comment = GameComment(commentOwner: self.currentUser!, comment: self.commentTextField.text!)
        self.comments.append(comment)

        self.commentTableView.beginUpdates()
        self.commentTableView.insertRows(at: [IndexPath(row: self.comments.count - 1, section: 0)], with: .automatic)
        self.commentTableView.endUpdates()

        self.commentTableView.reloadData()

        moveToLastComment()
    }

    func moveToLastComment() {
        if commentTableView.contentSize.height > commentTableView.frame.height {
            // First figure out how many sections there are
            let lastSectionIndex = commentTableView.numberOfSections - 1

            // Then grab the number of rows in the last section
            let lastRowIndex = commentTableView.numberOfRows(inSection: lastSectionIndex) - 1

            // Now just construct the index path
            let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)

            // Make the last row visible
            commentTableView.scrollToRow(at: pathToLastRow as IndexPath,
                                         at: UITableView.ScrollPosition.bottom,
                                         animated: true)
        }
    }
}

// MARK: - TableView
extension GameCommentTableViewCell: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = CommentDetailTableViewCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CommentDetailTableViewCell

        cell.selectionStyle = .none

        if comments.count != 0 {
            cell.comment.text = comments[indexPath.row].comment

            if members.count != 0 {
                self.loadAndSetUserPhoto(cell.userImage, self.members[indexPath.row].photoURL)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // todo: 點擊後可看訊息詳細的時間
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
                        userImage.image = image
                    }
                }
            }
        }
    }
}
