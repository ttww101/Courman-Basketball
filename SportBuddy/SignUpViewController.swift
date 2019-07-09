//
//  SignUpViewController.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/3/21.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit
import Firebase
import DKImagePickerController
import NVActivityIndicatorView

class SignUpViewController: BaseViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderLabel: UILabel!

    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!

    private var maleRadioButton = LTHRadioButton()
    private var femaleRadioButton = LTHRadioButton()

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

        emailTextField.placeholder = "Emall address"
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.delegate = self

        passwordTextField.placeholder = "Password"
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.delegate = self

        nameTextField.placeholder = "It will be displaied in app"
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.autocorrectionType = .no
        nameTextField.delegate = self

        // Male Radio Button
        maleRadioButton = LTHRadioButton(selectedColor: .blue)
        view.addSubview(maleRadioButton)
        maleRadioButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            maleRadioButton.centerYAnchor.constraint(equalTo: maleButton.centerYAnchor),
            maleRadioButton.trailingAnchor.constraint(equalTo: maleButton.leadingAnchor, constant: -10),
            maleRadioButton.heightAnchor.constraint(equalToConstant: maleRadioButton.frame.height),
            maleRadioButton.widthAnchor.constraint(equalToConstant: maleRadioButton.frame.width)])

        // todo: 為了先上架，所以把Gender藏起來，之後再打開
        maleRadioButton.isHidden = true
        maleButton.isHidden = true

        // Female Radio Button
        femaleRadioButton = LTHRadioButton(selectedColor: .blue)
        view.addSubview(femaleRadioButton)
        femaleRadioButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            femaleRadioButton.centerYAnchor.constraint(equalTo: femaleButton.centerYAnchor),
            femaleRadioButton.trailingAnchor.constraint(equalTo: femaleButton.leadingAnchor, constant: -10),
            femaleRadioButton.heightAnchor.constraint(equalToConstant: femaleRadioButton.frame.height),
            femaleRadioButton.widthAnchor.constraint(equalToConstant: femaleRadioButton.frame.width)])

        // todo: 為了先上架，所以把Gender藏起來，之後再打開
        femaleRadioButton.isHidden = true
        femaleButton.isHidden = true
        genderLabel.isHidden = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: - Select Picture
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard
            let tappedImage = tapGestureRecognizer.view as? UIImageView
            else { return }

        let pickerController = DKImagePickerController()

        pickerController.singleSelect = true
        pickerController.assetType = .allPhotos

        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            if assets.count != 0 {
//                assets[0].fetchOriginalImageWithCompleteBlock({ (image, _) in
//                    tappedImage.image = image
//                })
            }
        }

        self.present(pickerController, animated: true) {}
    }

    // MARK: - Select Gender
    @IBAction func clickMaleButton(_ sender: Any) {

        selectGender(select: maleRadioButton,
                     deselect: femaleRadioButton,
                     isMale: true)
    }

    @IBAction func clickFemaleButton(_ sender: Any) {

        selectGender(select: femaleRadioButton,
                     deselect: maleRadioButton,
                     isMale: false)
    }

    func selectGender(select selectGenderButton: LTHRadioButton,
                      deselect deselectGenderButton: LTHRadioButton,
                      isMale: Bool) {

        selectGenderButton.select()
        deselectGenderButton.deselect(animated: false)

        if isMale {
            userGender = Constant.Gender.male

        } else {
            userGender = Constant.Gender.female
        }
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

                guard let uid = user?.user.providerID else { return }

                let storageRef = Storage.storage().reference()
                    .child(Constant.FirebaseStorage.userPhoto)
                    .child(Constant.FirebaseStorage.userPhoto + "_" + uid)

                guard
                    let uploadData = UIImageJPEGRepresentation(self.userImage.image!, 0.3)
                    else { return }

                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in

                    if error != nil {
                        self.loadingIndicator.stop()
                        self.showErrorAlert(error: error, myErrorMsg: nil)
                        return
                    }

                    let userPhotoURL = metadata?.path

                    let userInfo = User(email: email, name: name, gender: gender,
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

    func testsetvalue() {
        let dbUrl = Constant.Firebase.dbUrl
        
//        let ref = Database.database().reference()
        let ref = Database.database().reference(fromURL: dbUrl)
        let usersReference = ref.child(Constant.FirebaseUser.nodeName)
        ref.child("users").child("3TdFL5Dm4MTQOO0yvY34t2qZTq73").setValue(["username": "username"])
        
        usersReference.setValue(["username": "username"]) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    func setValueToFirebase(uid: String, userInfo: User) {

        let dbUrl = Constant.Firebase.dbUrl
        let ref = Database.database().reference(fromURL: dbUrl)
        let usersReference = ref.child(Constant.FirebaseUser.nodeName).child(uid)

        let value: [String : Any] = [Constant.FirebaseUser.email: userInfo.email,
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
                let sportItemsStorybard = UIStoryboard(name: Constant.Storyboard.sportItems, bundle: nil)
                let sportItemsViewController = sportItemsStorybard.instantiateViewController(withIdentifier: Constant.Controller.sportItems) as? SportItemsViewController

                appDelegate.window?.rootViewController = sportItemsViewController
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
