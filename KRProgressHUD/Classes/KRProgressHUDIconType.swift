//
//  KRProgressHUDIconType.swift
//  KRProgressHUD
//
//  Copyright © 2016 Krimpedance. All rights reserved.
//

import UIKit

enum KRProgressHUDIconType {
    case success, info, warning, error

    func getPath() -> CGPath {
        switch self {
        case .success:  return self.success
        case .info:  return self.info
        case .warning:  return self.warning
        case .error:  return self.error
        }
    }

    func getColor() -> CGColor {
        switch self {
        case .success:  return UIColor(red: 0.353, green: 0.620, blue: 0.431, alpha: 1).cgColor
        case .info:  return UIColor(red: 0.361, green: 0.522, blue: 0.800, alpha: 1).cgColor
        case .warning:  return UIColor(red: 0.918, green: 0.855, blue: 0.110, alpha: 1).cgColor
        case .error:  return UIColor(red: 0.718, green: 0.255, blue: 0.255, alpha: 1).cgColor
        }
    }
}

private extension KRProgressHUDIconType {
    var success: CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 19.886, y: 45.665))
        path.addLine(to: CGPoint(x: 0.644, y: 24.336))
        path.addLine(to: CGPoint(x: 4.356, y: 20.987))
        path.addLine(to: CGPoint(x: 19.712, y: 38.007))
        path.addLine(to: CGPoint(x: 45.569, y: 6.575))
        path.addLine(to: CGPoint(x: 49.431, y: 9.752))
        path.addLine(to: CGPoint(x: 19.886, y: 45.665))
        return path.cgPath
    }

    var info: CGPath {
        let path = UIBezierPath(ovalIn: CGRect(x: 21.078, y: 5, width: 7.843, height: 7.843))
        path.move(to: CGPoint(x: 28.137, y: 43.431))
        path.addLine(to: CGPoint(x: 28.137, y: 18.333))
        path.addLine(to: CGPoint(x: 18.725, y: 18.333))
        path.addLine(to: CGPoint(x: 18.725, y: 19.902))
        path.addLine(to: CGPoint(x: 21.863, y: 19.902))
        path.addLine(to: CGPoint(x: 21.863, y: 43.431))
        path.addLine(to: CGPoint(x: 18.725, y: 43.431))
        path.addLine(to: CGPoint(x: 18.725, y: 45))
        path.addLine(to: CGPoint(x: 31.275, y: 45))
        path.addLine(to: CGPoint(x: 31.275, y: 43.431))
        path.addLine(to: CGPoint(x: 28.137, y: 43.431))
        return path.cgPath
    }

    var warning: CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 29.821, y: 42.679))
        path.addCurve(to: CGPoint(x: 25, y: 47.5), controlPoint1: CGPoint(x: 29.821, y: 45.341), controlPoint2: CGPoint(x: 27.663, y: 47.5))
        path.addCurve(to: CGPoint(x: 20.179, y: 42.679), controlPoint1: CGPoint(x: 22.337, y: 47.5), controlPoint2: CGPoint(x: 20.179, y: 45.341))
        path.addCurve(to: CGPoint(x: 25, y: 37.857), controlPoint1: CGPoint(x: 20.179, y: 40.016), controlPoint2: CGPoint(x: 22.337, y: 37.857))
        path.addCurve(to: CGPoint(x: 29.821, y: 42.679), controlPoint1: CGPoint(x: 27.663, y: 37.857), controlPoint2: CGPoint(x: 29.821, y: 40.016))
        path.move(to: CGPoint(x: 24.5, y: 32.5))
        path.addCurve(to: CGPoint(x: 24.112, y: 31.211), controlPoint1: CGPoint(x: 24.5, y: 32.5), controlPoint2: CGPoint(x: 24.359, y: 32.031))
        path.addCurve(to: CGPoint(x: 23.698, y: 29.731), controlPoint1: CGPoint(x: 23.988, y: 30.801), controlPoint2: CGPoint(x: 23.849, y: 30.303))
        path.addCurve(to: CGPoint(x: 23.19, y: 27.813), controlPoint1: CGPoint(x: 23.548, y: 29.16), controlPoint2: CGPoint(x: 23.36, y: 28.516))
        path.addCurve(to: CGPoint(x: 22.046, y: 23.008), controlPoint1: CGPoint(x: 22.844, y: 26.406), controlPoint2: CGPoint(x: 22.435, y: 24.766))
        path.addCurve(to: CGPoint(x: 21, y: 17.5), controlPoint1: CGPoint(x: 21.658, y: 21.25), controlPoint2: CGPoint(x: 21.314, y: 19.375))
        path.addCurve(to: CGPoint(x: 20.309, y: 14.702), controlPoint1: CGPoint(x: 20.841, y: 16.563), controlPoint2: CGPoint(x: 20.578, y: 15.625))
        path.addCurve(to: CGPoint(x: 19.791, y: 11.992), controlPoint1: CGPoint(x: 20.043, y: 13.779), controlPoint2: CGPoint(x: 19.813, y: 12.871))
        path.addCurve(to: CGPoint(x: 20.145, y: 9.458), controlPoint1: CGPoint(x: 19.769, y: 11.113), controlPoint2: CGPoint(x: 19.906, y: 10.264))
        path.addCurve(to: CGPoint(x: 20.985, y: 7.188), controlPoint1: CGPoint(x: 20.361, y: 8.652), controlPoint2: CGPoint(x: 20.65, y: 7.891))
        path.addCurve(to: CGPoint(x: 22.07, y: 5.269), controlPoint1: CGPoint(x: 21.307, y: 6.484), controlPoint2: CGPoint(x: 21.69, y: 5.84))
        path.addCurve(to: CGPoint(x: 23.207, y: 3.789), controlPoint1: CGPoint(x: 22.437, y: 4.697), controlPoint2: CGPoint(x: 22.857, y: 4.199))
        path.addCurve(to: CGPoint(x: 24.124, y: 2.837), controlPoint1: CGPoint(x: 23.562, y: 3.379), controlPoint2: CGPoint(x: 23.878, y: 3.057))
        path.addCurve(to: CGPoint(x: 24.5, y: 2.5), controlPoint1: CGPoint(x: 24.369, y: 2.617), controlPoint2: CGPoint(x: 24.5, y: 2.5))
        path.addLine(to: CGPoint(x: 25.5, y: 2.5))
        path.addCurve(to: CGPoint(x: 25.876, y: 2.837), controlPoint1: CGPoint(x: 25.5, y: 2.5), controlPoint2: CGPoint(x: 25.631, y: 2.617))
        path.addCurve(to: CGPoint(x: 26.793, y: 3.789), controlPoint1: CGPoint(x: 26.122, y: 3.057), controlPoint2: CGPoint(x: 26.438, y: 3.379))
        path.addCurve(to: CGPoint(x: 27.93, y: 5.269), controlPoint1: CGPoint(x: 27.143, y: 4.199), controlPoint2: CGPoint(x: 27.563, y: 4.697))
        path.addCurve(to: CGPoint(x: 29.015, y: 7.188), controlPoint1: CGPoint(x: 28.31, y: 5.84), controlPoint2: CGPoint(x: 28.693, y: 6.484))
        path.addCurve(to: CGPoint(x: 29.855, y: 9.458), controlPoint1: CGPoint(x: 29.35, y: 7.891), controlPoint2: CGPoint(x: 29.639, y: 8.652))
        path.addCurve(to: CGPoint(x: 30.209, y: 11.992), controlPoint1: CGPoint(x: 30.094, y: 10.264), controlPoint2: CGPoint(x: 30.231, y: 11.113))
        path.addCurve(to: CGPoint(x: 29.691, y: 14.702), controlPoint1: CGPoint(x: 30.187, y: 12.871), controlPoint2: CGPoint(x: 29.957, y: 13.779))
        path.addCurve(to: CGPoint(x: 29, y: 17.5), controlPoint1: CGPoint(x: 29.422, y: 15.625), controlPoint2: CGPoint(x: 29.159, y: 16.563))
        path.addCurve(to: CGPoint(x: 27.954, y: 23.008), controlPoint1: CGPoint(x: 28.686, y: 19.375), controlPoint2: CGPoint(x: 28.342, y: 21.25))
        path.addCurve(to: CGPoint(x: 26.81, y: 27.813), controlPoint1: CGPoint(x: 27.565, y: 24.766), controlPoint2: CGPoint(x: 27.156, y: 26.406))
        path.addCurve(to: CGPoint(x: 26.302, y: 29.731), controlPoint1: CGPoint(x: 26.64, y: 28.516), controlPoint2: CGPoint(x: 26.452, y: 29.16))
        path.addCurve(to: CGPoint(x: 25.888, y: 31.211), controlPoint1: CGPoint(x: 26.151, y: 30.303), controlPoint2: CGPoint(x: 26.012, y: 30.801))
        path.addCurve(to: CGPoint(x: 25.5, y: 32.5), controlPoint1: CGPoint(x: 25.641, y: 32.031), controlPoint2: CGPoint(x: 25.5, y: 32.5))
        path.addLine(to: CGPoint(x: 24.5, y: 32.5))
        return path.cgPath
    }

    var error: CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 48.535, y: 8.535))
        path.addLine(to: CGPoint(x: 41.465, y: 1.465))
        path.addLine(to: CGPoint(x: 25, y: 17.93))
        path.addLine(to: CGPoint(x: 8.535, y: 1.465))
        path.addLine(to: CGPoint(x: 1.465, y: 8.535))
        path.addLine(to: CGPoint(x: 17.93, y: 25))
        path.addLine(to: CGPoint(x: 1.465, y: 41.465))
        path.addLine(to: CGPoint(x: 8.535, y: 48.535))
        path.addLine(to: CGPoint(x: 25, y: 32.07))
        path.addLine(to: CGPoint(x: 41.465, y: 48.535))
        path.addLine(to: CGPoint(x: 48.535, y: 41.465))
        path.addLine(to: CGPoint(x: 32.07, y: 25))
        path.addLine(to: CGPoint(x: 48.535, y: 8.535))
        return path.cgPath
    }
}
