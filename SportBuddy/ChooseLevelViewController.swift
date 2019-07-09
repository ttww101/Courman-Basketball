//
//  ChooseLevelViewController.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/3/23.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit
import Firebase

class ChooseLevelViewController: BaseViewController {

    @IBOutlet weak var introductionView: UIView!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var introductionButton: UIButton!
    @IBOutlet weak var fakeButton: UIButton!

    private var level = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
    }

    @IBAction func selectLevelA(_ sender: Any) {
        saveLevel(level: "A")
        toMainPage()
    }

    @IBAction func selectLevelB(_ sender: Any) {
        saveLevel(level: "B")
        toMainPage()
    }

    @IBAction func selectLevelC(_ sender: Any) {
        saveLevel(level: "C")
        toMainPage()
    }

    @IBAction func selectLevelD(_ sender: Any) {
        saveLevel(level: "D")
        toMainPage()
    }

    @IBAction func selectLevelE(_ sender: Any) {
        saveLevel(level: "E")
        toMainPage()
    }

    func setView() {

        setBackground(imageName: Constant.BackgroundName.basketball)

        introductionLabel.text = "請選擇您在這項運動所自認的等級, 以便之後尋找差不多等級的球友\n\n範例: 球齡大概兩年, 但技巧還算拙劣, 那可以考慮選擇從D這等級起步"

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideIntroduction))
        introductionView.addGestureRecognizer(tap)

        fakeButton.addTarget(self, action: #selector(hideIntroduction), for: .touchUpInside)

        introductionButton.addTarget(self, action: #selector(showIntroduction), for: .touchUpInside)
    }

    @objc func hideIntroduction() {

        introductionView.isHidden = true
        introductionLabel.isHidden = true
        fakeButton.isHidden = true
    }

    @objc func showIntroduction() {

        introductionView.isHidden = false
        introductionLabel.isHidden = false
        fakeButton.isHidden = false
    }

    func saveLevel(level: String) {

        guard
            let uid = Auth.auth().currentUser?.uid
            else { return }

        let values = [Constant.FirebaseLevel.basketball: level]

        LevelManager.shared.updateUserLevel(currentUserUID: uid, values: values) { (error) in
            if error != nil {
                print("=== Error: \(String(describing: error))")
            }
        }
    }

    func toMainPage() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let basketballStorybard = UIStoryboard(name: Constant.Storyboard.basketball, bundle: nil)
            let basketballTabbarViewController = basketballStorybard.instantiateViewController(withIdentifier: Constant.Controller.basketballTabbar) as? BasketballTabbarViewController

            appDelegate.window?.rootViewController = basketballTabbarViewController
        }
    }

}
