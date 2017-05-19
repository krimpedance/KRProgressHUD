//
//  KRProgressHUDTests.swift
//  KRProgressHUDTests
//
//  Created by Ryunosuke Kirikihira on 2016/06/23.
//  Copyright © 2016年 Krimpedance. All rights reserved.
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
      KRProgressHUD.appearance().activityIndicatorStyle = .color(.yellow)
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
         .set(activityIndicatorViewStyle: .gradationColor(head: .red, tail: .blue))
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
   
   // MARK: - Center position --------------
   
   func testCenterPosition() {
      let centerPosition = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
      let image = UIImage()
      
      /**
       Initial position test
       */
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, centerPosition)
      
      /**
       Set appearance test
       */
      KRProgressHUD.appearance().viewCenterPosition = CGPoint(x: 100, y: 100)
      
      // loading
      KRProgressHUD.shared.updateLayouts(message: nil, iconType: nil, image: nil, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 100, y: 100))
      // loading with message
      KRProgressHUD.shared.updateLayouts(message: "test", iconType: nil, image: nil, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 100, y: 100))
      // icon
      KRProgressHUD.shared.updateLayouts(message: nil, iconType: .success, image: nil, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 100, y: 100))
      // icon with message
      KRProgressHUD.shared.updateLayouts(message: "test", iconType: .info, image: nil, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 100, y: 100))
      // image
      KRProgressHUD.shared.updateLayouts(message: nil, iconType: nil, image: image, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 100, y: 100))
      // image with message
      KRProgressHUD.shared.updateLayouts(message: "test", iconType: nil, image: image, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 100, y: 100))
      // test conly
      KRProgressHUD.shared.updateLayouts(message: "test", iconType: nil, image: nil, isOnlyText: true)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 100, y: 100))
      
      /**
       Set position test
       */
      KRProgressHUD.set(centerPosition: CGPoint(x: 50, y: 50))
      
      // loading
      KRProgressHUD.shared.updateLayouts(message: nil, iconType: nil, image: nil, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 50, y: 50))
      // loading with message
      KRProgressHUD.shared.updateLayouts(message: "test", iconType: nil, image: nil, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 50, y: 50))
      // icon
      KRProgressHUD.shared.updateLayouts(message: nil, iconType: .success, image: nil, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 50, y: 50))
      // icon with message
      KRProgressHUD.shared.updateLayouts(message: "test", iconType: .info, image: nil, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 50, y: 50))
      // image
      KRProgressHUD.shared.updateLayouts(message: nil, iconType: nil, image: image, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 50, y: 50))
      // image with message
      KRProgressHUD.shared.updateLayouts(message: "test", iconType: nil, image: image, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 50, y: 50))
      // test conly
      KRProgressHUD.shared.updateLayouts(message: "test", iconType: nil, image: nil, isOnlyText: true)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 50, y: 50))
      
      /**
       Reset position test
       */
      KRProgressHUD.resetStyles()
      
      // loading
      KRProgressHUD.shared.updateLayouts(message: nil, iconType: nil, image: nil, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 100, y: 100))
      // loading with message
      KRProgressHUD.shared.updateLayouts(message: "test", iconType: nil, image: nil, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 100, y: 100))
      // icon
      KRProgressHUD.shared.updateLayouts(message: nil, iconType: .success, image: nil, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 100, y: 100))
      // icon with message
      KRProgressHUD.shared.updateLayouts(message: "test", iconType: .info, image: nil, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 100, y: 100))
      // image
      KRProgressHUD.shared.updateLayouts(message: nil, iconType: nil, image: image, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 100, y: 100))
      // image with message
      KRProgressHUD.shared.updateLayouts(message: "test", iconType: nil, image: image, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 100, y: 100))
      // test conly
      KRProgressHUD.shared.updateLayouts(message: "test", iconType: nil, image: nil, isOnlyText: true)
      XCTAssertEqual(KRProgressHUD.shared.hudView.center, CGPoint(x: 100, y: 100))
   }
   
   // MARK: - Layout --------------
   
   func testLayouts() {
      let image = UIImage()
      let hudSize = CGSize(width: 150, height: 110)
      let simpleHUDSize = CGSize(width: 100, height: 100)
      let iconViewSize = CGSize(width: 50, height: 50)
      let iconViewCenter = CGPoint(x: hudSize.width/2, y: 40)
      let simpleHUDIconViewCenter = CGPoint(x: simpleHUDSize.width/2, y: 50)
      let messageLabelMargin = CGFloat(10)
      let messageLabelFrame = CGRect(x: messageLabelMargin,
                                     y: iconViewCenter.y + iconViewSize.height / 2 + messageLabelMargin,
                                     width: hudSize.width - messageLabelMargin * 2,
                                     height: 20)

      KRProgressHUD.shared.configureProgressHUDView()

      // Initial layout test
      XCTAssertEqual(KRProgressHUD.shared.hudView.frame.size, hudSize)
      XCTAssertEqual(KRProgressHUD.shared.iconView.isHidden, false)
      XCTAssertEqual(KRProgressHUD.shared.iconView.center, iconViewCenter)
      XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.isAnimating, false)
      XCTAssertEqual(KRProgressHUD.shared.iconDrawingView.isHidden, true)
      XCTAssertEqual(KRProgressHUD.shared.iconDrawingLayer.path, nil)
      XCTAssertEqual(KRProgressHUD.shared.imageView.image, nil)
      XCTAssertEqual(KRProgressHUD.shared.imageView.isHidden, true)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.frame, messageLabelFrame)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.numberOfLines, 1)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.isHidden, false)
      
      // loading
      KRProgressHUD.shared.updateLayouts(message: nil, iconType: nil, image: nil, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.frame.size, simpleHUDSize)
      XCTAssertEqual(KRProgressHUD.shared.iconView.isHidden, false)
      XCTAssertEqual(KRProgressHUD.shared.iconView.center, simpleHUDIconViewCenter)
      XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.isAnimating, true)
      XCTAssertEqual(KRProgressHUD.shared.iconDrawingView.isHidden, true)
      XCTAssertEqual(KRProgressHUD.shared.iconDrawingLayer.path, nil)
      XCTAssertEqual(KRProgressHUD.shared.imageView.image, nil)
      XCTAssertEqual(KRProgressHUD.shared.imageView.isHidden, true)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.frame, messageLabelFrame)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.numberOfLines, 1)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.isHidden, true)
      
      // loading with message
      KRProgressHUD.shared.updateLayouts(message: "test", iconType: nil, image: nil, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.frame.size, hudSize)
      XCTAssertEqual(KRProgressHUD.shared.iconView.isHidden, false)
      XCTAssertEqual(KRProgressHUD.shared.iconView.center, iconViewCenter)
      XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.isAnimating, true)
      XCTAssertEqual(KRProgressHUD.shared.iconDrawingView.isHidden, true)
      XCTAssertEqual(KRProgressHUD.shared.iconDrawingLayer.path, nil)
      XCTAssertEqual(KRProgressHUD.shared.imageView.image, nil)
      XCTAssertEqual(KRProgressHUD.shared.imageView.isHidden, true)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.frame, messageLabelFrame)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.numberOfLines, 1)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.isHidden, false)
      
      // icon
      KRProgressHUD.shared.updateLayouts(message: nil, iconType: .success, image: nil, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.frame.size, simpleHUDSize)
      XCTAssertEqual(KRProgressHUD.shared.iconView.isHidden, false)
      XCTAssertEqual(KRProgressHUD.shared.iconView.center, simpleHUDIconViewCenter)
      XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.isAnimating, false)
      XCTAssertEqual(KRProgressHUD.shared.iconDrawingView.isHidden, false)
      XCTAssert(KRProgressHUD.shared.iconDrawingLayer.path != nil)
      XCTAssertEqual(KRProgressHUD.shared.imageView.image, nil)
      XCTAssertEqual(KRProgressHUD.shared.imageView.isHidden, true)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.frame, messageLabelFrame)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.numberOfLines, 1)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.isHidden, true)
      
      // icon with message
      KRProgressHUD.shared.updateLayouts(message: "test", iconType: .info, image: nil, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.frame.size, hudSize)
      XCTAssertEqual(KRProgressHUD.shared.iconView.isHidden, false)
      XCTAssertEqual(KRProgressHUD.shared.iconView.center, iconViewCenter)
      XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.isAnimating, false)
      XCTAssertEqual(KRProgressHUD.shared.iconDrawingView.isHidden, false)
      XCTAssert(KRProgressHUD.shared.iconDrawingLayer.path != nil)
      XCTAssertEqual(KRProgressHUD.shared.imageView.image, nil)
      XCTAssertEqual(KRProgressHUD.shared.imageView.isHidden, true)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.frame, messageLabelFrame)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.numberOfLines, 1)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.isHidden, false)
      
      // image
      KRProgressHUD.shared.updateLayouts(message: nil, iconType: nil, image: image, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.frame.size, simpleHUDSize)
      XCTAssertEqual(KRProgressHUD.shared.iconView.isHidden, false)
      XCTAssertEqual(KRProgressHUD.shared.iconView.center, simpleHUDIconViewCenter)
      XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.isAnimating, false)
      XCTAssertEqual(KRProgressHUD.shared.iconDrawingView.isHidden, true)
      XCTAssertEqual(KRProgressHUD.shared.iconDrawingLayer.path, nil)
      XCTAssertEqual(KRProgressHUD.shared.imageView.image, image)
      XCTAssertEqual(KRProgressHUD.shared.imageView.isHidden, false)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.frame, messageLabelFrame)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.numberOfLines, 1)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.isHidden, true)
      
      // image with message
      KRProgressHUD.shared.updateLayouts(message: "test", iconType: nil, image: image, isOnlyText: false)
      XCTAssertEqual(KRProgressHUD.shared.hudView.frame.size, hudSize)
      XCTAssertEqual(KRProgressHUD.shared.iconView.isHidden, false)
      XCTAssertEqual(KRProgressHUD.shared.iconView.center, iconViewCenter)
      XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.isAnimating, false)
      XCTAssertEqual(KRProgressHUD.shared.iconDrawingView.isHidden, true)
      XCTAssertEqual(KRProgressHUD.shared.iconDrawingLayer.path, nil)
      XCTAssertEqual(KRProgressHUD.shared.imageView.image, image)
      XCTAssertEqual(KRProgressHUD.shared.imageView.isHidden, false)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.frame, messageLabelFrame)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.numberOfLines, 1)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.isHidden, false)
      
      // test conly
      KRProgressHUD.shared.updateLayouts(message: "test", iconType: nil, image: nil, isOnlyText: true)
      XCTAssertEqual(KRProgressHUD.shared.iconView.isHidden, true)
      XCTAssertEqual(KRProgressHUD.shared.iconView.center, iconViewCenter)
      XCTAssertEqual(KRProgressHUD.shared.activityIndicatorView.isAnimating, false)
      XCTAssertEqual(KRProgressHUD.shared.iconDrawingView.isHidden, true)
      XCTAssertEqual(KRProgressHUD.shared.iconDrawingLayer.path, nil)
      XCTAssertEqual(KRProgressHUD.shared.imageView.image, nil)
      XCTAssertEqual(KRProgressHUD.shared.imageView.isHidden, true)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.frame.origin, CGPoint(x: messageLabelMargin, y: messageLabelMargin))
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.numberOfLines, 0)
      XCTAssertEqual(KRProgressHUD.shared.messageLabel.isHidden, false)
   }
}
