//
//  SignUpViewController.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/3/21.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import YPImagePicker

class SignUpViewController: BaseViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!

    let loadingIndicator = LoadingIndicator()

    private var userGender = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()

        setView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        userImage.layer.cornerRadius = userImage.bounds.size.height / 2.0
        userImage.layer.borderWidth = 1.0
        userImage.layer.masksToBounds = true
    }

    func setView() {

        setBackground(imageName: Constant.BackgroundName.login)

        emailTextField.clearButtonMode = .whileEditing
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.delegate = self

        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.autocorrectionType = .no
        passwordTextField.delegate = self
        
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.autocorrectionType = .no
        nameTextField.delegate = self

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: - Select Picture
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.presentImagePicker()
    }

    // MARK: - Sign up
    @IBAction func signUp(_ sender: Any) {
//        testsetvalue()
        // todo: 為了先上架，所以把Gender藏起來，之後再打開
        userGender = "Default"

        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        let name = self.nameTextField.text!
        let gender = self.userGender

        if email != "" && password != "" && name != "" && userGender != "" {

            // MARK: Start loading indicator
            loadingIndicator.start()

            // MARK: Save user info to firebase
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in

                if error != nil {
                    self.loadingIndicator.stop()
                    self.showErrorAlert(error: error, myErrorMsg: nil)
                    return
                }

                guard let currentUser = Auth.auth().currentUser else { return }

                let uid = currentUser.uid
                
                let storageRef = Storage.storage().reference()
                    .child(Constant.FirebaseStorage.userPhoto)
                    .child(Constant.FirebaseStorage.userPhoto + "_" + uid)

                guard
                    let uploadData = self.userImage.image!.jpegData(compressionQuality: 0.3)
                    else { return }

                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in

                    if error != nil {
                        self.loadingIndicator.stop()
                        self.showErrorAlert(error: error, myErrorMsg: nil)
                        return
                    }

                    let userPhotoURL = metadata?.path

                    let userInfo = User(userID:uid, email: email, name: name, gender: gender,
                                    photoURL: userPhotoURL ?? "", lastTimePlayedGame: "",
                                    playedGamesCount: 0)

                    self.setValueToFirebase(uid: uid, userInfo: userInfo)
                })
            }

        } else {
            self.loadingIndicator.stop()
            self.showErrorAlert(error: nil, myErrorMsg: "請確認您已填完所有欄位")
        }
    }

    func setValueToFirebase(uid: String, userInfo: User) {

        let dbUrl = Constant.Firebase.dbUrl
        let ref = Database.database().reference(fromURL: dbUrl)
        let usersReference = ref.child(Constant.FirebaseUser.nodeName).child(uid)

        let value: [String : Any] = [
            Constant.FirebaseUser.userID: userInfo.userID,
            Constant.FirebaseUser.email: userInfo.email,
                     Constant.FirebaseUser.name: userInfo.name,
                     Constant.FirebaseUser.gender: userInfo.gender,
                     Constant.FirebaseUser.photoURL: userInfo.photoURL,
                     Constant.FirebaseUser.lastTimePlayedGame: userInfo.lastTimePlayedGame,
                     Constant.FirebaseUser.playedGamesCount: userInfo.playedGamesCount]

        usersReference.updateChildValues(value, withCompletionBlock: { (err, _) in

            if err != nil {
                self.loadingIndicator.stop()
                self.showErrorAlert(error: err, myErrorMsg: nil)
                return
            }

            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let sportMenuStorybard = UIStoryboard(name: Constant.Storyboard.sportsMenu, bundle: nil)
                let vc = sportMenuStorybard.instantiateViewController(withIdentifier: Constant.Controller.sportsMenu) as? SportsMenuViewController

                appDelegate.window?.rootViewController = vc
            }

            self.loadingIndicator.stop()
        })
    }

    /*
     *  For testing
     */
    @IBAction func toLogin(_ sender: Any) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let loginStorybard = UIStoryboard(name: Constant.Storyboard.login, bundle: nil)
            let loginViewController = loginStorybard.instantiateViewController(withIdentifier: Constant.Controller.login) as? LoginViewController

            appDelegate.window?.rootViewController = loginViewController
        }
    }

}

// MARK: - Hide keyboard when user clicks the return on keyboard
extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.view.endEditing(true)
        return true
    }
}

extension SignUpViewController {
    
    func presentImagePicker() {
        var config = YPImagePickerConfiguration()
        config.wordings.libraryTitle = "Gallery"
        config.wordings.cameraTitle = "Camera"
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = true
        config.showsPhotoFilters = true
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "CourtsMan"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.photo,.library]
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.bottomMenuItemSelectedColour = UIColor.hexColor(with: "dd7663")
        config.bottomMenuItemUnSelectedColour = UIColor.hexColor(with: "454545")
        
        config.library.options = nil
        config.library.onlySquare = false
        config.library.minWidthForItem = nil
        config.library.mediaType = YPlibraryMediaType.photo
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = false
        
        //navigation bar
        let attributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 22, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes // Title fonts
        
        UINavigationBar.appearance().tintColor = .white // Left. bar buttons
        config.colors.tintColor = .white // Right bar buttons (actions)
        
        //bar background
        let coloredImage = UIColor.hexColor(with: "454545").image()
        UINavigationBar.appearance().setBackgroundImage(coloredImage, for: UIBarMetrics.default)
        
        
        let barButtonAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .regular)]
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, for: .normal) // Bar Button fonts
        
        UITabBar.appearance().backgroundColor = UIColor.hexColor(with: "454545")
        
        YPImagePickerConfiguration.shared = config
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            
            if let photo = items.singlePhoto {
                self.userImage.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
            
        }
        present(picker, animated: true, completion: nil)
    }
    
}
