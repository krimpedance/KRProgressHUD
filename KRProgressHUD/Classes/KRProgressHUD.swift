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
    case clear, white, black
}

/**
 Style of KRProgressHUD.

 - **Black:**           HUD's backgroundColor is `.blackColor()`. HUD's text color is `.whiteColor()`.
 - **White:**          HUD's backgroundColor is `.whiteColor()`. HUD's text color is `.blackColor()`. Default style.
 - **BlackColor:**   same `.Black` and confirmation glyphs become original color.
 - **WhiteColor:**  same `.Black` and confirmation glyphs become original color.
 */
public enum KRProgressHUDStyle {
    case black, white, blackColor, whiteColor
}

/**
 KRActivityIndicatorView style. (KRProgressHUD uses only large style.)

 - **Black:**   the color is `.blackColor()`. Default style.
 - **White:**  the color is `.blackColor()`.
 - **Color(startColor, endColor):**   the color is a gradation to `endColor` from `startColor`.
 */
public enum KRProgressHUDActivityIndicatorStyle {
    case black, white, color(UIColor, UIColor)
}


/**
 *  KRProgressHUD is a beautiful and easy-to-use progress HUD.
 */
public final class KRProgressHUD {
    fileprivate static let view = KRProgressHUD()
    class func sharedView() -> KRProgressHUD { return view }

    fileprivate let window = UIWindow(frame: UIScreen.main.bounds)
    fileprivate let progressHUDView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    fileprivate let iconView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    fileprivate let activityIndicatorView = KRActivityIndicatorView(position: CGPoint.zero, activityIndicatorStyle: .largeBlack)
    fileprivate let drawView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    fileprivate let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))

    fileprivate var tmpWindow: UIWindow?

    fileprivate var maskType: KRProgressHUDMaskType {
        willSet {
            switch newValue {
            case .clear:  window.rootViewController?.view.backgroundColor = UIColor.clear
            case .white:  window.rootViewController?.view.backgroundColor = UIColor(white: 1, alpha: 0.2)
            case .black:  window.rootViewController?.view.backgroundColor = UIColor(white: 0, alpha: 0.2)
            }
        }
    }

    fileprivate var progressHUDStyle: KRProgressHUDStyle {
        willSet {
            switch newValue {
            case .black, .blackColor:
                progressHUDView.backgroundColor = UIColor.black
                messageLabel.textColor = UIColor.white
            case .white, .whiteColor:
                progressHUDView.backgroundColor = UIColor.white
                messageLabel.textColor = UIColor.black
            }
        }
    }
    fileprivate var activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle {
        willSet {
            switch newValue {
            case .black:  activityIndicatorView.activityIndicatorViewStyle = .largeBlack
            case .white:  activityIndicatorView.activityIndicatorViewStyle = .largeWhite
            case let .color(sc, ec):  activityIndicatorView.activityIndicatorViewStyle = .largeColor(sc, ec)
            }
        }
    }
    fileprivate var defaultStyle: KRProgressHUDStyle = .white { willSet { progressHUDStyle = newValue } }
    fileprivate var defaultMaskType: KRProgressHUDMaskType = .black { willSet { maskType = newValue } }
    fileprivate var defaultActivityIndicatorStyle: KRProgressHUDActivityIndicatorStyle = .black { willSet { activityIndicatorStyle = newValue } }
    fileprivate var defaultMessageFont = UIFont.systemFont(ofSize: 13) { willSet { messageLabel.font = newValue } }
    fileprivate var defaultPosition: CGPoint = {
        let screenFrame = UIScreen.main.bounds
        return CGPoint(x: screenFrame.width/2, y: screenFrame.height/2)
    }() {
        willSet { progressHUDView.center = newValue }
    }

    public static var isVisible: Bool {
        return sharedView().window.alpha == 0 ? false : true
    }


    fileprivate init() {
        maskType = .black
        progressHUDStyle = .white
        activityIndicatorStyle = .black
        configureProgressHUDView()
    }


    fileprivate func configureProgressHUDView() {
        let rootViewController = KRProgressHUDViewController()
        window.rootViewController = rootViewController
        window.windowLevel = UIWindowLevelNormal
        window.alpha = 0

        progressHUDView.center = defaultPosition
        progressHUDView.backgroundColor = UIColor.white
        progressHUDView.layer.cornerRadius = 10
        progressHUDView.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin]
        window.rootViewController?.view.addSubview(progressHUDView)

        iconView.backgroundColor = UIColor.clear
        iconView.center = CGPoint(x: 50, y: 50)
        progressHUDView.addSubview(iconView)

        activityIndicatorView.isHidden = false
        iconView.addSubview(activityIndicatorView)

        drawView.backgroundColor = UIColor.clear
        drawView.isHidden = true
        iconView.addSubview(drawView)

        messageLabel.center = CGPoint(x: 150/2, y: 90)
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.font = defaultMessageFont
        messageLabel.textAlignment = .center
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.minimumScaleFactor = 0.5
        messageLabel.text = nil
        messageLabel.isHidden = true
        progressHUDView.addSubview(messageLabel)
    }
}


/**
 *  KRProgressHUD Setter --------------------------
 */
extension KRProgressHUD {
    /// Set default mask type.
    /// - parameter type: `KRProgressHUDMaskType`
    public class func set(maskType type: KRProgressHUDMaskType) {
        KRProgressHUD.sharedView().defaultMaskType = type
    }

    /// Set default HUD style
    /// - parameter style: `KRProgressHUDStyle`
    public class func set(style: KRProgressHUDStyle) {
        KRProgressHUD.sharedView().defaultStyle = style
    }

    /// Set default KRActivityIndicatorView style.
    /// - parameter style: `KRProgresHUDActivityIndicatorStyle`
    public class func set(activityIndicatorStyle style: KRProgressHUDActivityIndicatorStyle) {
        KRProgressHUD.sharedView().defaultActivityIndicatorStyle = style
    }

    /// Set default HUD text font.
    /// - parameter font: text font
    public class func set(font: UIFont) {
        KRProgressHUD.sharedView().defaultMessageFont = font
    }

    /// Set default HUD center's position.
    /// - parameter position: center position
    public class func set(centerPosition position: CGPoint) {
        KRProgressHUD.sharedView().defaultPosition = position
    }
}


/**
 *  KRProgressHUD Show & Dismiss --------------------------
 */
extension KRProgressHUD {
    /**
     Showing HUD with some args. You can appoint only the args which You want to appoint.
     (Args is reflected only this time.)

     - parameter progressHUDStyle:   KRProgressHUDStyle
     - parameter maskType:           KRProgressHUDMaskType
     - parameter activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle
     - parameter font:           HUD's message font
     - parameter message:        HUD's message
     - parameter image:          image that Alternative to confirmation glyph.
     - parameter completion:          completion handler.

     - returns: No return value.
     */
    public class func show(
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type: KRProgressHUDMaskType? = nil,
            activityIndicatorStyle indicatorStyle: KRProgressHUDActivityIndicatorStyle? = nil,
            font: UIFont? = nil, message: String? = nil, image: UIImage? = nil,
            completion: (()->())? = nil
        ) {
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: indicatorStyle)
        KRProgressHUD.sharedView().updateProgressHUDViewText(font: font, message: message)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(image: image)
        KRProgressHUD.sharedView().show() { completion?() }
    }

    /**
     Showing HUD with success glyph. the HUD dismiss after 1 secound.
     You can appoint only the args which You want to appoint.
     (Args is reflected only this time.)

     - parameter message:        HUD's message
     - parameter font:           HUD's message font
     - parameter centerPosition:           HUD's center position
     - parameter progressHUDStyle:   KRProgressHUDStyle
     - parameter maskType:           KRProgressHUDMaskType
     */
	public class func showText(
            message: String, font: UIFont? = nil,
            centerPosition position: CGPoint? = nil,
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type: KRProgressHUDMaskType? = nil) {
        KRProgressHUD.sharedView().progressHUDView.center = position ?? KRProgressHUD.sharedView().defaultPosition
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: nil)
        KRProgressHUD.sharedView().updateProgressHUDViewText(font: font, message: message, onlyText: true)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(onlyText: true)
        KRProgressHUD.sharedView().show()
        Thread.afterDelay(2.0) {
        	KRProgressHUD.dismiss()
        }
	}

    /**
     Showing HUD with success glyph. the HUD dismiss after 1 secound.
     You can appoint only the args which You want to appoint.
     (Args is reflected only this time.)

     - parameter progressHUDStyle:   KRProgressHUDStyle
     - parameter maskType:           KRProgressHUDMaskType
     - parameter font:           HUD's message font
     - parameter message:        HUD's message
     */
	public class func showSuccess(
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type: KRProgressHUDMaskType? = nil,
            font: UIFont? = nil, message: String? = nil) {
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: nil)
        KRProgressHUD.sharedView().updateProgressHUDViewText(font: font, message: message)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(iconType: .success)
        KRProgressHUD.sharedView().show()
        Thread.afterDelay(1.0) {
        	KRProgressHUD.dismiss()
        }
	}

    /**
     Showing HUD with information glyph. the HUD dismiss after 1 secound.
     You can appoint only the args which You want to appoint.
     (Args is reflected only this time.)

     - parameter progressHUDStyle:   KRProgressHUDStyle
     - parameter maskType:           KRProgressHUDMaskType
     - parameter font:           HUD's message font
     - parameter message:        HUD's message
     */
    public class func showInfo(
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type: KRProgressHUDMaskType? = nil,
            font: UIFont? = nil, message: String? = nil) {
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: nil)
        KRProgressHUD.sharedView().updateProgressHUDViewText(font: font, message: message)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(iconType: .info)
        KRProgressHUD.sharedView().show()

        Thread.afterDelay(1.0) {
        	KRProgressHUD.dismiss()
        }
    }

    /**
     Showing HUD with warning glyph. the HUD dismiss after 1 secound.
     You can appoint only the args which You want to appoint.
     (Args is reflected only this time.)

     - parameter progressHUDStyle:   KRProgressHUDStyle
     - parameter maskType:           KRProgressHUDMaskType
     - parameter font:           HUD's message font
     - parameter message:        HUD's message
     */
    public class func showWarning(
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type: KRProgressHUDMaskType? = nil,
            font: UIFont? = nil, message: String? = nil) {
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: nil)
        KRProgressHUD.sharedView().updateProgressHUDViewText(font: font, message: message)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(iconType: .warning)
        KRProgressHUD.sharedView().show()

        Thread.afterDelay(1.0) {
        	KRProgressHUD.dismiss()
        }
    }

    /**
     Showing HUD with error glyph. the HUD dismiss after 1 secound.
     You can appoint only the args which You want to appoint.
     (Args is reflected only this time.)

     - parameter progressHUDStyle:   KRProgressHUDStyle
     - parameter maskType:           KRProgressHUDMaskType
     - parameter font:           HUD's message font
     - parameter message:        HUD's message
     */
    public class func showError(
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type: KRProgressHUDMaskType? = nil,
            font: UIFont? = nil, message: String? = nil) {
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: nil)
        KRProgressHUD.sharedView().updateProgressHUDViewText(font: font, message: message)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(iconType: .error)
        KRProgressHUD.sharedView().show()

        Thread.afterDelay(1.0) {
        	KRProgressHUD.dismiss()
        }
    }

    /**
     Dismissing HUD.

     - parameter completion: handler when dismissed.

     - returns: No return value
     */
    public class func dismiss(_ completion: (()->())? = nil) {
        DispatchQueue.main.async { () -> Void in
            UIView.animate(withDuration: 0.5, animations: {
                KRProgressHUD.sharedView().window.alpha = 0
            }, completion: { _ in
                KRProgressHUD.sharedView().window.isHidden = true
                KRProgressHUD.sharedView().tmpWindow?.makeKey()
                KRProgressHUD.sharedView().activityIndicatorView.stopAnimating()
                KRProgressHUD.sharedView().progressHUDStyle = KRProgressHUD.sharedView().defaultStyle
                KRProgressHUD.sharedView().maskType = KRProgressHUD.sharedView().defaultMaskType
                KRProgressHUD.sharedView().activityIndicatorStyle = KRProgressHUD.sharedView().defaultActivityIndicatorStyle
                KRProgressHUD.sharedView().messageLabel.font = KRProgressHUD.sharedView().defaultMessageFont

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
        sharedView().messageLabel.text = text
    }
}


/**
 *  KRProgressHUD update style method --------------------------
 */
private extension KRProgressHUD {
    func show(_ completion: (()->())? = nil) {
        DispatchQueue.main.async { () -> Void in
            self.tmpWindow = UIApplication.shared.keyWindow
            self.window.alpha = 0
            self.window.makeKeyAndVisible()

            UIView.animate(withDuration: 0.5, animations: {
                KRProgressHUD.sharedView().window.alpha = 1
            }, completion: { _ in
                completion?()
            })
        }
    }

    func updateStyles(progressHUDStyle progressStyle: KRProgressHUDStyle?, maskType type: KRProgressHUDMaskType?, activityIndicatorStyle indicatorStyle: KRProgressHUDActivityIndicatorStyle?) {
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

    func updateProgressHUDViewText(font: UIFont?, message: String?, onlyText: Bool = false) {
        if onlyText {
            messageLabel.isHidden = false
            messageLabel.text = message ?? ""
            messageLabel.font = font ?? defaultMessageFont
            messageLabel.sizeToFit()

            let center = progressHUDView.center
            var frame = messageLabel.bounds
            frame.size = CGSize(width: frame.width + 40, height: frame.height + 20)
            progressHUDView.frame = frame
            progressHUDView.center = center
            messageLabel.center = CGPoint(x: frame.width/2, y: frame.height/2)
        } else if let text = message {
            let center = progressHUDView.center
            var frame = progressHUDView.frame
            frame.size = CGSize(width: 150, height: 110)
            progressHUDView.frame = frame
            progressHUDView.center = center

            iconView.center = CGPoint(x: 150/2, y: 40)

            messageLabel.isHidden = false
            messageLabel.text = text
            messageLabel.font = font ?? defaultMessageFont
        } else {
            let center = progressHUDView.center
            var frame = progressHUDView.frame
            frame.size = CGSize(width: 100, height: 100)
            progressHUDView.frame = frame
            progressHUDView.center = center

            iconView.center = CGPoint(x: 50, y: 50)

            messageLabel.isHidden = true
        }
    }

    func updateProgressHUDViewIcon(iconType: KRProgressHUDIconType? = nil, image: UIImage? = nil, onlyText: Bool = false) {
        drawView.subviews.forEach { $0.removeFromSuperview() }
        drawView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        drawView.isHidden = true
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()

        if onlyText { return }

        switch (iconType, image) {
        case (nil, nil):
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()

        case let (nil, image):
            drawView.isHidden = false
            let imageView = UIImageView(image: image)
            imageView.frame = KRProgressHUD.sharedView().drawView.bounds
            imageView.contentMode = .scaleAspectFit
            drawView.addSubview(imageView)

        case let (type, _):
            drawView.isHidden = false

            let pathLayer = CAShapeLayer()
            pathLayer.frame = drawView.layer.bounds
            pathLayer.lineWidth = 0
            pathLayer.path = type!.getPath()

            switch progressHUDStyle {
            case .black:  pathLayer.fillColor = UIColor.white.cgColor
            case .white:  pathLayer.fillColor = UIColor.black.cgColor
            default:  pathLayer.fillColor = type!.getColor()
            }

            drawView.layer.addSublayer(pathLayer)
        }
    }
}
