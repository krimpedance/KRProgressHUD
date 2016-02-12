//
//  KRProgressHUD.swift
//  KRProgressHUD
//
//  Created by Ryunosuke Kirikihira on 2016/02/02.
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit

enum KRProgressHUDMaskType {
    case Clear, White, Black
}

enum KRProgressHUDStyle {
    case Black, White, BlackColor, WhiteColor
}

enum KRActivityIndicatorStyle {
    case Black, White, Color(UIColor, UIColor)
}


final class KRProgressHUD {
    private static let view = KRProgressHUD()
    class func sharedView() -> KRProgressHUD { return view }
   
    let window = UIWindow(frame: UIScreen.mainScreen().bounds)
    
    private let progressHUDView = UIView(frame: CGRectMake(0, 0, 100, 100))
    private let iconView = UIView(frame: CGRectMake(0,0,50,50))
    private let activityIndicatorView = KRActivityIndicatorView(position: CGPointZero, activityIndicatorStyle: .LargeBlack)
    private let drawView = UIView(frame: CGRectMake(0, 0, 50, 50))
    private let messageLabel = UILabel(frame: CGRectMake(0, 0, 150, 20))
 
    private var maskType :KRProgressHUDMaskType {
        willSet {
            switch newValue {
            case .Clear : self.window.backgroundColor = UIColor.clearColor()
            case .White : self.window.backgroundColor = UIColor(white: 1, alpha: 0.2)
            case .Black : self.window.backgroundColor = UIColor(white: 0, alpha: 0.2)
            }
        }
    }
    private var progressHUDStyle :KRProgressHUDStyle {
        willSet {
            switch newValue {
            case .Black, .BlackColor :
                self.progressHUDView.backgroundColor = UIColor.blackColor()
                self.messageLabel.textColor = UIColor.whiteColor()
            case .White, .WhiteColor :
                self.progressHUDView.backgroundColor = UIColor.whiteColor()
                self.messageLabel.textColor = UIColor.blackColor()
            }
        }
    }
    private var activityIndicatorStyle :KRActivityIndicatorStyle {
        willSet {
            switch newValue {
            case .Black : self.activityIndicatorView.activityIndicatorViewStyle = .LargeBlack
            case .White : self.activityIndicatorView.activityIndicatorViewStyle = .LargeWhite
            case let .Color(sc, ec) : self.activityIndicatorView.activityIndicatorViewStyle = .LargeColor(sc, ec)
            }
        }
    }
    
    private var defaultStyle :KRProgressHUDStyle = .White
    private var defaultMaskType :KRProgressHUDMaskType = .Black
    private var defaultActivityIndicatorStyle :KRActivityIndicatorStyle = .Black

    private init() {
        self.window.windowLevel = UIWindowLevelNormal
        self.window.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        self.maskType = .Black
        self.progressHUDStyle = .White
        self.activityIndicatorStyle = .Black
        
        self.configureProgressHUDView()
    }
    
    
    private func configureProgressHUDView() {
        let screenFrame = UIScreen.mainScreen().bounds
        self.progressHUDView.frame = CGRectMake(0, 0, 100, 100)
        self.progressHUDView.center = CGPointMake(screenFrame.width/2, screenFrame.height/2 - 100)
        self.progressHUDView.backgroundColor = UIColor.whiteColor()
        self.progressHUDView.layer.cornerRadius = 10
        self.window.addSubview(self.progressHUDView)
        
        self.iconView.backgroundColor = UIColor.clearColor()
        self.iconView.center = CGPointMake(50, 50)
        self.progressHUDView.addSubview(self.iconView)
        
        self.activityIndicatorView.hidden = false
        self.iconView.addSubview(self.activityIndicatorView)
        
        self.drawView.backgroundColor = UIColor.clearColor()
        self.drawView.hidden = true
        self.iconView.addSubview(self.drawView)

        self.messageLabel.center = CGPointMake(150/2, 90)
        self.messageLabel.backgroundColor = UIColor.clearColor()
        self.messageLabel.font = UIFont(name: "HiraginoSans-W3", size: 13) ?? UIFont.systemFontOfSize(13)
        self.messageLabel.textAlignment = .Center
        self.messageLabel.adjustsFontSizeToFitWidth = true
        self.messageLabel.minimumScaleFactor = 0.5
        self.messageLabel.text = nil
        self.messageLabel.hidden = true
        self.progressHUDView.addSubview(self.messageLabel)
    }
}


/**
 *  KRProgressHUD Setter --------------------------
 */
extension KRProgressHUD {
    class func setDefaultMaskType(type :KRProgressHUDMaskType) {
        KRProgressHUD.sharedView().maskType = type
        KRProgressHUD.sharedView().defaultMaskType = type
    }
    
    class func setDefaultStyle(style :KRProgressHUDStyle) {
        KRProgressHUD.sharedView().progressHUDStyle = style
        KRProgressHUD.sharedView().defaultStyle = KRProgressHUD.sharedView().progressHUDStyle
    }
    
    class func setDefaultActivityIndicatorStyle(style :KRActivityIndicatorStyle) {
        KRProgressHUD.sharedView().activityIndicatorStyle = style
        KRProgressHUD.sharedView().defaultActivityIndicatorStyle = style
    }
}
// -------------------------------------


/**
 *  KRProgressHUD Show & Dismiss --------------------------
 */
extension KRProgressHUD {
    class func show(
        progressHUDStyle progressStyle :KRProgressHUDStyle? = nil,
        maskType type:KRProgressHUDMaskType? = nil,
        activityIndicatorStyle indicatorStyle :KRActivityIndicatorStyle? = nil,
        message :String? = nil,
        image :UIImage? = nil
    ) {
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: indicatorStyle)
        KRProgressHUD.sharedView().updateProgressHUDViewText(message)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(image: image)
        
        KRProgressHUD.sharedView().show()
    }
    
    
    class func showSuccess(
        progressHUDStyle progressStyle :KRProgressHUDStyle? = nil,
        maskType type:KRProgressHUDMaskType? = nil,
        activityIndicatorStyle indicatorStyle :KRActivityIndicatorStyle? = nil,
        message :String? = nil
    ) {
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: indicatorStyle)
        KRProgressHUD.sharedView().updateProgressHUDViewText(message)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(iconType: .Success)
        
        KRProgressHUD.sharedView().show()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            sleep(1)
            KRProgressHUD.dismiss()
        }
    }
    
    class func showInfo(
        progressHUDStyle progressStyle :KRProgressHUDStyle? = nil,
        maskType type:KRProgressHUDMaskType? = nil,
        activityIndicatorStyle indicatorStyle :KRActivityIndicatorStyle? = nil,
        message :String? = nil
    ) {
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: indicatorStyle)
        KRProgressHUD.sharedView().updateProgressHUDViewText(message)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(iconType: .Info)
                                                             
        KRProgressHUD.sharedView().show()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            sleep(1)
            KRProgressHUD.dismiss()
        }
    }
    
    class func showWarning(
        progressHUDStyle progressStyle :KRProgressHUDStyle? = nil,
        maskType type:KRProgressHUDMaskType? = nil,
        activityIndicatorStyle indicatorStyle :KRActivityIndicatorStyle? = nil,
        message :String? = nil
    ) {
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: indicatorStyle)
        KRProgressHUD.sharedView().updateProgressHUDViewText(message)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(iconType: .Warning)
                                                             
        KRProgressHUD.sharedView().show()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            sleep(1)
            KRProgressHUD.dismiss()
        }
    }
    
    class func showError(
        progressHUDStyle progressStyle :KRProgressHUDStyle? = nil,
        maskType type:KRProgressHUDMaskType? = nil,
        activityIndicatorStyle indicatorStyle :KRActivityIndicatorStyle? = nil,
        message :String? = nil
    ) {
        KRProgressHUD.sharedView().updateStyles(progressHUDStyle: progressStyle, maskType: type, activityIndicatorStyle: indicatorStyle)
        KRProgressHUD.sharedView().updateProgressHUDViewText(message)
        KRProgressHUD.sharedView().updateProgressHUDViewIcon(iconType: .Error)
                                                             
        KRProgressHUD.sharedView().show()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            sleep(1)
            KRProgressHUD.dismiss()
        }
    }
    
    class func dismiss() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            UIView.animateWithDuration(0.5, animations: {
                KRProgressHUD.sharedView().window.alpha = 0
            }) { _ in
                KRProgressHUD.sharedView().window.hidden = true
                KRProgressHUD.sharedView().activityIndicatorView.stopAnimating()
             
                KRProgressHUD.sharedView().progressHUDStyle = KRProgressHUD.sharedView().defaultStyle
                KRProgressHUD.sharedView().maskType = KRProgressHUD.sharedView().defaultMaskType
                KRProgressHUD.sharedView().activityIndicatorStyle = KRProgressHUD.sharedView().defaultActivityIndicatorStyle
            }
        }
    }

    
    // private methods ------------------------------------------------------------
    private func show() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.window.alpha = 0
            self.window.makeKeyAndVisible()
            
            UIView.animateWithDuration(0.5) {
                KRProgressHUD.sharedView().window.alpha = 1
            }
        }
    }
    
    private func updateStyles(progressHUDStyle progressStyle :KRProgressHUDStyle?, maskType type:KRProgressHUDMaskType?, activityIndicatorStyle indicatorStyle :KRActivityIndicatorStyle?) {
        if let style = progressStyle { KRProgressHUD.sharedView().progressHUDStyle = style }
        if let type = type { KRProgressHUD.sharedView().maskType = type }
        if let style = indicatorStyle { KRProgressHUD.sharedView().activityIndicatorStyle = style }
    }
    
    private func updateProgressHUDViewText(message :String?) {
        if let text = message {
            let center = self.progressHUDView.center
            var frame = self.progressHUDView.frame
            frame.size = CGSizeMake(150, 110)
            self.progressHUDView.frame = frame
            self.progressHUDView.center = center
            
            self.iconView.center = CGPointMake(150/2, 40)
         
            self.messageLabel.hidden = false
            self.messageLabel.text = text
        }
        else {
            let center = self.progressHUDView.center
            var frame = self.progressHUDView.frame
            frame.size = CGSizeMake(100, 100)
            self.progressHUDView.frame = frame
            self.progressHUDView.center = center

            self.iconView.center = CGPointMake(50, 50)
         
            self.messageLabel.hidden = true
        }
    }
    
    private func updateProgressHUDViewIcon(iconType iconType :KRProgressHUDIconType? = nil, image :UIImage? = nil) {
        self.drawView.subviews.forEach{ $0.removeFromSuperview() }
        self.drawView.layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
        
        switch (iconType, image) {
        case (nil, nil) :
            self.drawView.hidden = true
            self.activityIndicatorView.hidden = false
            self.activityIndicatorView.startAnimating()
            
        case let (nil, image) :
            self.activityIndicatorView.hidden = true
            self.activityIndicatorView.stopAnimating()
            self.drawView.hidden = false
            
            let imageView = UIImageView(image: image)
            imageView.frame = KRProgressHUD.sharedView().drawView.bounds
            imageView.contentMode = .ScaleAspectFit
            self.drawView.addSubview(imageView)
            
        case let (type, _) :
            self.drawView.hidden = false
            self.activityIndicatorView.hidden = true
            self.activityIndicatorView.stopAnimating()
        
            let pathLayer = CAShapeLayer()
            pathLayer.frame = self.drawView.layer.bounds
            pathLayer.lineWidth = 0
            pathLayer.path = KRProgressHUDIconType.getPath(type!)
            
            switch self.progressHUDStyle {
                case .Black : pathLayer.fillColor = UIColor.whiteColor().CGColor
                case .White : pathLayer.fillColor = UIColor.blackColor().CGColor
                default : pathLayer.fillColor = KRProgressHUDIconType.getColor(type!)
            }
        
            self.drawView.layer.addSublayer(pathLayer)
        }
    }
    // ---------------------------------------------------------------------------------
}


/**
 *  KRProgressHUD icon paths (50x50)
 */
private enum KRProgressHUDIconType {
    case Success, Info, Warning, Error
    
    private var success :CGPath { get {
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(19.886, 45.665))
        path.addLineToPoint(CGPointMake(0.644, 24.336))
        path.addLineToPoint(CGPointMake(4.356, 20.987))
        path.addLineToPoint(CGPointMake(19.712, 38.007))
        path.addLineToPoint(CGPointMake(45.569, 6.575))
        path.addLineToPoint(CGPointMake(49.431, 9.752))
        path.addLineToPoint(CGPointMake(19.886, 45.665))
        return path.CGPath
    }}
    
    private var info :CGPath { get {
        let path = UIBezierPath(ovalInRect: CGRectMake(21.078, 5, 7.843, 7.843))
        path.moveToPoint(CGPointMake(28.137, 43.431))
        path.addLineToPoint(CGPointMake(28.137, 18.333))
        path.addLineToPoint(CGPointMake(18.725, 18.333))
        path.addLineToPoint(CGPointMake(18.725, 19.902))
        path.addLineToPoint(CGPointMake(21.863, 19.902))
        path.addLineToPoint(CGPointMake(21.863, 43.431))
        path.addLineToPoint(CGPointMake(18.725, 43.431))
        path.addLineToPoint(CGPointMake(18.725, 45))
        path.addLineToPoint(CGPointMake(31.275, 45))
        path.addLineToPoint(CGPointMake(31.275, 43.431))
        path.addLineToPoint(CGPointMake(28.137, 43.431))
        return path.CGPath
    }}
    
    private var warning :CGPath { get {
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(29.821, 42.679))
        path.addCurveToPoint(CGPointMake(25, 47.5), controlPoint1:CGPointMake(29.821, 45.341), controlPoint2:CGPointMake(27.663, 47.5))
        path.addCurveToPoint(CGPointMake(20.179, 42.679), controlPoint1:CGPointMake(22.337, 47.5), controlPoint2:CGPointMake(20.179, 45.341))
        path.addCurveToPoint(CGPointMake(25, 37.857), controlPoint1:CGPointMake(20.179, 40.016), controlPoint2:CGPointMake(22.337, 37.857))
        path.addCurveToPoint(CGPointMake(29.821, 42.679), controlPoint1:CGPointMake(27.663, 37.857), controlPoint2:CGPointMake(29.821, 40.016))
        path.moveToPoint(CGPointMake(24.5, 32.5))
        path.addCurveToPoint(CGPointMake(24.112, 31.211), controlPoint1:CGPointMake(24.5, 32.5), controlPoint2:CGPointMake(24.359, 32.031))
        path.addCurveToPoint(CGPointMake(23.698, 29.731), controlPoint1:CGPointMake(23.988, 30.801), controlPoint2:CGPointMake(23.849, 30.303))
        path.addCurveToPoint(CGPointMake(23.19, 27.813), controlPoint1:CGPointMake(23.548, 29.16), controlPoint2:CGPointMake(23.36, 28.516))
        path.addCurveToPoint(CGPointMake(22.046, 23.008), controlPoint1:CGPointMake(22.844, 26.406), controlPoint2:CGPointMake(22.435, 24.766))
        path.addCurveToPoint(CGPointMake(21, 17.5), controlPoint1:CGPointMake(21.658, 21.25), controlPoint2:CGPointMake(21.314, 19.375))
        path.addCurveToPoint(CGPointMake(20.309, 14.702), controlPoint1:CGPointMake(20.841, 16.563), controlPoint2:CGPointMake(20.578, 15.625))
        path.addCurveToPoint(CGPointMake(19.791, 11.992), controlPoint1:CGPointMake(20.043, 13.779), controlPoint2:CGPointMake(19.813, 12.871))
        path.addCurveToPoint(CGPointMake(20.145, 9.458), controlPoint1:CGPointMake(19.769, 11.113), controlPoint2:CGPointMake(19.906, 10.264))
        path.addCurveToPoint(CGPointMake(20.985, 7.188), controlPoint1:CGPointMake(20.361, 8.652), controlPoint2:CGPointMake(20.65, 7.891))
        path.addCurveToPoint(CGPointMake(22.07, 5.269), controlPoint1:CGPointMake(21.307, 6.484), controlPoint2:CGPointMake(21.69, 5.84))
        path.addCurveToPoint(CGPointMake(23.207, 3.789), controlPoint1:CGPointMake(22.437, 4.697), controlPoint2:CGPointMake(22.857, 4.199))
        path.addCurveToPoint(CGPointMake(24.124, 2.837), controlPoint1:CGPointMake(23.562, 3.379), controlPoint2:CGPointMake(23.878, 3.057))
        path.addCurveToPoint(CGPointMake(24.5, 2.5), controlPoint1:CGPointMake(24.369, 2.617), controlPoint2:CGPointMake(24.5, 2.5))
        path.addLineToPoint(CGPointMake(25.5, 2.5))
        path.addCurveToPoint(CGPointMake(25.876, 2.837), controlPoint1:CGPointMake(25.5, 2.5), controlPoint2:CGPointMake(25.631, 2.617))
        path.addCurveToPoint(CGPointMake(26.793, 3.789), controlPoint1:CGPointMake(26.122, 3.057), controlPoint2:CGPointMake(26.438, 3.379))
        path.addCurveToPoint(CGPointMake(27.93, 5.269), controlPoint1:CGPointMake(27.143, 4.199), controlPoint2:CGPointMake(27.563, 4.697))
        path.addCurveToPoint(CGPointMake(29.015, 7.188), controlPoint1:CGPointMake(28.31, 5.84), controlPoint2:CGPointMake(28.693, 6.484))
        path.addCurveToPoint(CGPointMake(29.855, 9.458), controlPoint1:CGPointMake(29.35, 7.891), controlPoint2:CGPointMake(29.639, 8.652))
        path.addCurveToPoint(CGPointMake(30.209, 11.992), controlPoint1:CGPointMake(30.094, 10.264), controlPoint2:CGPointMake(30.231, 11.113))
        path.addCurveToPoint(CGPointMake(29.691, 14.702), controlPoint1:CGPointMake(30.187, 12.871), controlPoint2:CGPointMake(29.957, 13.779))
        path.addCurveToPoint(CGPointMake(29, 17.5), controlPoint1:CGPointMake(29.422, 15.625), controlPoint2:CGPointMake(29.159, 16.563))
        path.addCurveToPoint(CGPointMake(27.954, 23.008), controlPoint1:CGPointMake(28.686, 19.375), controlPoint2:CGPointMake(28.342, 21.25))
        path.addCurveToPoint(CGPointMake(26.81, 27.813), controlPoint1:CGPointMake(27.565, 24.766), controlPoint2:CGPointMake(27.156, 26.406))
        path.addCurveToPoint(CGPointMake(26.302, 29.731), controlPoint1:CGPointMake(26.64, 28.516), controlPoint2:CGPointMake(26.452, 29.16))
        path.addCurveToPoint(CGPointMake(25.888, 31.211), controlPoint1:CGPointMake(26.151, 30.303), controlPoint2:CGPointMake(26.012, 30.801))
        path.addCurveToPoint(CGPointMake(25.5, 32.5), controlPoint1:CGPointMake(25.641, 32.031), controlPoint2:CGPointMake(25.5, 32.5))
        path.addLineToPoint(CGPointMake(24.5, 32.5))
        return path.CGPath
    }}
    
    private var error :CGPath { get {
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(48.535, 8.535))
        path.addLineToPoint(CGPointMake(41.465, 1.465))
        path.addLineToPoint(CGPointMake(25, 17.93))
        path.addLineToPoint(CGPointMake(8.535, 1.465))
        path.addLineToPoint(CGPointMake(1.465, 8.535))
        path.addLineToPoint(CGPointMake(17.93, 25))
        path.addLineToPoint(CGPointMake(1.465, 41.465))
        path.addLineToPoint(CGPointMake(8.535, 48.535))
        path.addLineToPoint(CGPointMake(25, 32.07))
        path.addLineToPoint(CGPointMake(41.465, 48.535))
        path.addLineToPoint(CGPointMake(48.535, 41.465))
        path.addLineToPoint(CGPointMake(32.07, 25))
        path.addLineToPoint(CGPointMake(48.535, 8.535))
        return path.CGPath
    }}
    
    static func getPath(type :KRProgressHUDIconType) -> CGPath {
        switch type {
        case .Success : return type.success
        case .Info : return type.info
        case .Warning : return type.warning
        case .Error : return type.error
        }
    }
    
    static func getColor(type :KRProgressHUDIconType) -> CGColor {
        switch type {
        case .Success : return UIColor(red: 0.353, green: 0.620, blue: 0.431, alpha: 1).CGColor
        case .Info : return UIColor(red: 0.361, green: 0.522, blue: 0.800, alpha: 1).CGColor
        case .Warning : return UIColor(red: 0.918, green: 0.855, blue: 0.110, alpha: 1).CGColor
        case .Error : return UIColor(red: 0.718, green: 0.255, blue: 0.255, alpha: 1).CGColor
        }
    }
}