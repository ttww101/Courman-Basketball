//
//  ChooseLevelViewController.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/3/23.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit
import Firebase
import FSPagerView

class ChooseLevelViewController: BaseViewController, FSPagerViewDelegate, FSPagerViewDataSource {
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSLevelCell")
        }
    }
    @IBOutlet weak var pageControl:FSPageControl!
    @IBOutlet weak var introductionView: UIView!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var introductionButton: UIButton!

    let levelImages:[UIImage?] = [UIImage(named: "Level_S"),
                                  UIImage(named: "Level_A"),
                                  UIImage(named: "Level_B"),
                                  UIImage(named: "Level_C"),
                                  UIImage(named: "Level_D"),
                                  UIImage(named: "Level_E"),
                                  UIImage(named: "Level_F"),]
    
    let levelNames:[String] = [ "''MVP''","誰能攔得住我","精通各種招數","叫我球員","有玩","菜鳥","我是來觀賽的"]
    let levelModel:[String] = ["S","A","B","C","D","E","F"]
    
    private var level = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
    }
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return levelImages.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSLevelCell", at: index)
        cell.imageView?.contentMode = .scaleAspectFit
        cell.textLabel?.textAlignment = .center
        cell.imageView?.image = self.levelImages[index]
        cell.textLabel?.text = self.levelNames[index]
        cell.textLabel?.superview?.isHidden = false
        return cell
    }

    func setView() {
        pagerView.transformer =  FSPagerViewTransformer(type: .overlap)
        pageControl.numberOfPages = self.levelImages.count
        pageControl.currentPage = 2
        pageControl.contentHorizontalAlignment = .center
        pageControl.setStrokeColor(.white, for: .normal)
        pageControl.setStrokeColor(.yellow, for: .selected)
        pageControl.setFillColor(.white, for: .normal)
        pageControl.setFillColor(.red, for: .selected)

        setBackground(imageName: Constant.BackgroundName.basketball)

        introductionLabel.text = "請選擇您今日配對等級"

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideIntroduction))
        introductionView.addGestureRecognizer(tap)
        introductionButton.addTarget(self, action: #selector(showIntroduction), for: .touchUpInside)
        self.hideIntroduction()
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
}

//MARK: Pager View Delegate
extension ChooseLevelViewController {
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        if targetIndex > 2 {
            self.pageControl.currentPage = targetIndex - 3
        } else {
            self.pageControl.currentPage = targetIndex + 2
        }
    }
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        saveLevel(level: levelModel[index])
        toBasketballTabbarViewController()
    }
    
    @IBAction func okButtonDidTouchUpInside() {
        saveLevel(level: levelModel[self.pagerView.currentIndex])
        toBasketballTabbarViewController()
    }
}

//MARK: Private
extension ChooseLevelViewController {
    @objc func hideIntroduction() {
        introductionView.isHidden = true
        introductionLabel.isHidden = true
    }
    
    @objc func showIntroduction() {
        introductionView.isHidden = false
        introductionLabel.isHidden = false
    }
    
    func toBasketballTabbarViewController() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            let basketballStorybard = UIStoryboard(name: Constant.Storyboard.basketball, bundle: nil)
            let basketballTabbarViewController = basketballStorybard.instantiateViewController(withIdentifier: Constant.Controller.basketballTabbar) as? BasketballTabbarViewController
            
            appDelegate.window?.rootViewController = basketballTabbarViewController
        }
    }

}
