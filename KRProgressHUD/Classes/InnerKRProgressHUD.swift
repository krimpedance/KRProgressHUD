//
//  InnerKRProgressHUD.swift
//  KRProgressHUD
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit

fileprivate let fadeTime = Double(0.2)

// MARK: - Internal actions --------------------------

extension KRProgressHUD {
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

      iconDrawingView.layer.addSublayer(iconDrawingLayer)
      iconView.addSubview(iconDrawingView)
      iconView.addSubview(activityIndicatorView)
      hudView.addSubview(iconView)
      hudView.addSubview(messageLabel)
      hudViewController.view.addSubview(hudView)
      window.rootViewController = hudViewController

      applyStyles()
   }

   func show(withMessage message: String?,
             iconType: KRProgressHUDIconType? = nil,
             image: UIImage? = nil,
             onlyText: Bool = false,
             isLoading: Bool = false,
             completion: CompletionHandler? = nil ) {
      applyStyles()
      updateProgressHUDViewMessage(message, onlyText: onlyText)
      updateProgressHUDViewIcon(iconType: iconType, image: image, onlyText: onlyText)

      DispatchQueue.main.async {
         let deadline = self.cancelCurrentDismissHandler() ? 0 : fadeTime
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + deadline) {
            self.fadeInView(completion: completion)
            if isLoading { return }
            self.registerDismissHandler()
         }
      }
   }

   func dismiss(completion: CompletionHandler?) {
      DispatchQueue.main.async {
         UIView.animate(withDuration: fadeTime, animations: {
            self.window.alpha = 0
         }, completion: { _ in
            self.appWindow?.makeKeyAndVisible()
            self.window.isHidden = true
            self.activityIndicatorView.stopAnimating()
            completion?()
         })
      }
   }
}

// MARK: - Private actions --------------------------

fileprivate extension KRProgressHUD {
   func cancelCurrentDismissHandler() -> Bool {
      guard let handler = dismissHandler else { return true }
      defer { dismissHandler = nil }
      handler.cancel()
      return handler.isCancelled
   }

   func registerDismissHandler() {
      dismissHandler = DispatchWorkItem {
         KRProgressHUD.dismiss()
         _ = self.cancelCurrentDismissHandler()
      }
      let deadline = DispatchTime.now() + (deadlineTime ?? viewAppearance.deadlineTime)
      DispatchQueue.global().asyncAfter(deadline: deadline, execute: dismissHandler!)
   }

   func fadeInView(completion: CompletionHandler?) {
      if KRProgressHUD.isVisible {
         self.hudView.alpha = 0
      } else {
         self.appWindow = UIApplication.shared.keyWindow
         self.window.alpha = 0
      }
      self.window.makeKeyAndVisible()

      UIView.animate(withDuration: fadeTime, animations: {
         self.window.alpha = 1
         self.hudView.alpha = 1
      }) { _ in
         completion?()
      }
   }

   func applyStyles() {
      hudView.backgroundColor = style?.backgroundColor ?? viewAppearance.style.backgroundColor
      messageLabel.textColor = style?.textColor ?? viewAppearance.style.textColor
      iconDrawingLayer.fillColor = style?.iconColor?.cgColor ?? viewAppearance.style.iconColor?.cgColor
      hudViewController.view.backgroundColor = maskType?.maskColor ?? viewAppearance.maskType.maskColor
      activityIndicatorView.style = activityIndicatorStyle ?? viewAppearance.activityIndicatorStyle
      messageLabel.font = font ?? viewAppearance.font
      hudView.center = viewCenterPosition ?? viewAppearance.viewCenterPosition
   }

   func updateProgressHUDViewMessage(_ message: String?, onlyText: Bool) {
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

   func updateProgressHUDViewIcon(iconType: KRProgressHUDIconType?, image: UIImage?, onlyText: Bool) {
      iconDrawingView.subviews.forEach { $0.removeFromSuperview() }

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
      }
   }
}
