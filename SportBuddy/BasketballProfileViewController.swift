//
//  BasketballProfileViewController.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/3/23.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class BasketballProfileViewController: BaseViewController {

    @IBOutlet weak var joinedGamesCount: UILabel!
    @IBOutlet weak var lastGameTime: UILabel!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var levelImage: UIImageView!

    var currentUserUID = ""
    var userInfo: User?

    let loadingIndicator = LoadingIndicator()

    var totalGameNum = 0
    var joinedGamesNum = 0
    var lastGameDate = ""

    var userCorrentBasketballLevel = ""

    var originStarFrame: CGRect?

    override func viewDidLoad() {
        super.viewDidLoad()

        setCurrentUID()
        setUser()
        setView()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getUserJoinedGames()
    }

    override func viewDidLayoutSubviews() {

        setHidingStar()
    }

    func setCurrentUID() {

        guard
            let uid = Auth.auth().currentUser?.uid
            else { return }

        self.currentUserUID = uid
    }

    func setUser() {

        UserManager.shared.getUserInfo(currentUserUID: currentUserUID) { (user, error) in

            if error == nil {
                self.userInfo = user
            } else {
                print("=== error in BasketballProfileViewController: \(String(describing: error))")
            }
        }
    }

    func setView() {

        setBackground(imageName: Constant.BackgroundName.basketball)

        setNavigationBar()
    }

    func setNavigationBar() {

        navigationItem.leftBarButtonItem = createBackButton(action: #selector(backToSportItemsView))
        transparentizeNavigationBar(navigationController: self.navigationController)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Button_Mail"),
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(sendEmail))
    }

    @objc func sendEmail() {
        if MFMailComposeViewController.canSendMail() {

            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            mailController.setToRecipients(["sportbuddy.tw@gmail.com"])
            mailController.setSubject("Sport Buddy 回報")
            mailController.setMessageBody("<p>如果您在使用上有遇到什麼問題，或是有什麼球場資訊可以跟我們分享，歡迎寫下您的訊息並寄送給我們</p>", isHTML: true)

            mailController.navigationController?.navigationBar.tintColor = .blue

            // todo: 改不了 navigationBar title的顏色
            mailController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.blue]

            present(mailController, animated: true)

        } else {

            let alertController = UIAlertController(title: "無法寄信", message: "您的裝置目前無法寄送email\n請確認您的信箱設定", preferredStyle: .alert)

            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)

            self.present(alertController, animated: true, completion: nil)
        }
    }

    func setHidingStar() {

        originStarFrame = starImage.frame
        starImage.isHidden = true
    }

    func getUserJoinedGames() {

        totalGameNum = 0
        joinedGamesNum = 0
        lastGameDate = ""

        let ref = Database.database().reference()
                    .child(Constant.FirebaseUserGameList.nodeName)
                    .child(currentUserUID)

        // MARK: - Start Loading Indicator
        loadingIndicator.start()

        ref.observeSingleEvent(of: .value, with: { (snapshot) in

            if snapshot.exists() {

                for gameID in ((snapshot.value as AnyObject).allKeys) {

                    guard
                        let gameIDString = gameID as? String
                        else { return }

                    let totalGames = (snapshot.value as AnyObject).allKeys.count

                    self.getUserHasDoneGamesInfo(gameIDString, totalGames)
                }
            } else {
                print("=== Can't find any date in BasketballProfileViewController - getUserJoinedGames()")

                LevelManager.shared.getUserLevel(currentUserUID: self.currentUserUID) { (level, _, error) in

                    if level != nil {
                        self.setLevelImage(level: (level?.basketball)!)
                    }

                    if error != nil {
                        print("=== Error in BasketballProfileViewController getUserJoinedGames(): \(String(describing: error))")
                    }
                }
                self.setUpgradeButton(isEnoughToUpgrade: false)
                self.loadingIndicator.stop()
            }
        })
    }

    func getUserHasDoneGamesInfo(_ gameIDString: String, _ totalGames: Int) {

        let parser = BasketballGameParser()

        let gameRef = Database.database().reference()
            .child(Constant.FirebaseGame.nodeName)
            .child(gameIDString)

        gameRef.observeSingleEvent(of: .value, with: { (snap) in

            self.totalGameNum += 1

            if snap.exists() {
                let game = parser.parserGame(snap)

                guard game != nil else { return }

                let isOwnerInGame = self.checkOwnerInGame(game!)
                let isOverTime = self.checkGameTime(game!)

                // 1. Count how many games user had joined
                // 2. Get the date of last game
                if isOwnerInGame && isOverTime {
                    self.joinedGamesNum += 1
                    self.setLastGameTime(self.lastGameDate, game!)
                }

                // Set data to UI & firebase in final of  this loop
                if self.totalGameNum == totalGames {
                    DispatchQueue.main.async {
                        self.joinedGamesCount.text = String(self.joinedGamesNum)
                        if self.lastGameDate != "" {
                            self.lastGameTime.text = String(self.lastGameDate)
                        }
                    }
                    self.setUpgradeButtonAndUserLevel()
                    self.updateFireBaseDB()
                }
            } else {
                print("=== Can't find the game: \(snap.key) in BasketballProfileViewController")
            }
        })
    }

    func setUpgradeButtonAndUserLevel() {

        LevelManager.shared.checkLevelStatus(userID: currentUserUID, playedGamesCount: (userInfo?.playedGamesCount)!) { (isEnoughToUpgrade, userLevelInfo) in

            guard
                isEnoughToUpgrade != nil,
                userLevelInfo != nil
                else { return }

            self.setUpgradeButton(isEnoughToUpgrade: isEnoughToUpgrade!)

            self.userCorrentBasketballLevel = (userLevelInfo?.basketball)!
            self.setLevelImage(level: (userLevelInfo?.basketball)!)
        }
    }

    func setLevelImage(level: String) {

        var image: UIImage {
            switch level {
            case "A": return #imageLiteral(resourceName: "Level_A")
            case "B": return #imageLiteral(resourceName: "Level_B")
            case "C": return #imageLiteral(resourceName: "Level_C")
            case "D": return #imageLiteral(resourceName: "Level_D")
            case "E": return #imageLiteral(resourceName: "Level_E")
            default:
                return #imageLiteral(resourceName: "Level_A")
            }
        }

        self.levelImage.image = image
        self.levelImage.layer.cornerRadius = self.levelImage.bounds.size.height / 2.0
    }

    func setUpgradeButton(isEnoughToUpgrade: Bool) {

        if isEnoughToUpgrade {

            self.upgradeButton.setImage(#imageLiteral(resourceName: "Button_LevelUp"), for: .normal)
            self.upgradeButton.isEnabled = true

        } else {

            let converter = ConverImageToBW()
            let upgrateImageBW = converter.convertImageToBW(image: #imageLiteral(resourceName: "Button_LevelUp"))
            self.upgradeButton.setImage(upgrateImageBW, for: .normal)
            self.upgradeButton.isEnabled = false
        }
    }

    func updateFireBaseDB() {

        let ref = Database.database().reference()
                    .child(Constant.FirebaseUser.nodeName)
                    .child(currentUserUID)

        let userUpdatedInfo: [String: Any] = [Constant.FirebaseUser.playedGamesCount: joinedGamesNum,
                                              Constant.FirebaseUser.lastTimePlayedGame: lastGameDate]

        ref.updateChildValues(userUpdatedInfo) { (error, _) in

            if error != nil {
                print("=== Error in BasketballProfileViewController: \(String(describing: error))")
            }

            // MARK: - Stop Loading Indicator
            self.loadingIndicator.stop()
        }

    }

    // MARK: - Check Owner in game
    func checkOwnerInGame(_ game: BasketballGame) -> Bool {

        var isOwnerInGame = true

        let owner = game.members.filter({ (member) -> Bool in
            member == game.owner
        })

        if owner.count == 0 {
            isOwnerInGame = false
        }

        return isOwnerInGame
    }

    // MARK: - Check game time
    func checkGameTime(_ game: BasketballGame) -> Bool {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.locale = Locale.current

        let currectTime = formatter.string(from: Date())

        return currectTime > game.time
    }

    // MARK: - Check last game time
    func setLastGameTime(_ tempLastGameTime: String, _ game: BasketballGame) {

        var time = ""

        if tempLastGameTime > game.time {
            time = tempLastGameTime
        } else {
            time = game.time
        }

        // Remove hh:mm
        let splitedArray = time.characters.split { $0 == " " }.map(String.init)

        self.lastGameDate = splitedArray[0]
    }

    @IBAction func upgrade(_ sender: Any) {

        // todo: 多幾次測試，加上升級動畫
        LevelManager.shared.upgradeBasketballLevel(currentUserUID: currentUserUID, userCorrentBasketballLevel: userCorrentBasketballLevel) { (nextLevel, error) in

            if nextLevel != nil {
                print("Level Up!!")
                self.setUpgradeButton(isEnoughToUpgrade: false)
                self.setLevelImage(level: nextLevel!)

//                self.showLevelUpAnimation()
            }

            if error != nil {
                print("=== Error in BasketballProfileViewController upgrade(): \(String(describing: error))")
            }
        }
    }

    func showLevelUpAnimation() {
        print("Show LevelUp Animation")

        guard originStarFrame != nil else { return }

        self.starImage.isHidden = false

//        self.starImage.frame = CGRect(x: 215.5, y: 424.5, width: 54.5, height: 54.5)
//
//        let width = (originStarFrame?.width)! * 3
//        let height = (originStarFrame?.height)! * 3

        UIView.animate(withDuration: 2.0, delay: 0.0, options:
            UIViewAnimationOptions.curveEaseOut, animations: {

                self.starImage.frame = CGRect(x: 10, y: -200,
                                              width: self.starImage.frame.size.width * 3,
                                              height: self.starImage.frame.size.height * 3)
        }, completion: { _ -> Void in
            self.starImage.isHidden = true
            self.starImage.frame = self.originStarFrame!
            print("Finish Animation")
        })
    }
}

// MARK: - Setting MessageUI
extension BasketballProfileViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
