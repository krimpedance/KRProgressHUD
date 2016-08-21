//
//  KRProgressHUDViewController.swift
//  KRProgressHUD
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit

class KRProgressHUDViewController: UIViewController {
    var statusBarStyle = UIStatusBarStyle.Default
    var statusBarHidden = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        guard let vc = UIApplication.topViewController() else { return statusBarStyle }
        if !vc.isKindOfClass(KRProgressHUDViewController) {
            statusBarStyle = vc.preferredStatusBarStyle()
        }
        return statusBarStyle
    }

    override func prefersStatusBarHidden() -> Bool {
        guard let vc = UIApplication.topViewController() else { return statusBarHidden }
        if !vc.isKindOfClass(KRProgressHUDViewController) {
            statusBarHidden = vc.prefersStatusBarHidden()
        }
        return statusBarHidden
    }
}
