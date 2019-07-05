//
//  BasketballTabbarViewController.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/3/23.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit

class BasketballTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor? = .clear
        tabBar.backgroundImage = UIImage()
        tabBar.isTranslucent = true

        let tabBarControllerItems = tabBar.items

        tabBarControllerItems?[0].image = #imageLiteral(resourceName: "Tabber_Basketball")
        tabBarControllerItems?[1].image = #imageLiteral(resourceName: "Tabber_Basketball_Court")
        tabBarControllerItems?[2].image = #imageLiteral(resourceName: "Tabber_Basketball_Player")

    }

}
