//
//  KRProgressHUD.swift
//  KRProgressHUD
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit

/**
 Type of KRProgressHUD's background view.

 - **Clear:** `UIColor.clearColor`.
 - **White:** `UIColor(white: 1, alpho: 0.2)`.
 - **Black:** `UIColor(white: 0, alpho: 0.2)`. Default type.
 */
public enum KRProgressHUDMaskType {
    case Clear, White, Black
}

/**
 Style of KRProgressHUD.

 - **Black:**           HUD's backgroundColor is `.blackColor()`. HUD's text color is `.whiteColor()`.
 - **White:**          HUD's backgroundColor is `.whiteColor()`. HUD's text color is `.blackColor()`. Default style.
 - **BlackColor:**   same `.Black` and confirmation glyphs become original color.
 - **WhiteColor:**  same `.Black` and confirmation glyphs become original color.
 */             
public enum KRProgressHUDStyle {
    case Black, White, BlackColor, WhiteColor
}

/**
 KRActivityIndicatorView style. (KRProgressHUD uses only large style.)

 - **Black:**   the color is `.blackColor()`. Default style.
 - **White:**  the color is `.blackColor()`.
 - **Color(startColor, endColor):**   the color is a gradation to `endColor` from `startColor`.
 */                                                                          
public enum KRProgressHUDActivityIndicatorStyle {
    case Black, White, Color(UIColor, UIColor)
}


/**
 *  KRProgressHUD is a beautiful and easy-to-use progress HUD.
 */
public final class KRProgressHUD {
    private static let view = KRProgressHUD()
    /// Shared instance. KRProgressHUD is created as singleton.
    class func sharedView() -> KRProgressHUD { return view }

    private let window = UIWindow(frame: UIScreen.mainScreen().bounds)
    private let progressHUDView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    private let iconView = UIView(frame: CGRect(x: 0,y: 0,width: 50,height: 50))
    private let activityIndicatorView = KRActivityIndicatorView(position: CGPointZero, activityIndicatorStyle: .LargeBlack)
    private let drawView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    private let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))

    private var maskType: KRProgressHUDMaskType {
        willSet {
            switch newValue {
            case .Clear:  window.rootViewController?.view.backgroundColor = UIColor.clearColor()
            case .White:  window.rootViewController?.view.backgroundColor = UIColor(white: 1, alpha: 0.2)
            case .Black:  window.rootViewController?.view.backgroundColor = UIColor(white: 0, alpha: 0.2)
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
    private var activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle {
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
    private var defaultActivityIndicatorStyle: KRProgressHUDActivityIndicatorStyle = .Black { willSet { activityIndicatorStyle = newValue } }
    private var defaultMessageFont = UIFont(name: "HiraginoSans-W3", size: 13) ?? UIFont.systemFontOfSize(13) { willSet { messageLabel.font = newValue } }


    private init() {
        maskType = .Black
        progressHUDStyle = .White
        activityIndicatorStyle = .Black
        
        configureProgressHUDView()
    }


    private func configureProgressHUDView() {
        let rootViewController = UIViewController()
        rootViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        window.rootViewController = rootViewController
        window.windowLevel = UIWindowLevelNormal
        
        let screenFrame = UIScreen.mainScreen().bounds
        progressHUDView.center = CGPoint(x: screenFrame.width/2, y: screenFrame.height/2 - 100)
        progressHUDView.backgroundColor = UIColor.whiteColor()
        progressHUDView.layer.cornerRadius = 10
        progressHUDView.autoresizingMask = [.FlexibleBottomMargin, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin]
        window.rootViewController?.view.addSubview(progressHUDView)

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
    /// Set default mask type.
    /// - parameter type: `KRProgressHUDMaskType`
    public class func setDefaultMaskType(type type: KRProgressHUDMaskType) {
        KRProgressHUD.sharedView().defaultMaskType = type
    }

    /// Set default HUD style
    /// - parameter style: `KRProgressHUDStyle`
    public class func setDefaultStyle(style style: KRProgressHUDStyle) {
        KRProgressHUD.sharedView().defaultStyle = style
    }

    /// Set default KRActivityIndicatorView style.
    /// - parameter style: `KRProgresHUDActivityIndicatorStyle`
    public class func setDefaultActivityIndicatorStyle(style style: KRProgressHUDActivityIndicatorStyle) {
        KRProgressHUD.sharedView().defaultActivityIndicatorStyle = style
    }

    /// Set default HUD text font.
    /// - parameter font: text font
    public class func setDefaultFont(font font: UIFont) {
        KRProgressHUD.sharedView().defaultMessageFont = font
    }
}


/**
 *  KRProgressHUD Show & Dismiss --------------------------
 */
extension KRProgressHUD {
    /**
     Showing HUD with some args. You can appoint only the args which You want to appoint.
     (Args is reflected only this time.)

     - parameter progressStyle  KRProgressHUDStyle
     - parameter type           KRProgressHUDMaskType
     - parameter indicatorStyle KRProgressHUDActivityIndicatorStyle
     - parameter font           HUD's message font
     - parameter message        HUD's message
     - parameter image          image that Alternative to confirmation glyph.
     */                               
    public class func show(
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type:KRProgressHUDMaskType? = nil,
            activityIndicatorStyle indicatorStyle: KRProgressHUDActivityIndicatorStyle? = nil,
            font: UIFont? = nil, message: String? = nil, image: UIImage? = nil) {
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: indicatorStyle)
        KRProgressHUD.sharedView().updateProgressHUDViewText(font: font, message: message)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(image: image)
        KRProgressHUD.sharedView().show()
    }

    /**
     Showing HUD with success glyph. the HUD dismiss after 1 secound.
     You can appoint only the args which You want to appoint.
     (Args is reflected only this time.)

     - parameter progressStyle  KRProgressHUDStyle
     - parameter type           KRProgressHUDMaskType
     - parameter indicatorStyle KRProgressHUDActivityIndicatorStyle
     - parameter font           HUD's message font
     - parameter message        HUD's message
     */
    public class func showSuccess(
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type:KRProgressHUDMaskType? = nil,
            activityIndicatorStyle indicatorStyle: KRProgressHUDActivityIndicatorStyle? = nil,
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

    /**
     Showing HUD with information glyph. the HUD dismiss after 1 secound.
     You can appoint only the args which You want to appoint.
     (Args is reflected only this time.)

     - parameter progressStyle  KRProgressHUDStyle
     - parameter type           KRProgressHUDMaskType
     - parameter indicatorStyle KRProgressHUDActivityIndicatorStyle
     - parameter font           HUD's message font
     - parameter message        HUD's message
     */
    public class func showInfo(
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type:KRProgressHUDMaskType? = nil,
            activityIndicatorStyle indicatorStyle: KRProgressHUDActivityIndicatorStyle? = nil,
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

    /**
     Showing HUD with warning glyph. the HUD dismiss after 1 secound.
     You can appoint only the args which You want to appoint.
     (Args is reflected only this time.)

     - parameter progressStyle  KRProgressHUDStyle
     - parameter type           KRProgressHUDMaskType
     - parameter indicatorStyle KRProgressHUDActivityIndicatorStyle
     - parameter font           HUD's message font
     - parameter message        HUD's message
     */
    public class func showWarning(
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type:KRProgressHUDMaskType? = nil,
            activityIndicatorStyle indicatorStyle: KRProgressHUDActivityIndicatorStyle? = nil,
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

    /**
     Showing HUD with error glyph. the HUD dismiss after 1 secound.
     You can appoint only the args which You want to appoint.
     (Args is reflected only this time.)

     - parameter progressStyle  KRProgressHUDStyle
     - parameter type           KRProgressHUDMaskType
     - parameter indicatorStyle KRProgressHUDActivityIndicatorStyle
     - parameter font           HUD's message font
     - parameter message        HUD's message
     */
    public class func showError(
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type:KRProgressHUDMaskType? = nil,
            activityIndicatorStyle indicatorStyle: KRProgressHUDActivityIndicatorStyle? = nil,
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

    /**
     Dismissing HUD.
    */
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
 *  KRProgressHUD update during show --------------------------
 */
extension KRProgressHUD {
    public class func updateLabel(text: String) {
        sharedView().messageLabel.text = text
    }
}


/**
 *  KRProgressHUD update style method --------------------------
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

    func updateStyles(progressHUDStyle progressStyle: KRProgressHUDStyle?, maskType type:KRProgressHUDMaskType?, activityIndicatorStyle indicatorStyle: KRProgressHUDActivityIndicatorStyle?) {
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