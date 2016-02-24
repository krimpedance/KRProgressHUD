//
//  KRActivityIndicatorViewStyle.swift
//  KRProgressIndicator
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit

/**
  KRActivityIndicatorView's style

  - Normal size(20x20)
    - **Black:**           the color is a gradation to `.lightGrayColor()` from `.blackColor()`.
    - **White:**           the color is a gradation to `UIColor(white: 0.7, alpha:1)` from `.whiteColor()`.
    - **Color(startColor, endColor):**   the color is a gradation to `endColor` from `startColor`.


  - Large size(50x50)
    - **LargeBlack:**   the color is same `.Black`.
    - **LargeWhite:**   the color is same `.White`.
    - **LargeColor(startColor, endColor):**   the color is same `.Color()`.
*/
public enum KRActivityIndicatorViewStyle {
    case Black, White, Color(UIColor, UIColor?)
    case LargeBlack, LargeWhite, LargeColor(UIColor, UIColor?)
}

extension KRActivityIndicatorViewStyle {
    mutating func sizeToLarge() {
        switch self {
        case .Black:  self = .LargeBlack
        case .White:  self = .LargeWhite
        case let .Color(sc, ec):  self = .LargeColor(sc, ec)
        default:  break
        }         
    }

    mutating func sizeToDefault() {
        switch self {
        case .LargeBlack:  self = .Black
        case .LargeWhite:  self = .White
        case let .LargeColor(sc, ec):  self = .Color(sc, ec)
        default:  break
        }         
    }

    var isLargeStyle: Bool {
        switch self {
        case .Black, .White, .Color(_, _):  return false
        case .LargeBlack, .LargeWhite, .LargeColor(_, _):  return true
        }
    }

    var startColor: UIColor {
        switch self {
        case .Black, .LargeBlack:  return UIColor.blackColor()
        case .White, .LargeWhite:  return UIColor.whiteColor()
        case let .Color(start, _):  return start
        case let .LargeColor(start, _):  return start
        }
    }

    var endColor: UIColor {
        switch self {
        case .Black, .LargeBlack:  return UIColor.lightGrayColor()
        case .White, .LargeWhite:  return UIColor(white: 0.7, alpha: 1)
        case let .Color(start, end):  return end ?? start
        case let .LargeColor(start, end):  return end ?? start
        }
    }

    func getGradientColors() -> [CGColor] {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 1, height: 70)
        gradient.colors = [startColor.CGColor, endColor.CGColor]

        var colors: [CGColor] = [startColor.CGColor]
        colors.appendContentsOf( // 中間色
            (1..<7).map {
                let point = CGPoint(x: 0, y: 10*CGFloat($0))
                return gradient.colorOfPoint(point).CGColor
            }
        )
        colors.append(endColor.CGColor)

        return colors
    }


    func getPaths() -> [CGPath] {
        if isLargeStyle {
            return KRActivityIndicatorPath.largePaths
        } else {
            return KRActivityIndicatorPath.paths
        }
    }
}


/**
 *  KRActivityIndicator Path ---------
 */
private struct KRActivityIndicatorPath {
    static let paths: [CGPath] = [
        UIBezierPath(ovalInRect: CGRect(x: 4.472, y: 0.209, width: 4.801, height: 4.801)).CGPath,
        UIBezierPath(ovalInRect: CGRect(x: 0.407, y: 5.154, width: 4.321, height: 4.321)).CGPath,
        UIBezierPath(ovalInRect: CGRect(x: 0.93, y: 11.765, width: 3.841, height: 3.841)).CGPath,
        UIBezierPath(ovalInRect: CGRect(x: 5.874, y: 16.31, width: 3.361, height: 3.361)).CGPath,
        UIBezierPath(ovalInRect: CGRect(x: 12.341, y: 16.126, width: 3.169, height: 3.169)).CGPath,
        UIBezierPath(ovalInRect: CGRect(x: 16.912, y: 11.668, width: 2.641, height: 2.641)).CGPath,
        UIBezierPath(ovalInRect: CGRect(x: 16.894, y: 5.573, width: 2.115, height: 2.115)).CGPath,
        UIBezierPath(ovalInRect: CGRect(x: 12.293, y: 1.374, width: 1.901, height: 1.901)).CGPath,
    ]

    static let largePaths: [CGPath] = [
        UIBezierPath(ovalInRect: CGRect(x: 12.013, y: 1.962, width: 8.336, height: 8.336)).CGPath,
        UIBezierPath(ovalInRect: CGRect(x: 1.668, y: 14.14, width: 7.502, height: 7.502)).CGPath,
        UIBezierPath(ovalInRect: CGRect(x: 2.792, y: 30.484, width: 6.668, height: 6.668)).CGPath,
        UIBezierPath(ovalInRect: CGRect(x: 14.968, y: 41.665, width: 5.835, height: 5.835)).CGPath,
        UIBezierPath(ovalInRect: CGRect(x: 31.311, y: 41.381, width: 5.001, height: 5.001)).CGPath,
        UIBezierPath(ovalInRect: CGRect(x: 42.496, y: 30.041, width: 4.168, height: 4.168)).CGPath,
        UIBezierPath(ovalInRect: CGRect(x: 42.209, y: 14.515, width: 3.338, height: 3.338)).CGPath,
        UIBezierPath(ovalInRect: CGRect(x: 30.857, y: 4.168, width: 2.501, height: 2.501)).CGPath,
    ]
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
        renderInContext(context!)

        let red:CGFloat = CGFloat(pixel[0])/255.0
        let green:CGFloat = CGFloat(pixel[1])/255.0
        let blue:CGFloat = CGFloat(pixel[2])/255.0
        let alpha:CGFloat = CGFloat(pixel[3])/255.0

        return UIColor(red:red, green: green, blue:blue, alpha:alpha)
    }
}