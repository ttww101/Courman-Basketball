//
//  LoginViewController.swift
//  Courtman
//
//  Created by steven.chou on 2017/3/20.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import Crashlytics
import SkyFloatingLabelTextField

class LoginViewController: BaseViewController {

    @IBOutlet weak var emailTexfield: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var logoImageView: UIImageView!

    let loadingIndicator = LoadingIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()

        setView()
        self.logoImageView.layer.masksToBounds = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        loadingIndicator.stop()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.logoImageView.layer.cornerRadius = self.logoImageView.frame.width/4
    }

    // todo: confirm use it or not.
    func isUsersignedin() {

        Auth.auth().addStateDidChangeListener { _, user in
            if user != nil {
                // User is signed in.
                print("=== User is signed in ===")
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    let sportMenuStorybard = UIStoryboard(name: Constant.Storyboard.sportsMenu, bundle: nil)
                    let vc = sportMenuStorybard.instantiateViewController(withIdentifier: Constant.Controller.sportsMenu) as? SportsMenuViewController

                    appDelegate.window?.rootViewController = vc
                }
            } else {
                // No user is signed in.
                print("=== No user sign in ===")
            }
        }
    }

    func setCrashlyticsButton() {
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }

    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }

    func setView() {
        setBackground(imageName: Constant.BackgroundName.login)
    }

    @IBAction func login(_ sender: Any) {

        let email = emailTexfield.text!
        let password = passwordTextfield.text!

        // MARK: Loading indicator
        loadingIndicator.start()

        Auth.auth().signIn(withEmail: email, password: password, completion: { (_, error) in

            if error != nil {
                self.loadingIndicator.stop()
                self.showErrorAlert(error: error, myErrorMsg: nil)
                return
            }

            // successfully login
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

                let sportMenuStorybard = UIStoryboard(name: Constant.Storyboard.sportsMenu, bundle: nil)
                let vc = sportMenuStorybard.instantiateViewController(withIdentifier: Constant.Controller.sportsMenu) as? SportsMenuViewController

                appDelegate.window?.rootViewController = vc
            }
        })
    }

    @IBAction func signUp(_ sender: Any) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let signUpStorybard = UIStoryboard(name: Constant.Storyboard.signUp, bundle: nil)
            let signUpViewController = signUpStorybard.instantiateViewController(withIdentifier: Constant.Controller.signUp) as? SignUpViewController

            appDelegate.window?.rootViewController = signUpViewController
        }
    }

    @IBAction func forgetPassword(_ sender: Any) {

        if emailTexfield.text == "" {

            self.showAlert(myMsg: "請在Email欄位中填寫您所註冊的Email\n填完後點選忘記密碼\n我們將會寄一封重設密碼信件給您")

        } else {

            let ref = Auth.auth()

            ref.sendPasswordReset(withEmail: emailTexfield.text!, completion: { (error) in

                if error != nil {
                    self.showAlert(myMsg: "這Email似乎還沒註冊\n請再次確認您所填寫的Email是否正確")
                } else {
                    self.showAlert(myMsg: "我們已發了一封信件到您的信箱\n請使用裡頭的連結來重設您的密碼")
                }
            })
        }
    }

    /*
     *  For testing
     */
    @IBAction func testLogin(_ sender: Any) {

        // MARK: Loading indicator
        loadingIndicator.start()

        Auth.auth().signIn(withEmail: "steven@gmail.com", password: "aaaaaa", completion: { (_, error) in

            if error != nil {
                self.loadingIndicator.stop()
                self.showErrorAlert(error: error, myErrorMsg: nil)
                return
            }

            // successfully login
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

                let sportMenuStorybard = UIStoryboard(name: Constant.Storyboard.sportsMenu, bundle: nil)
                let vc = sportMenuStorybard.instantiateViewController(withIdentifier: Constant.Controller.sportsMenu) as? SportsMenuViewController

                appDelegate.window?.rootViewController = vc
            }
        })
    }

    func showAlert(myMsg: String?) {

        let alertController = UIAlertController(title: "通知",
                                                message: myMsg,
                                                preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
