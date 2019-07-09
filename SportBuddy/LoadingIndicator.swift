//
//  LoadingIndicator.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/4/17.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class LoadingIndicator {

    var activityData: ActivityData?

    init() {
        activityData = ActivityData()
    }

    func start() {
        if activityData == nil {
            activityData = ActivityData()
        }
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData!, nil)
    }

    func stop() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
}
