//
//  vc.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import UserNotifications
import FSPagerView
import LTMorphingLabel
import LGButton

class SportsMenuViewController: BaseViewController {
    //profile
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    //infos
    @IBOutlet weak var joinedGamesCountLabel: LTMorphingLabel!
    @IBOutlet weak var lastGameTime: LTMorphingLabel!
    @IBOutlet weak var pendingGamesCountLabel: LTMorphingLabel!
    @IBOutlet weak var nextGameTimeLabel: LTMorphingLabel!
    @IBOutlet weak var levelImage: UIImageView!
    @IBOutlet weak var upgradeButton: LGButton!
    
    var currentUserUID = ""
    var userInfo: User?
    
    var totalGameCount = 0
    var joinedGamesNum = 0
    var lastGameDate = ""
    var nextGameDate = ""
    
    var userCorrentBasketballLevel = ""
    
    var originStarFrame: CGRect?
    
    let loadingIndicator = LoadingIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkIfUserIsLoggedIn()
        setView()
        prepareNotification()
        
        setCurrentUIDnLevel()
        setUser()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserProfile()
        getUserJoinedGames()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        userImage.layer.cornerRadius = userImage.bounds.size.height / 2.0
        userImage.layer.borderWidth = 1.0
        userImage.layer.masksToBounds = true
    }
    
    func setCurrentUIDnLevel() {
        
        guard
            let uid = Auth.auth().currentUser?.uid
            else { return }
        
        self.currentUserUID = uid
        setUserLevel()
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
//        setBackground(imageName: "BG_Menu")
        setBackground(imageName: "BG_Menu")
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(goToEditProfile))
        self.userImage.addGestureRecognizer(tapGes)
    }

    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        }
    }

    func handleLogout() {

        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            errorHandle(errString: nil, error: logoutError)
        }

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let loginStorybard = UIStoryboard(name: Constant.Storyboard.login, bundle: nil)
            let loginViewController = loginStorybard.instantiateViewController(withIdentifier: Constant.Controller.login) as? LoginViewController

            appDelegate.window?.rootViewController = loginViewController
        }
    }

    @IBAction func editButtonDidTouchupInside(_ sender: Any) {
        goToEditProfile()
    }

    @IBAction func logout(_ sender: Any) {

        if Auth.auth().currentUser?.uid != nil {
            handleLogout()
        }
    }
    
    @IBAction func playButtonDidTouchupInside(_ sender: Any) {
        self.toChooseLevelViewController()
    }
}

// MARK: - Load Image and Set to ImageView
extension SportsMenuViewController {

    func loadImage(imageUrlString: String, imageView: UIImageView) {

        var imageData: Data?

        let workItem = DispatchWorkItem {
            if let imageUrl = URL(string: imageUrlString) {
                do {
                    imageData = try Data(contentsOf: imageUrl)
                } catch {
                    self.errorHandle(errString: nil, error: error)
                }
            }
        }

        workItem.perform()

        let queue = DispatchQueue.global(qos: .default)

        queue.async(execute: workItem)

        workItem.notify(queue: DispatchQueue.main) {
            guard
                imageData != nil
                else { return }

            if let image = UIImage(data: imageData!) {
                imageView.image = image
            }

            self.loadingIndicator.stop()
        }
    }
}

//MARK: Info
extension SportsMenuViewController {
    
    func getUserJoinedGames() {
        //resfresh every time get
        totalGameCount = 0
        joinedGamesNum = 0
        lastGameDate = ""
        nextGameDate = ""
        
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
//                    print((snapshot.value as AnyObject).allKeys)
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
    
    func getUserHasDoneGamesInfo(_ gameIDString: String, _ totalGameNum: Int) {
        
        let parser = BasketballGameParser()
        
        let gameRef = Database.database().reference()
            .child(Constant.FirebaseGame.nodeName)
            .child(gameIDString)
        
        gameRef.observeSingleEvent(of: .value, with: { (snap) in
            
            self.totalGameCount += 1
            
            if snap.exists() {
                let game = parser.parserGame(snap)
                
                guard game != nil else { return }
                
                let isOwnerInGame = self.checkOwnerInGame(game!)
                let isOverTime = self.checkLastGameTime(game!)
                self.nextGameDate = self.checkNextTime(game!)
                
                // 1. Count how many games user had joined
                // 2. Get the date of last game
                if isOwnerInGame && isOverTime {
                    self.joinedGamesNum += 1
                    self.setLastGameTime(self.lastGameDate, game!)
                } else {
                    //TODO : Last game time
                }
                
                //finish count
                if self.totalGameCount == totalGameNum {
                    
                    DispatchQueue.main.async {
                        self.joinedGamesCountLabel.text = String(self.joinedGamesNum)
                        self.pendingGamesCountLabel.text = String(totalGameNum - self.joinedGamesNum)
                        self.nextGameTimeLabel.text = self.nextGameDate
                        if self.lastGameDate != "" {
                            self.lastGameTime.text = String(self.lastGameDate)
                        }
                    }
                    self.setUpgradeButtonAndUserLevel()
                    self.updateFireBaseDB()
                }
            } else {
                print("=== Can't find the game: \(snap.key) in BasketballProfileViewController")
                print(self.currentUserUID)
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
            case "S": return #imageLiteral(resourceName: "Level_S")
            case "A": return #imageLiteral(resourceName: "Level_A")
            case "B": return #imageLiteral(resourceName: "Level_B")
            case "C": return #imageLiteral(resourceName: "Level_C")
            case "D": return #imageLiteral(resourceName: "Level_D")
            case "E": return #imageLiteral(resourceName: "Level_E")
            case "F": return #imageLiteral(resourceName: "Level_F")
            default:
                return #imageLiteral(resourceName: "Level_A")
            }
        }
        
        self.levelImage.image = image
        self.levelImage.layer.cornerRadius = self.levelImage.bounds.size.height / 2.0
    }
    
    func setUpgradeButton(isEnoughToUpgrade: Bool) {
        
        if isEnoughToUpgrade {
            
            self.upgradeButton.borderColor = .init(red: 248/255, green: 242/255, blue: 222/255, alpha: 1.0)
//            self.upgradeButton.shadowColor = .white
            self.upgradeButton.isEnabled = true
            self.upgradeButton.gradientStartColor = .init(red: 248/255, green: 242/255, blue: 222/255, alpha: 1.0)
            self.upgradeButton.gradientEndColor = .init(red: 255/255, green: 210/255, blue: 83/255, alpha: 1.0)
            
        } else {
            self.upgradeButton.borderColor = .lightGray
            self.upgradeButton.shadowOpacity = 0.1
            self.upgradeButton.shadowRadius = 0
            self.upgradeButton.isEnabled = false
            self.upgradeButton.gradientStartColor = .lightGray
            self.upgradeButton.gradientEndColor = .darkGray
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
    func checkLastGameTime(_ game: BasketballGame) -> Bool {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.locale = Locale.current
        let currectTime = formatter.string(from: Date())
        
        return currectTime > game.time
    }
    
    func checkNextTime(_ game: BasketballGame) -> String {
        
        if self.nextGameDate == "" {
            return game.time
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.locale = Locale.current
        let currectTime = formatter.string(from: Date())
        if game.time < currectTime {
            return nextGameDate
        }
        
        if game.time < self.nextGameDate {
            return game.time
        }
        
        return self.nextGameDate
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
//        let splitedArray = time.characters.split { $0 == " " }.map(String.init)
        
        self.lastGameDate = time
    }
    
    @IBAction func upgradeDidTouchUpInside(_ sender: Any) {
        
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
        
        //        self.starImage.frame = CGRect(x: 215.5, y: 424.5, width: 54.5, height: 54.5)
        //
        //        let width = (originStarFrame?.width)! * 3
        //        let height = (originStarFrame?.height)! * 3
        
        UIView.animate(withDuration: 2.0, delay: 0.0, options:
            UIView.AnimationOptions.curveEaseOut, animations: {
                
        }, completion: { _ -> Void in
            print("Finish Animation")
        })
    }


}

// MARK: - Error handle
extension SportsMenuViewController {

    func errorHandle(errString: String?, error: Error?) {

        if errString != nil {
            print("=== Error: \(String(describing: errString))")
        }

        if error != nil {
            print("=== Error: \(String(describing: error))")
        }

        loadingIndicator.stop()
    }
}

//MARK: Profile
extension SportsMenuViewController {
    
    func setUserProfile() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        loadingIndicator.start()
        
        UserManager.shared.getUserInfo(currentUserUID: uid) { (user, error) in
            
            self.loadingIndicator.stop()
            
            if user != nil {
                self.userName.text = user!.name
                
                UserManager.shared.getUserProfileImage(from: user!.photoURL, completion: { (image, error) in
                    self.userImage.image = image
                })
            }
            
            if error != nil {
                self.errorHandle(errString: "Erro - User Profile Setup\(String(describing: error?.localizedDescription))", error: nil)
            }
        }
    }
    
    func setUserLevel() {
        LevelManager.shared.getUserLevel(currentUserUID: self.currentUserUID) { (level, _, error) in
            
            if level != nil {
                self.setLevelImage(level: (level?.basketball)!)
            }
            
            if error != nil {
                print("=== Error in BasketballProfileViewController getUserJoinedGames(): \(String(describing: error))")
            }
        }
        self.setUpgradeButton(isEnoughToUpgrade: false)
    }
}

//MARK: Private
extension SportsMenuViewController {

    @objc func goToEditProfile() {
        let editProfileStorybard = UIStoryboard(name: Constant.Storyboard.editProfile, bundle: nil)
        guard let vc = editProfileStorybard.instantiateViewController(withIdentifier: Constant.Controller.editProfile) as? EditProfileViewController else { return }
        let nav = UINavigationController(rootViewController: vc)
        
        self.present(nav, animated: true, completion: {
            vc.userImage.image = self.userImage.image
            vc.nameTextField.text = self.userName.text
        })
    }
    
    func toChooseLevelViewController() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            let chooseLevelStorybard = UIStoryboard(name: Constant.Storyboard.chooseLevel, bundle: nil)
            let vc = chooseLevelStorybard.instantiateViewController(withIdentifier: Constant.Controller.chooseLevel) as? ChooseLevelViewController
            vc?.type = .pickGame
            appDelegate.window?.rootViewController = vc
        }
    }
 
    func prepareNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = Constant.UserNotifacationContent.title
        content.body = Constant.UserNotifacationContent.body
        content.sound = UNNotificationSound.default
        
        let secendsOfDay: Double = 60 * 60 * 24
        let days: Double = 10 * secendsOfDay
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: days, repeats: false)
        let request = UNNotificationRequest(identifier: Constant.UserNotifacationIdentifier.comeBackToPlayGame, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}
