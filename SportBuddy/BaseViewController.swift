//
//  BaseViewController.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/3/21.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit
import Firebase

class BaseViewController: UIViewController {

    let items = ["臺北市", "新北市", "基隆市", "桃園市", "新竹市", "新竹縣", "苗栗縣", "臺中市", "彰化縣", "南投縣", "雲林縣", "嘉義市", "嘉義縣", "臺南市", "高雄市", "屏東縣", "宜蘭縣", "花蓮縣", "臺東縣", "澎湖縣", "金門縣" ]

    @objc func backToSportMenuViewController() {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let sportMenuStorybard = UIStoryboard(name: Constant.Storyboard.sportsMenu, bundle: nil)
            let vc = sportMenuStorybard.instantiateViewController(withIdentifier: Constant.Controller.sportsMenu) as? SportsMenuViewController

            appDelegate.window?.rootViewController = vc
        }
    }

    func setBackground(imageName: String) {
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.image = UIImage(named: imageName)
        self.view.insertSubview(backgroundImage, at: 0)
    }
}

// MARK: - Hide Navigation Bar
extension BaseViewController {

    func transparentizeNavigationBar(navigationController: UINavigationController?) {

        let image = UIImage()
        navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = image
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
    }
}

// MARK: - Navigation Bar Back Button
extension BaseViewController {

    func createBackButton(action: Selector) -> UIBarButtonItem {

        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "Button_Home"),
                                     style: .done,
                                     target: self,
                                     action: action)

        return button
    }
}

// MARK: - Hide Keyboard When Tapped Around
extension BaseViewController {

    func hideKeyboardWhenTappedAround() {

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {

        view.endEditing(true)
    }
}

// MARK: - Show error alert
extension BaseViewController {

    func showErrorAlert(error: Error?, myErrorMsg: String?) {

        var errorMsg: String = ""

        if error != nil {
            errorMsg = (error?.localizedDescription)!
        } else if myErrorMsg != nil {
            errorMsg = myErrorMsg!
        }

        let alertController = UIAlertController(title: "訊息", message: errorMsg, preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
