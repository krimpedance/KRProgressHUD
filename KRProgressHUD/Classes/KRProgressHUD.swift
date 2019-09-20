//
//  KRProgressHUD.swift
//  KRProgressHUD
//
//  Copyright © 2016 Krimpedance. All rights reserved.
//

import UIKit
import KRActivityIndicatorView

/// Type of KRProgressHUD's background view.
///
/// - clear: `UIColor.clear`.
/// - white: `UIColor(white: 1, alpho: 0.2)`.
/// - black: `UIColor(white: 0, alpho: 0.2)`. Default type.
/// - custom: You can set custom mask color.
public enum KRProgressHUDMaskType {
    case clear, white, black, custom(color: UIColor)

    var maskColor: UIColor {
        switch self {
        case .clear: return .clear
        case .white: return UIColor(white: 1, alpha: 0.2)
        case .black: return UIColor(white: 0, alpha: 0.2)
        case .custom(let color): return color
        }
    }
}

/// Style of KRProgressHUD
///
/// - white: HUD's backgroundColor is `.white`. HUD's text color is `.black`. Default style.
/// - black: HUD's backgroundColor is `.black`. HUD's text color is `.white`.
/// - custom: You can set custom color of HUD's background, text and glyph icon.
///           If you set nil to `icon`, it's shown in original color.
public enum KRProgressHUDStyle {
    case white
    case black
    case custom(background: UIColor, text: UIColor, icon: UIColor?)

    var backgroundColor: UIColor {
        switch self {
        case .white: return .white
        case .black: return .black
        case .custom(let style): return style.background
        }
    }

    var textColor: UIColor {
        switch self {
        case .white: return .black
        case .black: return .white
        case .custom(let style): return style.text
        }
    }

    var iconColor: UIColor? {
        switch self {
        case .custom(let style): return style.icon
        default: return nil
        }
    }
}

/// KRProgressHUD is a beautiful and easy-to-use progress HUD.
public final class KRProgressHUD {
    public typealias CompletionHandler = () -> Void

    public class KRProgressHUDAppearance {
        /// Default style.
        public var style = KRProgressHUDStyle.white
        /// Default mask type.
        public var maskType = KRProgressHUDMaskType.black
        /// Default KRActivityIndicatorView colors
        public var activityIndicatorColors = [UIColor]([.black, .lightGray])
        /// Default message label font.
        public var font = UIFont.systemFont(ofSize: 13)
        /// Default HUD center offset of y axis.
        public var viewOffset = CGFloat(0.0)
        /// Default duration to show HUD.
        public var duration = Double(1.0)

        @available(*, deprecated, message: "Use activityIndicatorColors")
        public var activityIndicatorStyle = KRActivityIndicatorViewStyle.gradationColor(head: .black, tail: .lightGray) {
            didSet { activityIndicatorColors = [activityIndicatorStyle.headColor, activityIndicatorStyle.tailColor] }
        }
        @available(*, renamed: "duration")
        public var deadline = Double(1.0) {
            didSet { duration = deadline }
        }

        fileprivate init() {}
    }

    static let shared = KRProgressHUD()

    let viewAppearance = KRProgressHUDAppearance()

    let window = UIWindow(frame: UIScreen.main.bounds)
    let hudViewController = KRProgressHUDViewController()

    let hudView = UIView()
    let iconView = UIView()
    let activityIndicatorView = KRActivityIndicatorView()
    let iconDrawingView = UIView()
    let iconDrawingLayer = CAShapeLayer()
    let imageView = UIImageView()
    let messageLabel = UILabel()

    var style: KRProgressHUDStyle?
    var maskType: KRProgressHUDMaskType?
    var activityIndicatorColors: [UIColor]?
    var font: UIFont?
    var viewOffset: CGFloat?
    var duration: Double?

    var hudViewCenterYConstraint: NSLayoutConstraint!
    var hudViewSideMarginConstraints = [NSLayoutConstraint]()
    var iconViewConstraints = [NSLayoutConstraint]()
    var messageLabelConstraints = [NSLayoutConstraint]()
    var messageLabelMinWidthConstraint: NSLayoutConstraint!

    var dismissHandler: DispatchWorkItem?
    weak var presentingViewController: UIViewController?

    /// This have whether HUD is indicated.
    public internal(set) static var isVisible = false

    private init() {
        configureProgressHUDView()
    }
}

// MARK: - Set styles --------------------------

extension KRProgressHUD {
    /// Returns the appearance proxy for the receiver.
    ///
    /// - Returns: The appearance proxy for the receiver.
    public static func appearance() -> KRProgressHUDAppearance {
        return shared.viewAppearance
    }

    /// Sets the HUD style.
    /// This value is cleared by `resetStyles()`.
    ///
    /// - Parameter style: KRProgressHUDStyle
    /// - Returns: KRProgressHUD.Type (discardable)
    @discardableResult public static func set(style: KRProgressHUDStyle) -> KRProgressHUD.Type {
        shared.style = style
        return KRProgressHUD.self
    }

    /// Sets the HUD mask type.
    /// This value is cleared by `resetStyles()`.
    ///
    /// - Parameter maskType: KRProgressHUDMaskType
    /// - Returns: KRProgressHUD.Type (discardable)
    @discardableResult public static func set(maskType: KRProgressHUDMaskType) -> KRProgressHUD.Type {
        shared.maskType = maskType
        return KRProgressHUD.self
    }

    /// Sets the KRActivityIndicatorView gradient colors.
    /// This value is cleared by `resetStyles()`.
    ///
    /// - Parameter colors: KRActivityIndicatorViewStyle
    /// - Returns: KRProgressHUD.Type (discardable)
    @discardableResult public static func set(activityIndicatorViewColors colors: [UIColor]) -> KRProgressHUD.Type {
        shared.activityIndicatorColors = colors
        return KRProgressHUD.self
    }

    /// Sets the HUD message label font.
    /// This value is cleared by `resetStyles()`.
    ///
    /// - Parameter font: The message label font.
    /// - Returns: KRProgressHUD.Type (discardable)
    @discardableResult public static func set(font: UIFont) -> KRProgressHUD.Type {
        shared.font = font
        return KRProgressHUD.self
    }

    /// Sets the HUD center offset of y axis.
    /// This value is cleared by `resetStyles()`.
    ///
    /// - Parameter offset: The HUD center offset of y axis.
    /// - Returns: KRProgressHUD.Type (discardable)
    @discardableResult public static func set(viewOffset offset: CGFloat) -> KRProgressHUD.Type {
        shared.viewOffset = offset
        return KRProgressHUD.self
    }

    /**

     This value is cleared by `resetStyles()`.

     - parameter time:

     - returns:
     */
    /// Sets duration to show HUD.
    ///
    /// This is used:
    /// - `showSuccess()`
    /// - `showInfo()`
    /// - `showWarning()`
    /// - `showError()`
    /// - `showImage()`
    /// - `showMessage()`
    ///
    /// - Parameter time: Deadline time.
    /// - Returns: KRProgressHUD.Type (discardable)
    @discardableResult public static func set(duration: Double) -> KRProgressHUD.Type {
        shared.duration = duration
        return KRProgressHUD.self
    }

    /// Resets the HUD styles.
    ///
    /// - Returns: KRProgressHUD.Type (discardable)
    @discardableResult public static func resetStyles() -> KRProgressHUD.Type {
        shared.style = nil
        shared.maskType = nil
        shared.activityIndicatorColors = nil
        shared.font = nil
        shared.viewOffset = nil
        shared.duration = nil
        return KRProgressHUD.self
    }

    /// Sets the view controller which presents HUD.
    /// This is applied only once.
    ///
    /// - Parameter viewController: Presenting view controller.
    /// - Returns: KRProgressHUD.Type
    public static func showOn(_ viewController: UIViewController) -> KRProgressHUD.Type {
        shared.presentingViewController = viewController
        return KRProgressHUD.self
    }

    @available(*, deprecated, message: "Use set(activityIndicatorViewColors:)")
    @discardableResult public static func set(activityIndicatorViewStyle style: KRActivityIndicatorViewStyle) -> KRProgressHUD.Type {
        shared.activityIndicatorColors = [style.headColor, style.tailColor]
        return KRProgressHUD.self
    }

    @available(*, renamed: "set(ducation:)")
    @discardableResult public static func set(deadline time: Double) -> KRProgressHUD.Type {
        shared.duration = time
        return KRProgressHUD.self
    }
}

// MARK: - Show, Update & Dismiss ------------

extension KRProgressHUD {
    /// Shows the HUD.
    /// You can appoint only the args which You want to appoint.
    ///
    /// - Parameters:
    ///   - message: HUD's message.
    ///   - completion: Handler when showing is completed.
    public static func show(withMessage message: String? = nil, completion: CompletionHandler? = nil) {
        shared.show(withMessage: message, isLoading: true, completion: completion)
    }

    /// Shows the HUD with success glyph.
    /// The HUD dismiss after `duration` secound.
    ///
    /// - Parameter message: HUD's message.
    public static func showSuccess(withMessage message: String? = nil) {
        shared.show(withMessage: message, iconType: .success)
    }

    /// Shows the HUD with information glyph.
    /// The HUD dismiss after `duration` secound.
    ///
    /// - Parameter message: HUD's message.
    public static func showInfo(withMessage message: String? = nil) {
        shared.show(withMessage: message, iconType: .info)
    }

    /// Shows the HUD with warning glyph.
    /// The HUD dismiss after `duration` secound.
    ///
    /// - Parameter message: HUD's message.
    public static func showWarning(withMessage message: String? = nil) {
        shared.show(withMessage: message, iconType: .warning)
    }

    /// Shows the HUD with error glyph.
    /// The HUD dismiss after `duration` secound.
    ///
    /// - Parameter message: HUD's message.
    public static func showError(withMessage message: String? = nil) {
        shared.show(withMessage: message, iconType: .error)
    }

    /// Shows the HUD with image.
    /// The HUD dismiss after `duration` secound.
    ///
    /// - Parameters:
    ///   - image: Image that display instead of activity indicator.
    ///   - size: Image size.
    ///   - message: HUD's message.
    public static func showImage(_ image: UIImage, size: CGSize? = nil, message: String? = nil) {
        shared.show(withMessage: message, image: image, imageSize: size)
    }

    /// Shows the message only HUD.
    /// The HUD dismiss after `duration` secound.
    ///
    /// - Parameter message: HUD's message.
    public static func showMessage(_ message: String) {
        shared.show(withMessage: message, isOnlyText: true)
    }

    /// Updates the HUD message.
    ///
    /// - Parameter message: Message.
    public static func update(message: String) {
        shared.messageLabel.text = message
    }

    /// Hides the HUD.
    ///
    /// - Parameter completion: Hide completion handler.
    public static func dismiss(_ completion: CompletionHandler? = nil) {
        shared.dismiss(completion: completion)
    }
}
