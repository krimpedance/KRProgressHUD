//
//  KRProgressHUDViewController.swift
//  KRProgressHUD
//
//  Copyright © 2016 Krimpedance. All rights reserved.
//

import UIKit

class KRProgressHUDViewController: UIViewController {
    var statusBarStyle = UIStatusBarStyle.default
    var statusBarHidden = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let vc = UIApplication.shared.topViewController() else { return statusBarStyle }
        if !vc.isKind(of: KRProgressHUDViewController.self) {
            statusBarStyle = vc.preferredStatusBarStyle
        }
        return statusBarStyle
    }

    override var prefersStatusBarHidden: Bool {
        guard let vc = UIApplication.shared.topViewController() else { return statusBarHidden }
        if !vc.isKind(of: KRProgressHUDViewController.self) {
            statusBarHidden = vc.prefersStatusBarHidden
        }
        return statusBarHidden
    }
}
