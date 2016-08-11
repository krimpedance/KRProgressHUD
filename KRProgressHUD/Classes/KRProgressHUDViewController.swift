//
//  KRProgressHUDViewController.swift
//  KRProgressHUD
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit

class KRProgressHUDViewController: UIViewController {
    var statusBarHidden = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
    }

    override var prefersStatusBarHidden: Bool {
        get {
            guard let vc = UIApplication.topViewController() else { return statusBarHidden }
            if !vc.isKind(of: KRProgressHUDViewController.self) {
                statusBarHidden = vc.prefersStatusBarHidden
            }
            return statusBarHidden
        }
    }
}
