//
//  KRProgressIndicator.swift
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit

public enum KRActivityIndicatorViewStyle {
    case Black, White, Color(UIColor, UIColor?)
    case LargeBlack, LargeWhite, LargeColor(UIColor, UIColor?)
}

@IBDesignable
public final class KRActivityIndicatorView :UIView {
    @IBInspectable private(set) var startColor :UIColor = UIColor.blackColor() {
        willSet {
            if self.largeStyle { self.activityIndicatorViewStyle = .LargeColor(newValue, self.endColor) }
            else { self.activityIndicatorViewStyle = .Color(newValue, self.endColor) }
        }
    }

    @IBInspectable private(set) var endColor :UIColor = UIColor.lightGrayColor() {
        willSet {
            if self.largeStyle { self.activityIndicatorViewStyle = .LargeColor(self.startColor, newValue) }
            else { self.activityIndicatorViewStyle = .Color(self.startColor, newValue) }
        }
    }

    @IBInspectable var largeStyle :Bool = false {
        willSet {
            if newValue { self.activityIndicatorViewStyle.sizeToLarge() }
            else { self.activityIndicatorViewStyle.sizeToDefault() }
        }
    }

    @IBInspectable var animating :Bool = true
    @IBInspectable var hidesWhenStopped :Bool = false


    private var animationLayer = CALayer()

    public var activityIndicatorViewStyle :KRActivityIndicatorViewStyle = .Black {
        didSet { self.setNeedsDisplay() }
    }

    public var isAnimating :Bool {
        if self.animationLayer.animationForKey("rotate") != nil { return true }
        else { return false }
    }


    /**
        Initializer --------------
    */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(frame :CGRect) {
        super.init(frame: frame)
    }

    public convenience init() {
        self.init(frame: CGRectMake(0, 0, 20, 20))
    }

    public convenience init(position :CGPoint, activityIndicatorStyle style :KRActivityIndicatorViewStyle) {
        if style.isLargeStyle {
            self.init(frame: CGRectMake(position.x, position.y, 50, 50))
        } else {
            self.init(frame: CGRectMake(position.x, position.y, 20, 20))
        }

        self.activityIndicatorViewStyle = style
        self.backgroundColor = UIColor.clearColor()
    }
    // -------------------------


    public override func drawRect(rect: CGRect) {
        // recreate AnimationLayer
        self.animationLayer.removeFromSuperlayer()
        self.animationLayer = CALayer()

        if self.activityIndicatorViewStyle.isLargeStyle {
            self.animationLayer.frame = CGRectMake(0, 0, 50, 50)
        } else {
            self.animationLayer.frame = CGRectMake(0, 0, 20, 20)
        }

        self.animationLayer.position = CGPointMake(self.layer.position.x-self.layer.frame.origin.x, self.layer.position.y-self.layer.frame.origin.y)
        self.layer.addSublayer(self.animationLayer)


        // draw ActivityIndicator
        let colors :[CGColor] = self.activityIndicatorViewStyle.getGradientColors()
        let paths :[CGPath] = self.activityIndicatorViewStyle.getPaths()

        for i in 0..<8 {
            let pathLayer = CAShapeLayer()
            pathLayer.frame = self.animationLayer.bounds
            pathLayer.fillColor = colors[i]
            pathLayer.lineWidth = 0
            pathLayer.path = paths[i]
            self.animationLayer.addSublayer(pathLayer)
        }

        // animation
        if self.animating { self.startAnimating() }
    }


    public func startAnimating() {
        if let _ = self.animationLayer.animationForKey("rotate") { return }

        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = M_PI*2
        animation.duration = 1.1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.removedOnCompletion = false
        animation.repeatCount = Float(NSIntegerMax)
        animation.fillMode = kCAFillModeForwards
        animation.autoreverses = false

        self.animationLayer.hidden = false
        self.animationLayer.addAnimation(animation, forKey: "rotate")
    }

    public func stopAnimating() {
        self.animationLayer.removeAllAnimations()

        if self.hidesWhenStopped {
            self.animationLayer.hidden = true
        }
    }
}


/**
 *  KRActivityIndicator Path ---------
 */
private struct KRActivityIndicator {
    static let paths :[CGPath] = [
        UIBezierPath(ovalInRect: CGRectMake(4.472, 0.209, 4.801, 4.801)).CGPath,
        UIBezierPath(ovalInRect: CGRectMake(0.407, 5.154, 4.321, 4.321)).CGPath,
        UIBezierPath(ovalInRect: CGRectMake(0.93, 11.765, 3.841, 3.841)).CGPath,
        UIBezierPath(ovalInRect: CGRectMake(5.874, 16.31, 3.361, 3.361)).CGPath,
        UIBezierPath(ovalInRect: CGRectMake(12.341, 16.126, 3.169, 3.169)).CGPath,
        UIBezierPath(ovalInRect: CGRectMake(16.912, 11.668, 2.641, 2.641)).CGPath,
        UIBezierPath(ovalInRect: CGRectMake(16.894, 5.573, 2.115, 2.115)).CGPath,
        UIBezierPath(ovalInRect: CGRectMake(12.293, 1.374, 1.901, 1.901)).CGPath,
    ]

    static let largePaths :[CGPath] = [
        UIBezierPath(ovalInRect: CGRectMake(12.013, 1.962, 8.336, 8.336)).CGPath,
        UIBezierPath(ovalInRect: CGRectMake(1.668, 14.14, 7.502, 7.502)).CGPath,
        UIBezierPath(ovalInRect: CGRectMake(2.792, 30.484, 6.668, 6.668)).CGPath,
        UIBezierPath(ovalInRect: CGRectMake(14.968, 41.665, 5.835, 5.835)).CGPath,
        UIBezierPath(ovalInRect: CGRectMake(31.311, 41.381, 5.001, 5.001)).CGPath,
        UIBezierPath(ovalInRect: CGRectMake(42.496, 30.041, 4.168, 4.168)).CGPath,
        UIBezierPath(ovalInRect: CGRectMake(42.209, 14.515, 3.338, 3.338)).CGPath,
        UIBezierPath(ovalInRect: CGRectMake(30.857, 4.168, 2.501, 2.501)).CGPath,
    ]
}


/**
 *  KRActivityIndicatorViewStyle private extensions-----------
 */
extension KRActivityIndicatorViewStyle {
    private mutating func sizeToLarge() {
        switch self {
            case .Black : self = .LargeBlack
            case .White : self = .LargeWhite
            case let .Color(sc, ec) : self = .LargeColor(sc, ec)
            default : break
        }         
    }

    private mutating func sizeToDefault() {
        switch self {
            case .LargeBlack : self = .Black
            case .LargeWhite : self = .White
            case let .LargeColor(sc, ec) : self = .Color(sc, ec)
            default : break
        }         
    }

    // privates --------------------
    private var isLargeStyle :Bool {
        switch self {
            case .Black, .White, .Color(_, _) : return false
            case .LargeBlack, .LargeWhite, .LargeColor(_, _) : return true
        }
    }

    private var startColor :UIColor {
        switch self {
            case .Black, .LargeBlack : return UIColor.blackColor()
            case .White, .LargeWhite : return UIColor.whiteColor()
            case let .Color(start, _) : return start
            case let .LargeColor(start, _) : return start
        }
    }

    private var endColor :UIColor {
        switch self {
            case .Black, .LargeBlack : return UIColor.lightGrayColor()
            case .White, .LargeWhite : return UIColor(white: 0.7, alpha: 1)
            case let .Color(start, end) : return end ?? start
            case let .LargeColor(start, end) : return end ?? start
        }
    }

    private func getGradientColors() -> [CGColor] {
        let gradient = CAGradientLayer()
        gradient.frame = CGRectMake(0, 0, 1, 70)
        gradient.colors = [self.startColor.CGColor, self.endColor.CGColor]

        var colors :[CGColor] = [self.startColor.CGColor]
        colors.appendContentsOf( // 中間色
            (1..<7).map {
                let point = CGPointMake(0, 10*CGFloat($0))
                return gradient.colorOfPoint(point).CGColor
            }
        )
        colors.append(self.endColor.CGColor)

        return colors
    }


    private func getPaths() -> [CGPath] {
        if self.isLargeStyle { return KRActivityIndicator.largePaths }
        else { return KRActivityIndicator.paths }
    }
}


/**
*   CAGradientLayer Extension ------------------------------
*/
private extension CAGradientLayer {
    func colorOfPoint(point:CGPoint)->UIColor {
        var pixel:[CUnsignedChar] = [0,0,0,0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmap = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        let context = CGBitmapContextCreate(&pixel, 1, 1, 8, 4, colorSpace, bitmap.rawValue)

        CGContextTranslateCTM(context, -point.x, -point.y)
        self.renderInContext(context!)

        let red:CGFloat = CGFloat(pixel[0])/255.0
        let green:CGFloat = CGFloat(pixel[1])/255.0
        let blue:CGFloat = CGFloat(pixel[2])/255.0
        let alpha:CGFloat = CGFloat(pixel[3])/255.0

        return UIColor(red:red, green: green, blue:blue, alpha:alpha)
    }
}