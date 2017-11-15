//
//  InnerKRProgressHUD.swift
//  KRProgressHUD
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit

fileprivate let fadeTime = Double(0.2)
fileprivate let hudSize = CGSize(width: 150, height: 110)
fileprivate let simpleHUDSize = CGSize(width: 100, height: 100)
fileprivate let iconViewSize = CGSize(width: 50, height: 50)
fileprivate let iconViewCenter = CGPoint(x: hudSize.width/2, y: 40)
fileprivate let simpleHUDIconViewCenter = CGPoint(x: simpleHUDSize.width/2, y: 50)
fileprivate let messageLabelMargin = CGFloat(10)
fileprivate let messageLabelFrame = CGRect(x: messageLabelMargin,
                                           y: iconViewCenter.y + iconViewSize.height / 2 + messageLabelMargin,
                                           width: hudSize.width - messageLabelMargin * 2,
                                           height: 20)

// MARK: - Internal actions --------------------------

extension KRProgressHUD {
   func configureProgressHUDView() {
      window.windowLevel = UIWindowLevelNormal

      hudView.frame.size = hudSize
      hudView.center = viewAppearance.viewCenterPosition
      hudView.backgroundColor = .white
      hudView.layer.cornerRadius = 10
      hudView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin,
                                  .flexibleLeftMargin, .flexibleRightMargin]

      iconView.frame.size = iconViewSize
      iconView.center = iconViewCenter
      iconView.backgroundColor = .clear
      iconView.isHidden = false

      activityIndicatorView.frame.size = iconViewSize
      activityIndicatorView.isLarge = true
      activityIndicatorView.animating = false
      activityIndicatorView.hidesWhenStopped = true

      iconDrawingView.frame.size = iconViewSize
      iconDrawingView.backgroundColor = .clear
      iconDrawingView.isHidden = true

      iconDrawingLayer.frame.size = iconViewSize
      iconDrawingLayer.lineWidth = 0
      iconDrawingLayer.fillColor = nil

      imageView.frame.size = iconViewSize
      imageView.backgroundColor = .clear
      imageView.contentMode = .scaleAspectFit
      imageView.isHidden = true

      messageLabel.frame = messageLabelFrame
      messageLabel.backgroundColor = .clear
      messageLabel.textAlignment = .center
      messageLabel.adjustsFontSizeToFitWidth = true
      messageLabel.minimumScaleFactor = 0.5
      messageLabel.numberOfLines = 1

      iconDrawingView.layer.addSublayer(iconDrawingLayer)
      iconView.addSubview(imageView)
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
             imageSize: CGSize? = nil,
             isOnlyText: Bool = false,
             isLoading: Bool = false,
             completion: CompletionHandler? = nil ) {
      DispatchQueue.main.async {
         self.applyStyles()
         self.updateLayouts(message: message, iconType: iconType, image: image, imageSize: imageSize, isOnlyText: isOnlyText)

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
         self.fadeOutView(completion: completion)
      }
   }
}

// MARK: - Private actions --------------------------

extension KRProgressHUD {
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
         hudView.alpha = 0
      } else {
         hudViewController.view.alpha = 0
         if let presentingVC = presentingViewController {
            presentingVC.view.addSubview(hudViewController.view)
         } else {
            appWindow = UIApplication.shared.keyWindow
            window.makeKeyAndVisible()
         }
      }

      KRProgressHUD.isVisible = true
      UIView.animate(withDuration: fadeTime, animations: {
         self.hudView.alpha = 1
         self.hudViewController.view.alpha = 1
      }) { _ in
         completion?()
      }
   }

   func fadeOutView(completion: CompletionHandler?) {
         UIView.animate(withDuration: fadeTime, animations: {
            self.hudViewController.view.alpha = 0
         }, completion: { _ in
            self.appWindow?.makeKeyAndVisible()
            self.appWindow = nil
            self.window.isHidden = true
            self.hudViewController.view.removeFromSuperview()
            self.presentingViewController = nil
            self.activityIndicatorView.stopAnimating()
            KRProgressHUD.isVisible = false
            completion?()
         })
   }

   func applyStyles() {
      hudView.backgroundColor = style?.backgroundColor ?? viewAppearance.style.backgroundColor
      messageLabel.textColor = style?.textColor ?? viewAppearance.style.textColor
      iconDrawingLayer.fillColor = style?.iconColor?.cgColor ?? viewAppearance.style.iconColor?.cgColor
      hudViewController.view.backgroundColor = maskType?.maskColor ?? viewAppearance.maskType.maskColor
      activityIndicatorView.style = activityIndicatorStyle ?? viewAppearance.activityIndicatorStyle
      messageLabel.font = font ?? viewAppearance.font
   }

   func resetLayouts() {
      hudView.frame.size = hudSize
      hudView.center = viewCenterPosition ?? viewAppearance.viewCenterPosition
      iconView.isHidden = false
      iconView.center = iconViewCenter
      activityIndicatorView.stopAnimating()
      iconDrawingView.isHidden = true
      iconDrawingLayer.path = nil
      imageView.image = nil
      imageView.isHidden = true
      messageLabel.frame = messageLabelFrame
      messageLabel.numberOfLines = 1
      messageLabel.isHidden = false
   }

   func updateLayouts(message: String?, iconType: KRProgressHUDIconType?, image: UIImage?, imageSize: CGSize?, isOnlyText: Bool) {
      resetLayouts()
      messageLabel.text = message

      if isOnlyText {
         iconView.isHidden = true
         messageLabel.numberOfLines = 0
         messageLabel.frame.size.width = UIScreen.main.bounds.width - messageLabelMargin * 4
         messageLabel.sizeToFit()
         messageLabel.frame.origin = CGPoint(x: messageLabelMargin, y: messageLabelMargin)
         hudView.frame.size = CGSize(width: messageLabel.bounds.width + messageLabelMargin*2,
                                     height: messageLabel.bounds.height + messageLabelMargin*2)
         hudView.center = viewCenterPosition ?? viewAppearance.viewCenterPosition
         return
      }

      if message == nil {
         messageLabel.isHidden = true
         hudView.frame.size = simpleHUDSize
         hudView.center = viewCenterPosition ?? viewAppearance.viewCenterPosition
         iconView.center = simpleHUDIconViewCenter
      }

      switch (iconType, image) {
      case (nil, nil):
         activityIndicatorView.startAnimating()

      case (nil, let image):
         imageView.isHidden = false
         let size = imageSize ?? image!.size
         imageView.contentMode = size.width < imageView.bounds.width && size.height < imageView.bounds.height ? .center : .scaleAspectFit
         imageView.image = image

      case (let iconType, _):
         iconDrawingView.isHidden = false
         iconDrawingLayer.path = iconType!.getPath()
         iconDrawingLayer.fillColor = iconDrawingLayer.fillColor ?? iconType!.getColor()
      }
   }
}
