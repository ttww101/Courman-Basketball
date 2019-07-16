//
//  LoadingIndicator.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class LoadingIndicator {

    var activityData: ActivityData?

    init() {
        activityData = ActivityData(type:.ballClipRotatePulse)
        
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
