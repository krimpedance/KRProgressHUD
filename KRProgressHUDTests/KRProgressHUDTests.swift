//
//  KRProgressHUDTests.swift
//  KRProgressHUDTests
//
//  Copyright © 2016 Krimpedance. All rights reserved.
//

import XCTest
@testable import KRProgressHUD
import KRActivityIndicatorView

class KRProgressHUDTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Apply styles --------------

    func testApplyStyles() {
        // Initial style test
        XCTAssertEqual(KRProgressHUD.shared.hudView.backgroundColor, .white)
        XCTAssertEqual(KRProgressHUD.shared.messageLabel.textColor, .black)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingLayer.fillColor, nil)
        XCTAssertEqual(KRProgressHUD.shared.hudViewController.view.backgroundColor, UIColor(white: 0, alpha: 0.2))
        XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.headColor, .black)
        XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.tailColor, .lightGray)
        XCTAssertEqual(KRProgressHUD.shared.messageLabel.font, UIFont.systemFont(ofSize: 13))

        KRProgressHUD.appearance().style = .custom(background: .red, text: .white, icon: .green)
        KRProgressHUD.appearance().maskType = .clear
        KRProgressHUD.appearance().activityIndicatorColors = [.yellow]
        KRProgressHUD.appearance().font = UIFont.systemFont(ofSize: 20)

        KRProgressHUD.shared.applyStyles()

        // Set appearance style test
        XCTAssertEqual(KRProgressHUD.shared.hudView.backgroundColor, .red)
        XCTAssertEqual(KRProgressHUD.shared.messageLabel.textColor, .white)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingLayer.fillColor, UIColor.green.cgColor)
        XCTAssertEqual(KRProgressHUD.shared.hudViewController.view.backgroundColor, .clear)
        XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.headColor, .yellow)
        XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.tailColor, .yellow)
        XCTAssertEqual(KRProgressHUD.shared.messageLabel.font, UIFont.systemFont(ofSize: 20))

        KRProgressHUD
            .set(style: .custom(background: .red, text: .orange, icon: .black))
            .set(maskType: .white)
            .set(activityIndicatorViewColors: [.red, .blue])
            .set(font: UIFont.systemFont(ofSize: 10))
            .shared
            .applyStyles()

        // Set style test
        XCTAssertEqual(KRProgressHUD.shared.hudView.backgroundColor, .red)
        XCTAssertEqual(KRProgressHUD.shared.messageLabel.textColor, .orange)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingLayer.fillColor, UIColor.black.cgColor)
        XCTAssertEqual(KRProgressHUD.shared.hudViewController.view.backgroundColor, UIColor(white: 1, alpha: 0.2))
        XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.headColor, .red)
        XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.tailColor, .blue)
        XCTAssertEqual(KRProgressHUD.shared.messageLabel.font, UIFont.systemFont(ofSize: 10))

        KRProgressHUD
            .resetStyles()
            .shared
            .applyStyles()

        // Reset style test
        XCTAssertEqual(KRProgressHUD.shared.hudView.backgroundColor, .red)
        XCTAssertEqual(KRProgressHUD.shared.messageLabel.textColor, .white)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingLayer.fillColor, UIColor.green.cgColor)
        XCTAssertEqual(KRProgressHUD.shared.hudViewController.view.backgroundColor, .clear)
        XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.headColor, .yellow)
        XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.tailColor, .yellow)
        XCTAssertEqual(KRProgressHUD.shared.messageLabel.font, UIFont.systemFont(ofSize: 20))
    }

    // MARK: - Layout --------------

    func testLayouts() {
        let image = UIImage()

        KRProgressHUD.shared.configureProgressHUDView()

        // Initial layout test
        XCTAssertEqual(KRProgressHUD.shared.iconView.isHidden, false)
        XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.isAnimating, false)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingView.isHidden, true)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingLayer.path, nil)
        XCTAssertEqual(KRProgressHUD.shared.imageView.image, nil)
        XCTAssertEqual(KRProgressHUD.shared.imageView.isHidden, true)
        XCTAssertEqual(KRProgressHUD.shared.messageLabel.isHidden, false)
        
        // loading
        KRProgressHUD.shared.updateLayouts(message: nil, iconType: nil, image: nil, imageSize: nil, isOnlyText: false)
        XCTAssertEqual(KRProgressHUD.shared.iconView.isHidden, false)
        XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.isAnimating, true)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingView.isHidden, true)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingLayer.path, nil)
        XCTAssertEqual(KRProgressHUD.shared.imageView.image, nil)
        XCTAssertEqual(KRProgressHUD.shared.imageView.isHidden, true)
        XCTAssertEqual(KRProgressHUD.shared.messageLabel.isHidden, true)

        // loading with message
        KRProgressHUD.shared.updateLayouts(message: "test", iconType: nil, image: nil, imageSize: nil, isOnlyText: false)
        XCTAssertEqual(KRProgressHUD.shared.iconView.isHidden, false)
        XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.isAnimating, true)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingView.isHidden, true)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingLayer.path, nil)
        XCTAssertEqual(KRProgressHUD.shared.imageView.image, nil)
        XCTAssertEqual(KRProgressHUD.shared.imageView.isHidden, true)
        XCTAssertEqual(KRProgressHUD.shared.messageLabel.isHidden, false)

        // icon
        KRProgressHUD.shared.updateLayouts(message: nil, iconType: .success, image: nil, imageSize: nil, isOnlyText: false)
        XCTAssertEqual(KRProgressHUD.shared.iconView.isHidden, false)
        XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.isAnimating, false)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingView.isHidden, false)
        XCTAssert(KRProgressHUD.shared.iconDrawingLayer.path != nil)
        XCTAssertEqual(KRProgressHUD.shared.imageView.image, nil)
        XCTAssertEqual(KRProgressHUD.shared.imageView.isHidden, true)
        XCTAssertEqual(KRProgressHUD.shared.messageLabel.isHidden, true)

        // icon with message
        KRProgressHUD.shared.updateLayouts(message: "test", iconType: .info, image: nil, imageSize: nil, isOnlyText: false)
        XCTAssertEqual(KRProgressHUD.shared.iconView.isHidden, false)
        XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.isAnimating, false)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingView.isHidden, false)
        XCTAssert(KRProgressHUD.shared.iconDrawingLayer.path != nil)
        XCTAssertEqual(KRProgressHUD.shared.imageView.image, nil)
        XCTAssertEqual(KRProgressHUD.shared.imageView.isHidden, true)
        XCTAssertEqual(KRProgressHUD.shared.messageLabel.isHidden, false)

        // image
        KRProgressHUD.shared.updateLayouts(message: nil, iconType: nil, image: image, imageSize: nil, isOnlyText: false)
        XCTAssertEqual(KRProgressHUD.shared.iconView.isHidden, false)
        XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.isAnimating, false)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingView.isHidden, true)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingLayer.path, nil)
        XCTAssertEqual(KRProgressHUD.shared.imageView.image, image)
        XCTAssertEqual(KRProgressHUD.shared.imageView.isHidden, false)
        XCTAssertEqual(KRProgressHUD.shared.messageLabel.isHidden, true)

        // image with message
        KRProgressHUD.shared.updateLayouts(message: "test", iconType: nil, image: image, imageSize: nil, isOnlyText: false)
        XCTAssertEqual(KRProgressHUD.shared.iconView.isHidden, false)
        XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.isAnimating, false)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingView.isHidden, true)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingLayer.path, nil)
        XCTAssertEqual(KRProgressHUD.shared.imageView.image, image)
        XCTAssertEqual(KRProgressHUD.shared.imageView.isHidden, false)
        XCTAssertEqual(KRProgressHUD.shared.messageLabel.isHidden, false)

        // test conly
        KRProgressHUD.shared.updateLayouts(message: "test", iconType: nil, image: nil, imageSize: nil, isOnlyText: true)
        XCTAssertEqual(KRProgressHUD.shared.iconView.isHidden, true)
        XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.isAnimating, false)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingView.isHidden, true)
        XCTAssertEqual(KRProgressHUD.shared.iconDrawingLayer.path, nil)
        XCTAssertEqual(KRProgressHUD.shared.imageView.image, nil)
        XCTAssertEqual(KRProgressHUD.shared.imageView.isHidden, true)
        XCTAssertEqual(KRProgressHUD.shared.messageLabel.isHidden, false)
    }
}
