//
//  KRProgressHUD.swift
//  KRProgressHUD
//
//  Created by Ryunosuke Kirikihira on 2016/02/02.
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
// -------------------------------------


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
            pathLayer.path = KRProgressHUDIconType.getPath(type: type!)

            switch progressHUDStyle {
                case .Black:  pathLayer.fillColor = UIColor.whiteColor().CGColor
                case .White:  pathLayer.fillColor = UIColor.blackColor().CGColor
            default:  pathLayer.fillColor = KRProgressHUDIconType.getColor(type: type!)
            }

            drawView.layer.addSublayer(pathLayer)
        }
    }
}


/**
 *  KRProgressHUD icon paths (50x50)
 */
private enum KRProgressHUDIconType {
    case Success, Info, Warning, Error

    private var success: CGPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 19.886, y: 45.665))
        path.addLineToPoint(CGPoint(x: 0.644, y: 24.336))
        path.addLineToPoint(CGPoint(x: 4.356, y: 20.987))
        path.addLineToPoint(CGPoint(x: 19.712, y: 38.007))
        path.addLineToPoint(CGPoint(x: 45.569, y: 6.575))
        path.addLineToPoint(CGPoint(x: 49.431, y: 9.752))
        path.addLineToPoint(CGPoint(x: 19.886, y: 45.665))
        return path.CGPath
    }

    private var info: CGPath {
        let path = UIBezierPath(ovalInRect: CGRect(x: 21.078, y: 5, width: 7.843, height: 7.843))
        path.moveToPoint(CGPoint(x: 28.137, y: 43.431))
        path.addLineToPoint(CGPoint(x: 28.137, y: 18.333))
        path.addLineToPoint(CGPoint(x: 18.725, y: 18.333))
        path.addLineToPoint(CGPoint(x: 18.725, y: 19.902))
        path.addLineToPoint(CGPoint(x: 21.863, y: 19.902))
        path.addLineToPoint(CGPoint(x: 21.863, y: 43.431))
        path.addLineToPoint(CGPoint(x: 18.725, y: 43.431))
        path.addLineToPoint(CGPoint(x: 18.725, y: 45))
        path.addLineToPoint(CGPoint(x: 31.275, y: 45))
        path.addLineToPoint(CGPoint(x: 31.275, y: 43.431))
        path.addLineToPoint(CGPoint(x: 28.137, y: 43.431))
        return path.CGPath
    }

    private var warning: CGPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 29.821, y: 42.679))
        path.addCurveToPoint(CGPoint(x: 25, y: 47.5), controlPoint1:CGPoint(x: 29.821, y: 45.341), controlPoint2:CGPoint(x: 27.663, y: 47.5))
        path.addCurveToPoint(CGPoint(x: 20.179, y: 42.679), controlPoint1:CGPoint(x: 22.337, y: 47.5), controlPoint2:CGPoint(x: 20.179, y: 45.341))
        path.addCurveToPoint(CGPoint(x: 25, y: 37.857), controlPoint1:CGPoint(x: 20.179, y: 40.016), controlPoint2:CGPoint(x: 22.337, y: 37.857))
        path.addCurveToPoint(CGPoint(x: 29.821, y: 42.679), controlPoint1:CGPoint(x: 27.663, y: 37.857), controlPoint2:CGPoint(x: 29.821, y: 40.016))
        path.moveToPoint(CGPoint(x: 24.5, y: 32.5))
        path.addCurveToPoint(CGPoint(x: 24.112, y: 31.211), controlPoint1:CGPoint(x: 24.5, y: 32.5), controlPoint2:CGPoint(x: 24.359, y: 32.031))
        path.addCurveToPoint(CGPoint(x: 23.698, y: 29.731), controlPoint1:CGPoint(x: 23.988, y: 30.801), controlPoint2:CGPoint(x: 23.849, y: 30.303))
        path.addCurveToPoint(CGPoint(x: 23.19, y: 27.813), controlPoint1:CGPoint(x: 23.548, y: 29.16), controlPoint2:CGPoint(x: 23.36, y: 28.516))
        path.addCurveToPoint(CGPoint(x: 22.046, y: 23.008), controlPoint1:CGPoint(x: 22.844, y: 26.406), controlPoint2:CGPoint(x: 22.435, y: 24.766))
        path.addCurveToPoint(CGPoint(x: 21, y: 17.5), controlPoint1:CGPoint(x: 21.658, y: 21.25), controlPoint2:CGPoint(x: 21.314, y: 19.375))
        path.addCurveToPoint(CGPoint(x: 20.309, y: 14.702), controlPoint1:CGPoint(x: 20.841, y: 16.563), controlPoint2:CGPoint(x: 20.578, y: 15.625))
        path.addCurveToPoint(CGPoint(x: 19.791, y: 11.992), controlPoint1:CGPoint(x: 20.043, y: 13.779), controlPoint2:CGPoint(x: 19.813, y: 12.871))
        path.addCurveToPoint(CGPoint(x: 20.145, y: 9.458), controlPoint1:CGPoint(x: 19.769, y: 11.113), controlPoint2:CGPoint(x: 19.906, y: 10.264))
        path.addCurveToPoint(CGPoint(x: 20.985, y: 7.188), controlPoint1:CGPoint(x: 20.361, y: 8.652), controlPoint2:CGPoint(x: 20.65, y: 7.891))
        path.addCurveToPoint(CGPoint(x: 22.07, y: 5.269), controlPoint1:CGPoint(x: 21.307, y: 6.484), controlPoint2:CGPoint(x: 21.69, y: 5.84))
        path.addCurveToPoint(CGPoint(x: 23.207, y: 3.789), controlPoint1:CGPoint(x: 22.437, y: 4.697), controlPoint2:CGPoint(x: 22.857, y: 4.199))
        path.addCurveToPoint(CGPoint(x: 24.124, y: 2.837), controlPoint1:CGPoint(x: 23.562, y: 3.379), controlPoint2:CGPoint(x: 23.878, y: 3.057))
        path.addCurveToPoint(CGPoint(x: 24.5, y: 2.5), controlPoint1:CGPoint(x: 24.369, y: 2.617), controlPoint2:CGPoint(x: 24.5, y: 2.5))
        path.addLineToPoint(CGPoint(x: 25.5, y: 2.5))
        path.addCurveToPoint(CGPoint(x: 25.876, y: 2.837), controlPoint1:CGPoint(x: 25.5, y: 2.5), controlPoint2:CGPoint(x: 25.631, y: 2.617))
        path.addCurveToPoint(CGPoint(x: 26.793, y: 3.789), controlPoint1:CGPoint(x: 26.122, y: 3.057), controlPoint2:CGPoint(x: 26.438, y: 3.379))
        path.addCurveToPoint(CGPoint(x: 27.93, y: 5.269), controlPoint1:CGPoint(x: 27.143, y: 4.199), controlPoint2:CGPoint(x: 27.563, y: 4.697))
        path.addCurveToPoint(CGPoint(x: 29.015, y: 7.188), controlPoint1:CGPoint(x: 28.31, y: 5.84), controlPoint2:CGPoint(x: 28.693, y: 6.484))
        path.addCurveToPoint(CGPoint(x: 29.855, y: 9.458), controlPoint1:CGPoint(x: 29.35, y: 7.891), controlPoint2:CGPoint(x: 29.639, y: 8.652))
        path.addCurveToPoint(CGPoint(x: 30.209, y: 11.992), controlPoint1:CGPoint(x: 30.094, y: 10.264), controlPoint2:CGPoint(x: 30.231, y: 11.113))
        path.addCurveToPoint(CGPoint(x: 29.691, y: 14.702), controlPoint1:CGPoint(x: 30.187, y: 12.871), controlPoint2:CGPoint(x: 29.957, y: 13.779))
        path.addCurveToPoint(CGPoint(x: 29, y: 17.5), controlPoint1:CGPoint(x: 29.422, y: 15.625), controlPoint2:CGPoint(x: 29.159, y: 16.563))
        path.addCurveToPoint(CGPoint(x: 27.954, y: 23.008), controlPoint1:CGPoint(x: 28.686, y: 19.375), controlPoint2:CGPoint(x: 28.342, y: 21.25))
        path.addCurveToPoint(CGPoint(x: 26.81, y: 27.813), controlPoint1:CGPoint(x: 27.565, y: 24.766), controlPoint2:CGPoint(x: 27.156, y: 26.406))
        path.addCurveToPoint(CGPoint(x: 26.302, y: 29.731), controlPoint1:CGPoint(x: 26.64, y: 28.516), controlPoint2:CGPoint(x: 26.452, y: 29.16))
        path.addCurveToPoint(CGPoint(x: 25.888, y: 31.211), controlPoint1:CGPoint(x: 26.151, y: 30.303), controlPoint2:CGPoint(x: 26.012, y: 30.801))
        path.addCurveToPoint(CGPoint(x: 25.5, y: 32.5), controlPoint1:CGPoint(x: 25.641, y: 32.031), controlPoint2:CGPoint(x: 25.5, y: 32.5))
        path.addLineToPoint(CGPoint(x: 24.5, y: 32.5))
        return path.CGPath
    }

    private var error: CGPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 48.535, y: 8.535))
        path.addLineToPoint(CGPoint(x: 41.465, y: 1.465))
        path.addLineToPoint(CGPoint(x: 25, y: 17.93))
        path.addLineToPoint(CGPoint(x: 8.535, y: 1.465))
        path.addLineToPoint(CGPoint(x: 1.465, y: 8.535))
        path.addLineToPoint(CGPoint(x: 17.93, y: 25))
        path.addLineToPoint(CGPoint(x: 1.465, y: 41.465))
        path.addLineToPoint(CGPoint(x: 8.535, y: 48.535))
        path.addLineToPoint(CGPoint(x: 25, y: 32.07))
        path.addLineToPoint(CGPoint(x: 41.465, y: 48.535))
        path.addLineToPoint(CGPoint(x: 48.535, y: 41.465))
        path.addLineToPoint(CGPoint(x: 32.07, y: 25))
        path.addLineToPoint(CGPoint(x: 48.535, y: 8.535))
        return path.CGPath
    }

    static func getPath(type type: KRProgressHUDIconType) -> CGPath {
        switch type {
        case .Success:  return type.success
        case .Info:  return type.info
        case .Warning:  return type.warning
        case .Error:  return type.error
        }
    }

    static func getColor(type type: KRProgressHUDIconType) -> CGColor {
        switch type {
        case .Success:  return UIColor(red: 0.353, green: 0.620, blue: 0.431, alpha: 1).CGColor
        case .Info:  return UIColor(red: 0.361, green: 0.522, blue: 0.800, alpha: 1).CGColor
        case .Warning:  return UIColor(red: 0.918, green: 0.855, blue: 0.110, alpha: 1).CGColor
        case .Error:  return UIColor(red: 0.718, green: 0.255, blue: 0.255, alpha: 1).CGColor
        }
    }
}