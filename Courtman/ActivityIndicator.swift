//
//  ActivityIndicator.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import UIKit

class ActivityIndicator {

    let view: UIView?
    var activityIndicator: UIActivityIndicatorView?

    init(view: UIView) {
        self.view = view
    }

    private func createIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator?.style = UIActivityIndicatorView.Style.gray
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.center = (self.view?.center)!

        self.view?.addSubview(activityIndicator!)
    }

    func startIndicator() {

        if activityIndicator == nil {
            createIndicator()
        }

        activityIndicator?.startAnimating()
    }

    func stopIndicator() {

        if activityIndicator != nil {
            activityIndicator?.stopAnimating()
        }
    }

}
