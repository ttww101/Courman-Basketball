//
//  vc.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/3/23.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import UserNotifications

class SportsMenuViewController: BaseViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var jogButton: UIButton!
    @IBOutlet weak var baseballButton: UIButton!

    let loadingIndicator = LoadingIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()

        checkIfUserIsLoggedIn()
        setView()
        prepareNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setUserInfo()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        userImage.layer.cornerRadius = userImage.bounds.size.height / 2.0
        userImage.layer.borderWidth = 1.0
        userImage.layer.masksToBounds = true
    }

    func setView() {

        setBackground(imageName: Constant.BackgroundName.basketball)

        // todo: 滑動選單

        let converter = ConverImageToBW()
        let jobImageBW = converter.convertImageToBW(image: #imageLiteral(resourceName: "Item_Jog"))
        jogButton.setImage(jobImageBW, for: .normal)
        jogButton.isEnabled = false

        let baseballImageBW = converter.convertImageToBW(image: #imageLiteral(resourceName: "Item_Baseball"))
        baseballButton.setImage(baseballImageBW, for: .normal)
        baseballButton.isEnabled = false
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

    func prepareNotification() {

        let content = UNMutableNotificationContent()
        content.title = Constant.UserNotifacationContent.title
        content.body = Constant.UserNotifacationContent.body
        content.sound = UNNotificationSound.default()

        let secendsOfDay: Double = 60 * 60 * 24
        let days: Double = 10 * secendsOfDay

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: days, repeats: false)
        let request = UNNotificationRequest(identifier: Constant.UserNotifacationIdentifier.comeBackToPlayGame, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    func setUserInfo() {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        loadingIndicator.start()

        UserManager.shared.getUserInfo(currentUserUID: uid) { (user, error) in

            self.loadingIndicator.stop()
            
            if user != nil {
                self.userName.text = user!.name
                self.loadImage(imageUrlString: user!.photoURL, imageView: self.userImage)
            }

            if error != nil {
                self.errorHandle(errString: "Can't find the data", error: nil)
            }
        }
    }

    @IBAction func toEditProfile(_ sender: Any) {

        let editProfileStorybard = UIStoryboard(name: Constant.Storyboard.editProfile, bundle: nil)
        let editProfileViewController = editProfileStorybard.instantiateViewController(withIdentifier: Constant.Controller.editProfile) as? EditProfileViewController

        self.present(editProfileViewController!, animated: true, completion: nil)
    }

    // todo: add another item button action
    @IBAction func toBasketballGameList(_ sender: Any) {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        LevelManager.shared.getUserLevel(currentUserUID: uid) { (level, newUser, error) in

            if level != nil {
                self.toBasketballTabbarViewController()
            }

            if newUser != nil {
                let values = [Constant.FirebaseLevel.basketball: "",
                              Constant.FirebaseLevel.baseball: "",
                              Constant.FirebaseLevel.jogging: ""]

                LevelManager.shared.updateUserLevel(currentUserUID: uid, values: values, completion: { (error) in

                    if error != nil {
                        self.errorHandle(errString: nil, error: error)
                        return
                    }
                })

                self.toChooseLevelViewController()
            }

            if error != nil {
                self.errorHandle(errString: nil, error: error)
            }
        }
    }

    func toBasketballTabbarViewController() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let basketballStorybard = UIStoryboard(name: Constant.Storyboard.basketball, bundle: nil)
            let basketballTabbarViewController = basketballStorybard.instantiateViewController(withIdentifier: Constant.Controller.basketballTabbar) as? BasketballTabbarViewController

            appDelegate.window?.rootViewController = basketballTabbarViewController
        }
    }

    func toChooseLevelViewController() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let chooseLevelStorybard = UIStoryboard(name: Constant.Storyboard.chooseLevel, bundle: nil)
            let chooseLevelViewController = chooseLevelStorybard.instantiateViewController(withIdentifier: Constant.Controller.chooseLevel) as? ChooseLevelViewController

            appDelegate.window?.rootViewController = chooseLevelViewController
        }
    }

    @IBAction func logout(_ sender: Any) {

        if Auth.auth().currentUser?.uid != nil {
            handleLogout()
        }
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
