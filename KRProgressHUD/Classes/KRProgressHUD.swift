//
//  KRProgressHUD.swift
//  KRProgressHUD
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit

public enum KRProgressHUDMaskType {
    case Clear, White, Black
}

public enum KRProgressHUDStyle {
    case Black, White, BlackColor, WhiteColor
}

public enum KRActivityIndicatorStyle {
    case Black, White, Color(UIColor, UIColor)
}


public final class KRProgressHUD {
    private static let view = KRProgressHUD()
    public class func sharedView() -> KRProgressHUD { return view }

    private let window = UIWindow(frame: UIScreen.mainScreen().bounds)
    private let progressHUDView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    private let iconView = UIView(frame: CGRect(x: 0,y: 0,width: 50,height: 50))
    private let activityIndicatorView = KRActivityIndicatorView(position: CGPointZero, activityIndicatorStyle: .LargeBlack)
    private let drawView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    private let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))

    private var maskType: KRProgressHUDMaskType {
        willSet {
            switch newValue {
            case .Clear:  window.backgroundColor = UIColor.clearColor()
            case .White:  window.backgroundColor = UIColor(white: 1, alpha: 0.2)
            case .Black:  window.backgroundColor = UIColor(white: 0, alpha: 0.2)
            }
        }
    }

    private var progressHUDStyle: KRProgressHUDStyle {
        willSet {
            switch newValue {
            case .Black, .BlackColor: 
                progressHUDView.backgroundColor = UIColor.blackColor()
                messageLabel.textColor = UIColor.whiteColor()
            case .White, .WhiteColor: 
                progressHUDView.backgroundColor = UIColor.whiteColor()
                messageLabel.textColor = UIColor.blackColor()
            }
        }
    }
    private var activityIndicatorStyle: KRActivityIndicatorStyle {
        willSet {
            switch newValue {
            case .Black:  activityIndicatorView.activityIndicatorViewStyle = .LargeBlack
            case .White:  activityIndicatorView.activityIndicatorViewStyle = .LargeWhite
            case let .Color(sc, ec):  activityIndicatorView.activityIndicatorViewStyle = .LargeColor(sc, ec)
            }
        }
    }
    private var defaultStyle: KRProgressHUDStyle = .White { willSet { progressHUDStyle = newValue } }
    private var defaultMaskType: KRProgressHUDMaskType = .Black { willSet { maskType = newValue } }
    private var defaultActivityIndicatorStyle: KRActivityIndicatorStyle = .Black { willSet { activityIndicatorStyle = newValue } }
    private var defaultMessageFont = UIFont(name: "HiraginoSans-W3", size: 13) ?? UIFont.systemFontOfSize(13) { willSet { messageLabel.font = newValue } }


    private init() {
        window.windowLevel = UIWindowLevelNormal
        window.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        maskType = .Black
        progressHUDStyle = .White
        activityIndicatorStyle = .Black
        
        configureProgressHUDView()
    }


    private func configureProgressHUDView() {
        let screenFrame = UIScreen.mainScreen().bounds
        progressHUDView.center = CGPoint(x: screenFrame.width/2, y: screenFrame.height/2 - 100)
        progressHUDView.backgroundColor = UIColor.whiteColor()
        progressHUDView.layer.cornerRadius = 10
        window.addSubview(progressHUDView)

        iconView.backgroundColor = UIColor.clearColor()
        iconView.center = CGPoint(x: 50, y: 50)
        progressHUDView.addSubview(iconView)

        activityIndicatorView.hidden = false
        iconView.addSubview(activityIndicatorView)

        drawView.backgroundColor = UIColor.clearColor()
        drawView.hidden = true
        iconView.addSubview(drawView)

        messageLabel.center = CGPoint(x: 150/2, y: 90)
        messageLabel.backgroundColor = UIColor.clearColor()
        messageLabel.font = defaultMessageFont
        messageLabel.textAlignment = .Center
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.minimumScaleFactor = 0.5
        messageLabel.text = nil
        messageLabel.hidden = true
        progressHUDView.addSubview(messageLabel)
    }
}


/**
 *  KRProgressHUD Setter --------------------------
 */
extension KRProgressHUD {
    public class func setDefaultMaskType(type type: KRProgressHUDMaskType) {
        KRProgressHUD.sharedView().defaultMaskType = type
    }

    public class func setDefaultStyle(style style: KRProgressHUDStyle) {
        KRProgressHUD.sharedView().defaultStyle = KRProgressHUD.sharedView().progressHUDStyle
    }

    public class func setDefaultActivityIndicatorStyle(style style: KRActivityIndicatorStyle) {
        KRProgressHUD.sharedView().defaultActivityIndicatorStyle = style
    }

    public class func setDefaultFont(font font: UIFont) {
        KRProgressHUD.sharedView().defaultMessageFont = font
    }
}


/**
 *  KRProgressHUD Show & Dismiss --------------------------
 */
extension KRProgressHUD {
    public class func show(
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type:KRProgressHUDMaskType? = nil,
            activityIndicatorStyle indicatorStyle: KRActivityIndicatorStyle? = nil,
            font: UIFont? = nil, message: String? = nil, image: UIImage? = nil) {
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: indicatorStyle)
        KRProgressHUD.sharedView().updateProgressHUDViewText(font: font, message: message)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(image: image)
        KRProgressHUD.sharedView().show()
    }

    public class func showSuccess(
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type:KRProgressHUDMaskType? = nil,
            activityIndicatorStyle indicatorStyle: KRActivityIndicatorStyle? = nil,
            font: UIFont? = nil, message: String? = nil) {
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: indicatorStyle)
        KRProgressHUD.sharedView().updateProgressHUDViewText(font: font, message: message)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(iconType: .Success)
        KRProgressHUD.sharedView().show()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            sleep(1)
            KRProgressHUD.dismiss()
        }
    }

    public class func showInfo(
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type:KRProgressHUDMaskType? = nil,
            activityIndicatorStyle indicatorStyle: KRActivityIndicatorStyle? = nil,
            font: UIFont? = nil, message: String? = nil) {
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: indicatorStyle)
        KRProgressHUD.sharedView().updateProgressHUDViewText(font: font, message: message)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(iconType: .Info)
        KRProgressHUD.sharedView().show()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            sleep(1)
            KRProgressHUD.dismiss()
        }
    }

    public class func showWarning(
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type:KRProgressHUDMaskType? = nil,
            activityIndicatorStyle indicatorStyle: KRActivityIndicatorStyle? = nil,
            font: UIFont? = nil, message: String? = nil) {
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: indicatorStyle)
        KRProgressHUD.sharedView().updateProgressHUDViewText(font: font, message: message)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(iconType: .Warning)
        KRProgressHUD.sharedView().show()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            sleep(1)
            KRProgressHUD.dismiss()
        }
    }

    public class func showError(
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type:KRProgressHUDMaskType? = nil,
            activityIndicatorStyle indicatorStyle: KRActivityIndicatorStyle? = nil,
            font: UIFont? = nil, message: String? = nil) {
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: indicatorStyle)
        KRProgressHUD.sharedView().updateProgressHUDViewText(font: font, message: message)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(iconType: .Error)
        KRProgressHUD.sharedView().show()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            sleep(1)
            KRProgressHUD.dismiss()
        }
    }

    public class func dismiss() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            UIView.animateWithDuration(0.5, animations: {
                KRProgressHUD.sharedView().window.alpha = 0
            }) { _ in
                KRProgressHUD.sharedView().window.hidden = true
                KRProgressHUD.sharedView().activityIndicatorView.stopAnimating()
             
                KRProgressHUD.sharedView().progressHUDStyle = KRProgressHUD.sharedView().defaultStyle
                KRProgressHUD.sharedView().maskType = KRProgressHUD.sharedView().defaultMaskType
                KRProgressHUD.sharedView().activityIndicatorStyle = KRProgressHUD.sharedView().defaultActivityIndicatorStyle
                KRProgressHUD.sharedView().messageLabel.font = KRProgressHUD.sharedView().defaultMessageFont
            }
        }
    }
}


/**
 *  KRProgressHUD update method --------------------------
 */
private extension KRProgressHUD {
    func show() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.window.alpha = 0
            self.window.makeKeyAndVisible()
            
            UIView.animateWithDuration(0.5) {
                KRProgressHUD.sharedView().window.alpha = 1
            }
        }
    }

    func updateStyles(progressHUDStyle progressStyle: KRProgressHUDStyle?, maskType type:KRProgressHUDMaskType?, activityIndicatorStyle indicatorStyle: KRActivityIndicatorStyle?) {
        if let style = progressStyle {
            KRProgressHUD.sharedView().progressHUDStyle = style
        }
        if let type = type {
            KRProgressHUD.sharedView().maskType = type
        }
        if let style = indicatorStyle {
            KRProgressHUD.sharedView().activityIndicatorStyle = style
        }
    }

    func updateProgressHUDViewText(font font: UIFont?, message: String?) {
        if let text = message {
            let center = progressHUDView.center
            var frame = progressHUDView.frame
            frame.size = CGSize(width: 150, height: 110)
            progressHUDView.frame = frame
            progressHUDView.center = center

            iconView.center = CGPoint(x: 150/2, y: 40)

            messageLabel.hidden = false
            messageLabel.text = text
            messageLabel.font = font ?? defaultMessageFont
        } else {
            let center = progressHUDView.center
            var frame = progressHUDView.frame
            frame.size = CGSize(width: 100, height: 100)
            progressHUDView.frame = frame
            progressHUDView.center = center

            iconView.center = CGPoint(x: 50, y: 50)

            messageLabel.hidden = true
        }
    }

    func updateProgressHUDViewIcon(iconType iconType: KRProgressHUDIconType? = nil, image: UIImage? = nil) {
        drawView.subviews.forEach{ $0.removeFromSuperview() }
        drawView.layer.sublayers?.forEach{ $0.removeFromSuperlayer() }

        switch (iconType, image) {
        case (nil, nil): 
            drawView.hidden = true
            activityIndicatorView.hidden = false
            activityIndicatorView.startAnimating()

        case let (nil, image): 
            activityIndicatorView.hidden = true
            activityIndicatorView.stopAnimating()
            drawView.hidden = false

            let imageView = UIImageView(image: image)
            imageView.frame = KRProgressHUD.sharedView().drawView.bounds
            imageView.contentMode = .ScaleAspectFit
            drawView.addSubview(imageView)

        case let (type, _): 
            drawView.hidden = false
            activityIndicatorView.hidden = true
            activityIndicatorView.stopAnimating()

            let pathLayer = CAShapeLayer()
            pathLayer.frame = drawView.layer.bounds
            pathLayer.lineWidth = 0
            pathLayer.path = type!.getPath()

            switch progressHUDStyle {
            case .Black:  pathLayer.fillColor = UIColor.whiteColor().CGColor
            case .White:  pathLayer.fillColor = UIColor.blackColor().CGColor
            default:  pathLayer.fillColor = type!.getColor()
            }

            drawView.layer.addSublayer(pathLayer)
        }
    }
}