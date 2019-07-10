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
import FSPagerView

class SportsMenuViewController: BaseViewController, FSPagerViewDelegate, FSPagerViewDataSource {

    //Menu Pager
    let menuImages:[UIImage?] = [UIImage(named: "Item_Basketball"),
                                  UIImage(named: "Item_Baseball"),
                                  UIImage(named: "Item_Jog")]
    
    let menuNames:[String] = ["籃球","棒球","足球"]
    private let pagerCellIdentifier = "FSMenuCell"
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: pagerCellIdentifier)
        }
    }
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!

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
        pagerView.transformer =  FSPagerViewTransformer(type: .overlap)
        let screenSize = UIScreen.main.bounds.size
        pagerView.itemSize = CGSize(width: screenSize.width*7/9, height: screenSize.height*7/9)
        
        setBackground(imageName: Constant.BackgroundName.basketball)
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
        content.sound = UNNotificationSound.default

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
                
                UserManager.shared.getUserProfileImage(from: user!.photoURL, completion: { (image, error) in
                    self.userImage.image = image
                })
                
//                self.loadImage(imageUrlString: user!.photoURL, imageView: )
            }

            if error != nil {
                self.errorHandle(errString: "Can't find the data", error: nil)
            }
        }
    }

    @IBAction func toEditProfile(_ sender: Any) {

        let editProfileStorybard = UIStoryboard(name: Constant.Storyboard.editProfile, bundle: nil)
        let editProfileViewController = editProfileStorybard.instantiateViewController(withIdentifier: Constant.Controller.editProfile) as? EditProfileViewController

        self.present(editProfileViewController!, animated: true, completion: {
            editProfileViewController?.userImage.image = self.userImage.image
            editProfileViewController?.nameTextField.text = self.userName.text
        })
    }

    func goBasketball() {

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

//MARK: Pager View Delegate
extension SportsMenuViewController {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return menuImages.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: pagerCellIdentifier, at: index)
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.image = self.menuImages[index]
        cell.textLabel?.textAlignment = .center
//        cell.textLabel?.text = self.menuNames[index]
        cell.textLabel?.backgroundColor = .clear
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        
//        if targetIndex > 2 {
//            self.pageControl.currentPage = targetIndex - 3
//        } else {
//            self.pageControl.currentPage = targetIndex + 2
//        }
    }
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if (index == 0) {
            goBasketball()
        }
    }
}
