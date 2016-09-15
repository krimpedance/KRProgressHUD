//
//  KRProgressHUDExtensions.swift
//  KRProgressHUD
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit

/**
 *  UIApplication -----------
 */
extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
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

extension Thread {
    static func afterDelay(_ delayTime: Double, completion: @escaping () -> Void) {
        let when = DispatchTime.now() + delayTime
        DispatchQueue.global().asyncAfter(deadline: when, execute: completion)
    }
}
