//
//  KRProgressHUDViewController.swift
//  KRProgressHUD
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit

class KRProgressHUDViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
    }

    override func prefersStatusBarHidden() -> Bool {
        guard let vc = UIApplication.topViewController() else { return false }
        return vc.prefersStatusBarHidden()
    }
}