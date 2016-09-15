//
//  KRProgressHUDViewController.swift
//  KRProgressHUD
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit

class KRProgressHUDViewController: UIViewController {
    var statusBarStyle = UIStatusBarStyle.default
    var statusBarHidden = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let vc = UIApplication.topViewController() else { return statusBarStyle }
        if !vc.isKind(of: KRProgressHUDViewController.self) {
            statusBarStyle = vc.preferredStatusBarStyle
        }
        return statusBarStyle
    }

    override var prefersStatusBarHidden: Bool {
        guard let vc = UIApplication.topViewController() else { return statusBarHidden }
        if !vc.isKind(of: KRProgressHUDViewController.self) {
            statusBarHidden = vc.prefersStatusBarHidden
        }
        return statusBarHidden
    }
}
