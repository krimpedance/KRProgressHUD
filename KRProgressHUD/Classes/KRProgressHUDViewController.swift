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

// MARK: - UIApplication extension ------------

fileprivate extension UIApplication {
   func topViewController(_ base: UIViewController? = nil) -> UIViewController? {
      let base = base ?? keyWindow?.rootViewController
      if let nav = base as? UINavigationController {
         return topViewController(nav.visibleViewController)
      }
      if let tab = base as? UITabBarController {
         guard let selected = tab.selectedViewController else { return base }
         return topViewController(selected)
      }
      if let presented = base?.presentedViewController {
         return topViewController(presented)
      }
      return base
   }
}
