//
//  BasketballTabbarViewController.swift
//  Courtman
//
//  Created by steven.chou on 2017/3/23.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit

class BasketballTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBarControllerItems = tabBar.items

        tabBarControllerItems?[0].image = #imageLiteral(resourceName: "Tabber_Basketball")
        tabBarControllerItems?[0].badgeColor = UIColor.orange
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(red: 255/255, green: 126/255, blue: 121/255, alpha: 1.0)], for: .selected)
        
        
        
        tabBarControllerItems?[1].image = #imageLiteral(resourceName: "Tabber_Basketball_Court")
        
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.isTranslucent = true
//        self.tabBar.tintColor = .clear

    }

}
