//
//  InnerKRProgressHUD.swift
//  KRProgressHUD
//
//  Copyright © 2016 Krimpedance. All rights reserved.
//

import UIKit

private let fadeTime = Double(0.2)
private let hudViewMargin = CGFloat(50)
private let hudViewPadding = CGFloat(15)
private let iconViewSize = CGSize(width: 50, height: 50)
private let messageLabelTopMargin = CGFloat(10)
private let messageLabelMinWidth = CGFloat(120)

// MARK: - Internal actions --------------------------

extension KRProgressHUD {
    func configureProgressHUDView() {
        window.windowLevel = .normal
        hudViewController.view.translatesAutoresizingMaskIntoConstraints = false

        hudView.backgroundColor = .white
        hudView.layer.cornerRadius = 10
        hudView.translatesAutoresizingMaskIntoConstraints = false

        iconView.backgroundColor = .clear
        iconView.isHidden = false
        iconView.translatesAutoresizingMaskIntoConstraints = false

        activityIndicatorView.frame.size = iconViewSize
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

        messageLabel.backgroundColor = .clear
        messageLabel.textAlignment = .center
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.minimumScaleFactor = 0.5
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        iconDrawingView.layer.addSublayer(iconDrawingLayer)
        iconView.addSubview(imageView)
        iconView.addSubview(iconDrawingView)
        iconView.addSubview(activityIndicatorView)
        hudView.addSubview(iconView)
        hudView.addSubview(messageLabel)
        hudViewController.view.addSubview(hudView)
        window.rootViewController = hudViewController

        setUpConstraints()
        applyStyles()
    }

    func show(withMessage message: String?,
              iconType: KRProgressHUDIconType? = nil,
              image: UIImage? = nil,
              imageSize: CGSize? = nil,
              isOnlyText: Bool = false,
              isLoading: Bool = false,
              completion: CompletionHandler? = nil) {
        DispatchQueue.main.async { [unowned self] in
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
        DispatchQueue.main.async { [unowned self] in
            self.fadeOutView(completion: completion)
        }
    }
}

// MARK: - Private actions --------------------------

extension KRProgressHUD {
    func setUpConstraints() {
        hudViewCenterYConstraint = NSLayoutConstraint(item: hudView, attribute: .centerY, toItem: hudViewController.view, constant: viewOffset ?? viewAppearance.viewOffset)
        hudViewSideMarginConstraints += [
            NSLayoutConstraint(item: hudView, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: hudViewController.view, constant: hudViewMargin),
            NSLayoutConstraint(item: hudView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: hudViewController.view, constant: -hudViewMargin)
        ]

        iconViewConstraints += [
            NSLayoutConstraint(item: iconView, attribute: .top, toItem: hudView, constant: hudViewPadding),
            NSLayoutConstraint(item: iconView, attribute: .centerX, toItem: hudView),
            NSLayoutConstraint(item: iconView, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: hudView, constant: hudViewPadding),
            NSLayoutConstraint(item: iconView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: hudView, constant: -hudViewPadding),
            NSLayoutConstraint(item: iconView, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: hudView, constant: -hudViewPadding)
        ]

        messageLabelMinWidthConstraint = NSLayoutConstraint(item: messageLabel, attribute: .width, relatedBy: .greaterThanOrEqual, constant: messageLabelMinWidth)
        messageLabelConstraints += [
            messageLabelMinWidthConstraint,
            NSLayoutConstraint(item: messageLabel, attribute: .top, toItem: iconView, attribute: .bottom, constant: messageLabelTopMargin),
            NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: hudView, constant: hudViewPadding),
            NSLayoutConstraint(item: messageLabel, attribute: .left, toItem: hudView, constant: hudViewPadding),
            NSLayoutConstraint(item: messageLabel, attribute: .right, toItem: hudView, constant: -hudViewPadding),
            NSLayoutConstraint(item: messageLabel, attribute: .bottom, toItem: hudView, constant: -hudViewPadding)
        ]

        hudViewController.view.addConstraints([
            NSLayoutConstraint(item: hudView, attribute: .centerX, toItem: hudViewController.view),
            hudViewCenterYConstraint
        ] + hudViewSideMarginConstraints)
        hudView.addConstraints(iconViewConstraints + messageLabelConstraints)
        iconView.addConstraints([
            NSLayoutConstraint(item: iconView, attribute: .width, constant: iconViewSize.width),
            NSLayoutConstraint(item: iconView, attribute: .height, constant: iconViewSize.height)
        ])
    }

    func cancelCurrentDismissHandler() -> Bool {
        guard let handler = dismissHandler else { return true }
        defer { dismissHandler = nil }
        handler.cancel()
        return handler.isCancelled
    }

    func registerDismissHandler() {
        dismissHandler = DispatchWorkItem { [unowned self] in
            KRProgressHUD.dismiss()
            _ = self.cancelCurrentDismissHandler()
        }
        let duration = DispatchTime.now() + (self.duration ?? viewAppearance.duration)
        DispatchQueue.global().asyncAfter(deadline: duration, execute: dismissHandler!)
    }

    func fadeInView(completion: CompletionHandler?) {
        if KRProgressHUD.isVisible {
            hudView.alpha = 0
        } else {
            hudViewController.view.alpha = 0
            if let presentingVC = presentingViewController {
                window.rootViewController = nil
                presentingVC.addChild(hudViewController)
                presentingVC.view.addSubview(hudViewController.view)
                setConstraintsToPresentingVC()
                presentingVC.didMove(toParent: hudViewController)
            } else {
                if #available(iOS 13.0, *) {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        window.windowScene = windowScene
                    } else {
                        print("UIWindowScene not found")
                    }
                }
                window.makeKeyAndVisible()
            }
        }

        KRProgressHUD.isVisible = true
        UIView.animate(withDuration: fadeTime, animations: { [unowned self] in
            self.hudView.alpha = 1
            self.hudViewController.view.alpha = 1
        }, completion: { _ in
            completion?()
        })
    }

    func fadeOutView(completion: CompletionHandler?) {
        UIView.animate(withDuration: fadeTime, animations: { [unowned self] in
            self.hudViewController.view.alpha = 0
        }, completion: { [unowned self] _ in
            self.window.isHidden = true
            if self.presentingViewController != nil {
                self.hudViewController.willMove(toParent: nil)
                self.hudViewController.view.removeFromSuperview()
                self.hudViewController.removeFromParent()
                self.presentingViewController = nil
                self.window.rootViewController = self.hudViewController
            }
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
        activityIndicatorView.colors = activityIndicatorColors ?? viewAppearance.activityIndicatorColors
        messageLabel.font = font ?? viewAppearance.font
    }

    func resetLayouts() {
        iconView.isHidden = false
        activityIndicatorView.stopAnimating()
        iconDrawingView.isHidden = true
        iconDrawingLayer.path = nil
        imageView.image = nil
        imageView.isHidden = true
        messageLabel.isHidden = false
        hudViewCenterYConstraint.constant = viewOffset ?? viewAppearance.viewOffset
        hudViewSideMarginConstraints.forEach { $0.isActive = true }
        iconViewConstraints.forEach { $0.isActive = true }
        messageLabelConstraints.forEach { $0.isActive = true }
    }

    func updateLayouts(message: String?, iconType: KRProgressHUDIconType?, image: UIImage?, imageSize: CGSize?, isOnlyText: Bool) {
        resetLayouts()
        messageLabel.text = message

        if isOnlyText {
            iconView.isHidden = true
            iconViewConstraints.forEach { $0.isActive = false }
            messageLabelMinWidthConstraint.isActive = false
            return
        }

        if message == nil {
            messageLabel.isHidden = true
            messageLabelConstraints.forEach { $0.isActive = false }
            hudViewSideMarginConstraints.forEach { $0.isActive = false }
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

    func setConstraintsToPresentingVC() {
        guard let view = presentingViewController?.view, view == hudViewController.view.superview else { return }
        view.addConstraints([
            NSLayoutConstraint(item: hudViewController.view!, attribute: .top, toItem: view),
            NSLayoutConstraint(item: hudViewController.view!, attribute: .bottom, toItem: view),
            NSLayoutConstraint(item: hudViewController.view!, attribute: .left, toItem: view),
            NSLayoutConstraint(item: hudViewController.view!, attribute: .right, toItem: view)
        ])
    }
}
