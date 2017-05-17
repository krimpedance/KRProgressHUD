//
//  KRProgressHUD.swift
//  KRProgressHUD
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit
import KRActivityIndicatorView

/**
 Type of KRProgressHUD's background view.
 
 - **clear:** `UIColor.clear`.
 - **white:** `UIColor(white: 1, alpho: 0.2)`.
 - **black:** `UIColor(white: 0, alpho: 0.2)`. Default type.
 */
public enum KRProgressHUDMaskType {
   case clear, white, black

   var maskColor: UIColor {
      switch self {
      case .clear: return .clear
      case .white: return UIColor(white: 1, alpha: 0.2)
      case .black: return UIColor(white: 0, alpha: 0.2)
      }
   }
}

/**
 Style of KRProgressHUD.
 
 - **white:**          HUD's backgroundColor is `.white`. HUD's text color is `.black`. Default style.
 - **black:**           HUD's backgroundColor is `.black`. HUD's text color is `.white`.
 - **custom(background, text, icon):**  Set custom color of HUD's background, text and glyph icon.
                        If you set nil to `icon`, it's shown in original color.
 */
public enum KRProgressHUDStyle {
   case white
   case black
   case custom(background: UIColor, text: UIColor, icon: UIColor?)

   var backgroundColor: UIColor {
      switch self {
      case .white: return .white
      case .black: return .black
      case .custom(let background, _, _): return background
      }
   }

   var textColor: UIColor {
      switch self {
      case .white: return .black
      case .black: return .white
      case .custom(_, let text, _): return text
      }
   }

   var iconColor: UIColor? {
      switch self {
      case .custom(_, _, let icon): return icon
      default: return nil
      }
   }
}

/**
 *  KRProgressHUD is a beautiful and easy-to-use progress HUD.
 */
public final class KRProgressHUD {
   public typealias CompletionHandler = () -> Void

   public class KRProgressHUDAppearance {
      public var style = KRProgressHUDStyle.white
      public var maskType = KRProgressHUDMaskType.black
      public var activityIndicatorStyle = KRActivityIndicatorViewStyle.gradationColor(head: .black, tail: .lightGray)
      public var font = UIFont.systemFont(ofSize: 13)
      public var viewCenterPosition = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
      public var deadlineTime = Double(1.0)

      fileprivate init() {}
   }

   static let shared = KRProgressHUD()

   let viewAppearance = KRProgressHUDAppearance()

   let window = UIWindow(frame: UIScreen.main.bounds)
   let hudViewController = KRProgressHUDViewController()

   let hudView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
   let iconView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
   let activityIndicatorView = KRActivityIndicatorView(style: .gradationColor(head: .black, tail: .lightGray))
   let iconDrawingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
   let iconDrawingLayer = CAShapeLayer()
   let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))

   var style: KRProgressHUDStyle?
   var maskType: KRProgressHUDMaskType?
   var activityIndicatorStyle: KRActivityIndicatorViewStyle?
   var font: UIFont?
   var viewCenterPosition: CGPoint?
   var deadlineTime: Double?

   var dismissHandler: DispatchWorkItem?
   weak var appWindow: UIWindow?

   public static var isVisible: Bool {
      return shared.window.alpha == 0 ? false : true
   }

   private init() {
      configureProgressHUDView()
   }
}

/**
 *  KRProgressHUD Set styles --------------------------
 */
extension KRProgressHUD {
   public class func appearance() -> KRProgressHUDAppearance {
      return shared.viewAppearance
   }

   @discardableResult public class func set(style: KRProgressHUDStyle) -> KRProgressHUD.Type {
      shared.style = style
      return KRProgressHUD.self
   }

   @discardableResult public class func set(maskType: KRProgressHUDMaskType) -> KRProgressHUD.Type {
      shared.maskType = maskType
      return KRProgressHUD.self
   }

   @discardableResult public class func set(activityIndicatorViewStyle style: KRActivityIndicatorViewStyle) -> KRProgressHUD.Type {
      shared.activityIndicatorStyle = style
      return KRProgressHUD.self
   }

   @discardableResult public class func set(font: UIFont) -> KRProgressHUD.Type {
      shared.font = font
      return KRProgressHUD.self
   }

   @discardableResult public class func set(centerPosition point: CGPoint) -> KRProgressHUD.Type {
      shared.viewCenterPosition = point
      return KRProgressHUD.self
   }

   @discardableResult public class func set(deadlineTime time: Double) -> KRProgressHUD.Type {
      shared.deadlineTime = time
      return KRProgressHUD.self
   }

   @discardableResult public class func resetStyles() -> KRProgressHUD.Type {
      shared.style = nil
      shared.maskType = nil
      shared.activityIndicatorStyle = nil
      shared.font = nil
      shared.viewCenterPosition = nil
      shared.deadlineTime = nil
      return KRProgressHUD.self
   }
}

/**
 *  KRProgressHUD Show & Dismiss --------------------------
 */
extension KRProgressHUD {
   /**
    Shows the HUD.
    You can appoint only the args which You want to appoint.

    - parameter message:    HUD's message.
    - parameter completion: Show completion handler.
    */
   public class func show(withMessage message: String? = nil, completion: CompletionHandler? = nil) {
      shared.show(withMessage: message, isLoading: true, completion: completion)
   }

   /**
    Shows the HUD with success glyph.
    The HUD dismiss after 1 secound (Default).
    
    - parameter message: HUD's message
    - parameter completion: Hide completion handler.
    */
   public class func showSuccess(withMessage message: String? = nil) {
      shared.show(withMessage: message, iconType: .success)
   }

   /**
    Shows the HUD with information glyph.
    The HUD dismiss after 1 secound (Default).
    
    - parameter message: HUD's message
    - parameter completion: Hide completion handler.
    */
   public class func showInfo(withMessage message: String? = nil) {
      shared.show(withMessage: message, iconType: .info)
   }

   /**
    Shows the HUD with warning glyph.
    The HUD dismiss after 1 secound (Default).

    - parameter message: HUD's message
    - parameter completion: Hide completion handler.
    */
   public class func showWarning(withMessage message: String? = nil) {
      shared.show(withMessage: message, iconType: .warning)
   }

   /**
    Shows the HUD with error glyph.
    The HUD dismiss after 1 secound (Default).

    - parameter message: HUD's message
    - parameter completion: Hide completion handler.
    */
   public class func showError(withMessage message: String? = nil) {
      shared.show(withMessage: message, iconType: .error)
   }

   /**
    Shows the HUD with image.
    The HUD dismiss after 1 secound (Default).
    
    - parameter image:      Image that display instead of activity indicator
    - parameter message:    HUD's message
    - parameter completion: Hide completion handler.

    - returns: No return value.
    */
   public class func showImage(_ image: UIImage, message: String? = nil) {
      shared.show(withMessage: message, image: image)
   }

   /**
    Shows the HUD only for message.
    The HUD dismiss after 1 secound (Default).

    - parameter message: HUD's message.
    - parameter completion: Hide completion handler.
    */
   public class func showMessage(_ message: String) {
      shared.show(withMessage: message, onlyText: true)
   }

   /**
    Update message.

    - parameter message: String
    */
   public class func update(message: String) {
      shared.messageLabel.text = message
   }

   /**
    Hides the HUD.

    - parameter completion: Hide completion handler.
    */
   public class func dismiss(_ completion: CompletionHandler? = nil) {
      shared.dismiss(completion: completion)
   }
}
