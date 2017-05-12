//
//  ViewController.swift
//  KRProgressHUDDemo
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit
import KRProgressHUD

class ViewController: UIViewController {

   @IBOutlet weak var messageControl: UISegmentedControl!
   @IBOutlet weak var headColorLabel: UILabel!
   @IBOutlet weak var headColorControl: UISegmentedControl!
   @IBOutlet weak var tailColorLabel: UILabel!
   @IBOutlet weak var tailColorControl: UISegmentedControl!

   let colors: [UIColor] = [
      UIColor.red,
      UIColor.green,
      UIColor.blue,
      UIColor.orange,
      UIColor.yellow
   ]

   override func viewDidLoad() {
      super.viewDidLoad()
      switchColorPartsHidden(true)
   }

   func switchColorPartsHidden(_ hidden: Bool) {
      headColorLabel.isHidden = hidden
      headColorControl.isHidden = hidden
      tailColorLabel.isHidden = hidden
      tailColorControl.isHidden = hidden
   }
}

/**
 *  Button Action ---------------
 */
extension ViewController {
   @IBAction func showButtonTapped(withSender sender: UIButton) {
      if messageControl.selectedSegmentIndex == 0 {
         KRProgressHUD.show()
      } else {
         KRProgressHUD.show(withMessage: "Loading...")
      }

      let delay = DispatchTime.now() + 1
      DispatchQueue.main.asyncAfter(deadline: delay) {
         KRProgressHUD.dismiss()
      }
   }

   @IBAction func showTextButtonTapped(withSender sender: UIButton) {
      KRProgressHUD.showMessage("Single line message :)")
   }

   @IBAction func showSuccessButtonTapped(withSender sender: UIButton) {
      if messageControl.selectedSegmentIndex == 0 {
         KRProgressHUD.showSuccess()
      } else {
         KRProgressHUD.showSuccess(withMessage: "Success!")
      }
   }

   @IBAction func showInfoButtonTapped(withSender sender: UIButton) {
      if messageControl.selectedSegmentIndex == 0 {
         KRProgressHUD.showInfo()
      } else {
         KRProgressHUD.showInfo(withMessage: "Info")
      }
   }

   @IBAction func showWarningButtonTapped(withSender sender: UIButton) {
      if messageControl.selectedSegmentIndex == 0 {
         KRProgressHUD.showWarning()
      } else {
         KRProgressHUD.showWarning(withMessage: "Warning!")
      }
   }

   @IBAction func showErrorButtonTapped(withSender sender: UIButton) {
      if messageControl.selectedSegmentIndex == 0 {
         KRProgressHUD.showError()
      } else {
         KRProgressHUD.showError(withMessage: "Error...")
      }
   }

   @IBAction func showWithImageButtonTapped(withSender sender: UIButton) {
      if messageControl.selectedSegmentIndex == 0 {
         KRProgressHUD.showImage(UIImage(named: "image.png")!)
      } else {
         KRProgressHUD.showImage(UIImage(named: "image.png")!, message: "Custom image")
      }
   }
}

/**
 *  UISegmentedControl value change actions -----------------
 */
extension ViewController {
   @IBAction func changedMaskTypeControlValue(withSender sender: UISegmentedControl) {
      switch sender.selectedSegmentIndex {
      case 0:  KRProgressHUD.appearance().maskType = .black
      case 1:  KRProgressHUD.appearance().maskType = .white
      case 2:  KRProgressHUD.appearance().maskType = .clear
      default:  break
      }
   }

   @IBAction func changedProgressHUDStyleControlValue(withSender sender: UISegmentedControl) {
      switch sender.selectedSegmentIndex {
      case 0:  KRProgressHUD.appearance().style = .white
      case 1:  KRProgressHUD.appearance().style = .black
      case 2:  KRProgressHUD.appearance().style = .custom(background: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), text: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), icon: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1))
      default:  break
      }
   }

   @IBAction func changedActivityIndicatorStyleControlValue(withSender sender: UISegmentedControl) {
      switchColorPartsHidden(true)

      switch sender.selectedSegmentIndex {
      case 0:  KRProgressHUD.appearance().activityIndicatorStyle = .gradationColor(head: .black, tail: .lightGray)
      case 1:  KRProgressHUD.appearance().activityIndicatorStyle = .gradationColor(head: .white, tail: UIColor(white: 0.7, alpha: 1))
      case 2:
         switchColorPartsHidden(false)
         let headColor = colors[headColorControl.selectedSegmentIndex]
         let tailColor = colors[tailColorControl.selectedSegmentIndex]
         KRProgressHUD.appearance().activityIndicatorStyle = .gradationColor(head: headColor, tail: tailColor)

      default:  break
      }
   }

   @IBAction func changedHeadColorControlValue(withSender sender: UISegmentedControl) {
      let headColor = colors[headColorControl.selectedSegmentIndex]
      let tailColor = colors[tailColorControl.selectedSegmentIndex]
      KRProgressHUD.appearance().activityIndicatorStyle = .gradationColor(head: headColor, tail: tailColor)
   }

   @IBAction func changedTailColorControlValue(withSender sender: UISegmentedControl) {
      let headColor = colors[headColorControl.selectedSegmentIndex]
      let tailColor = colors[tailColorControl.selectedSegmentIndex]
      KRProgressHUD.appearance().activityIndicatorStyle = .gradationColor(head: headColor, tail: tailColor)
   }
}
