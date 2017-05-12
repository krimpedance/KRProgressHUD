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
   public class KRProgressHUDAppearance {
      public var style = KRProgressHUDStyle.white
      public var maskType = KRProgressHUDMaskType.black
      public var activityIndicatorStyle = KRActivityIndicatorViewStyle.gradationColor(head: .black, tail: .lightGray)
      public var font = UIFont.systemFont(ofSize: 13)
      public var viewCenterPosition = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)

      fileprivate init() {}
   }

   fileprivate static let shared = KRProgressHUD()
   fileprivate let viewAppearance = KRProgressHUDAppearance()

   fileprivate var appWindow: UIWindow?
   fileprivate let window = UIWindow(frame: UIScreen.main.bounds)
   fileprivate let hudViewController = KRProgressHUDViewController()

   fileprivate let hudView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
   fileprivate let iconView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
   fileprivate let activityIndicatorView = KRActivityIndicatorView(style: .gradationColor(head: .black, tail: .lightGray))
   fileprivate let iconDrawingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
   fileprivate let iconDrawingLayer = CAShapeLayer()
   fileprivate let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))

   fileprivate var style: KRProgressHUDStyle?
   fileprivate var maskType: KRProgressHUDMaskType?
   fileprivate var activityIndicatorStyle: KRActivityIndicatorViewStyle?
   fileprivate var font: UIFont?
   fileprivate var viewCenterPosition: CGPoint?

   public static var isVisible: Bool {
      return shared.window.alpha == 0 ? false : true
   }

   private init() {
      configureProgressHUDView()
   }
}

/**
 *  Private Actions --------------------------
 */
fileprivate extension KRProgressHUD {
   func configureProgressHUDView() {
      window.windowLevel = UIWindowLevelNormal
      window.alpha = 0

      hudView.backgroundColor = .white
      hudView.layer.cornerRadius = 10
      hudView.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin]

      iconView.backgroundColor = .clear
      iconView.center = CGPoint(x: 50, y: 50)

      activityIndicatorView.isLarge = true
      activityIndicatorView.hidesWhenStopped = true
      activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)

      iconDrawingView.backgroundColor = .clear
      iconDrawingView.isHidden = true

      iconDrawingLayer.frame = iconDrawingView.layer.bounds
      iconDrawingLayer.lineWidth = 0
      iconDrawingLayer.fillColor = nil

      messageLabel.center = CGPoint(x: 150/2, y: 90)
      messageLabel.backgroundColor = .clear
      messageLabel.textAlignment = .center
      messageLabel.adjustsFontSizeToFitWidth = true
      messageLabel.minimumScaleFactor = 0.5
      messageLabel.text = nil
      messageLabel.isHidden = true

      iconView.addSubview(iconDrawingView)
      iconView.addSubview(activityIndicatorView)
      hudView.addSubview(iconView)
      hudView.addSubview(messageLabel)
      hudViewController.view.addSubview(hudView)
      window.rootViewController = hudViewController

      applyStyles()
   }

   func show(_ completion: (() -> Void)? = nil) {
      DispatchQueue.main.async { () -> Void in
         self.appWindow = UIApplication.shared.keyWindow
         self.window.alpha = 0
         self.window.makeKeyAndVisible()

         UIView.animate(withDuration: 0.5, animations: {
            self.window.alpha = 1
         }, completion: { _ in
            completion?()
         })
      }
   }
}

/**
 *  KRProgressHUD Set styles --------------------------
 */
extension KRProgressHUD {
   public class func appearance() -> KRProgressHUDAppearance {
      return shared.viewAppearance
   }

   public class func resetStyles() {
      shared.style = nil
      shared.maskType = nil
      shared.activityIndicatorStyle = nil
      shared.font = nil
      shared.viewCenterPosition = nil
   }

   @discardableResult public class func set(style: KRProgressHUDStyle) -> KRProgressHUD.Type {
      shared.hudView.backgroundColor = style.backgroundColor
      shared.messageLabel.textColor = style.textColor
      shared.iconDrawingLayer.fillColor = style.iconColor?.cgColor
      return KRProgressHUD.self
   }

   @discardableResult public class func set(maskType: KRProgressHUDMaskType) -> KRProgressHUD.Type {
      shared.hudViewController.view.backgroundColor = maskType.maskColor
      return KRProgressHUD.self
   }

   @discardableResult public class func set(activityIndicatorViewStyle style: KRActivityIndicatorViewStyle) -> KRProgressHUD.Type {
      shared.activityIndicatorView.style = style
      return KRProgressHUD.self
   }

   @discardableResult public class func set(font: UIFont) -> KRProgressHUD.Type {
      shared.messageLabel.font = font
      return KRProgressHUD.self
   }

   @discardableResult public class func set(centerPosition point: CGPoint) -> KRProgressHUD.Type {
      shared.hudView.center = point
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
    - parameter completion: Completion handler.
    */
   public class func show(withMessage message: String? = nil, completion: (() -> Void)? = nil) {
      shared.applyStyles()
      shared.updateProgressHUDViewMessage(message)
      shared.updateProgressHUDViewIcon()
      shared.show { completion?() }
   }

   /**
    Shows the HUD with image.
    The HUD dismiss after 1 secound (Default).
    
    - parameter image:      Image that display instead of activity indicator
    - parameter message:    HUD's message
    - parameter completion: Completion handler.

    - returns: No return value.
    */
   public class func showImage(_ image: UIImage, message: String? = nil) {
      shared.applyStyles()
      shared.updateProgressHUDViewMessage(message)
      shared.updateProgressHUDViewIcon(image: image)
      shared.show()
      DispatchQueue.afterDelay(1.0) {
        	KRProgressHUD.dismiss()
      }
   }

   /**
    Shows the HUD only for message.
    The HUD dismiss after 1 secound (Default).

    - parameter message: HUD's message.
    */
   public class func showMessage(_ message: String) {
      shared.applyStyles()
      shared.updateProgressHUDViewMessage(message, onlyText: true)
      shared.updateProgressHUDViewIcon(onlyText: true)
      shared.show()
      DispatchQueue.afterDelay(1.0) {
        	KRProgressHUD.dismiss()
      }
   }

   /**
    Shows the HUD with success glyph.
    The HUD dismiss after 1 secound (Default).
    
    - parameter message: HUD's message
    */
   public class func showSuccess(withMessage message: String? = nil) {
      shared.applyStyles()
      shared.updateProgressHUDViewMessage(message)
      shared.updateProgressHUDViewIcon(iconType: .success)
      shared.show()
      DispatchQueue.afterDelay(1.0) {
        	KRProgressHUD.dismiss()
      }
   }

   /**
    Shows the HUD with information glyph.
    The HUD dismiss after 1 secound (Default).
    
    - parameter message: HUD's message
    */
   public class func showInfo(withMessage message: String? = nil) {
      shared.applyStyles()
      shared.updateProgressHUDViewMessage(message)
      shared.updateProgressHUDViewIcon(iconType: .info)
      shared.show()

      DispatchQueue.afterDelay(1.0) {
        	KRProgressHUD.dismiss()
      }
   }

   /**
    Shows the HUD with warning glyph.
    The HUD dismiss after 1 secound (Default).

    - parameter message: HUD's message
    */
   public class func showWarning(withMessage message: String? = nil) {
      shared.applyStyles()
      shared.updateProgressHUDViewMessage(message)
      shared.updateProgressHUDViewIcon(iconType: .warning)
      shared.show()

      DispatchQueue.afterDelay(1.0) {
        	KRProgressHUD.dismiss()
      }
   }

   /**
    Shows the HUD with error glyph.
    The HUD dismiss after 1 secound (Default).

    - parameter message: HUD's message
    */
   public class func showError(withMessage message: String? = nil) {
      shared.applyStyles()
      shared.updateProgressHUDViewMessage(message)
      shared.updateProgressHUDViewIcon(iconType: .error)
      shared.show()

      DispatchQueue.afterDelay(1.0) {
        	KRProgressHUD.dismiss()
      }
   }

   /**
    Hides the HUD.

    - parameter completion: handler when dismissed.

    - returns: No return value
    */
   public class func dismiss(_ completion: (() -> Void)? = nil) {
      DispatchQueue.main.async { () -> Void in
         UIView.animate(withDuration: 0.5, animations: {
            shared.window.alpha = 0
         }, completion: { _ in
            shared.window.isHidden = true
            shared.appWindow?.makeKey()
            shared.activityIndicatorView.stopAnimating()

            completion?()
         })
      }
   }
}

/**
 *  KRProgressHUD update during show --------------------------
 */
extension KRProgressHUD {
   public class func update(text: String) {
      shared.messageLabel.text = text
   }
}

/**
 *  KRProgressHUD update style method --------------------------
 */
private extension KRProgressHUD {
   func applyStyles() {
      hudView.backgroundColor = style?.backgroundColor ?? viewAppearance.style.backgroundColor
      messageLabel.textColor = style?.textColor ?? viewAppearance.style.textColor
      iconDrawingLayer.fillColor = style?.iconColor?.cgColor ?? viewAppearance.style.iconColor?.cgColor
      hudViewController.view.backgroundColor = maskType?.maskColor ?? viewAppearance.maskType.maskColor
      activityIndicatorView.style = activityIndicatorStyle ?? viewAppearance.activityIndicatorStyle
      messageLabel.font = font ?? viewAppearance.font
      hudView.center = viewCenterPosition ?? viewAppearance.viewCenterPosition
   }

   func updateProgressHUDViewMessage(_ message: String?, onlyText: Bool = false) {
      if onlyText {
         messageLabel.isHidden = false
         messageLabel.text = message ?? ""
         messageLabel.sizeToFit()

         let center = hudView.center
         var frame = messageLabel.bounds
         frame.size = CGSize(width: frame.width + 40, height: frame.height + 20)
         hudView.frame = frame
         hudView.center = center
         messageLabel.center = CGPoint(x: frame.width/2, y: frame.height/2)
      } else if let text = message {
         let center = hudView.center
         var frame = hudView.frame
         frame.size = CGSize(width: 150, height: 110)
         hudView.frame = frame
         hudView.center = center

         iconView.center = CGPoint(x: 150/2, y: 40)

         messageLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 20)
         messageLabel.center = CGPoint(x: 150/2, y: 90)
         messageLabel.isHidden = false
         messageLabel.text = text
      } else {
         let center = hudView.center
         var frame = hudView.frame
         frame.size = CGSize(width: 100, height: 100)
         hudView.frame = frame
         hudView.center = center

         iconView.center = CGPoint(x: 50, y: 50)

         messageLabel.isHidden = true
      }
   }

   func updateProgressHUDViewIcon(iconType: KRProgressHUDIconType? = nil, image: UIImage? = nil, onlyText: Bool = false) {
      iconDrawingView.subviews.forEach { $0.removeFromSuperview() }
      iconDrawingView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

      iconDrawingView.isHidden = true
      activityIndicatorView.isHidden = true
      activityIndicatorView.stopAnimating()

      if onlyText { return }

      switch (iconType, image) {
      case (nil, nil):
         activityIndicatorView.isHidden = false
         activityIndicatorView.startAnimating()

      case let (nil, image):
         iconDrawingView.isHidden = false
         let imageView = UIImageView(image: image)
         imageView.frame = iconDrawingView.bounds
         imageView.contentMode = .scaleAspectFit
         iconDrawingView.addSubview(imageView)

      case let (type, _):
         iconDrawingView.isHidden = false

         iconDrawingLayer.path = type!.getPath()
         iconDrawingLayer.fillColor = iconDrawingLayer.fillColor ?? type!.getColor()

         iconDrawingView.layer.addSublayer(iconDrawingLayer)
      }
   }
}
