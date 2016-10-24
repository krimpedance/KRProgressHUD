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
    @IBOutlet weak var startColorLabel: UILabel!
    @IBOutlet weak var startColorControl: UISegmentedControl!
    @IBOutlet weak var endColorLabel: UILabel!
    @IBOutlet weak var endColorControl: UISegmentedControl!

    let colors: [UIColor] = [
        UIColor.redColor(),
        UIColor.greenColor(),
        UIColor.blueColor(),
        UIColor.orangeColor(),
        UIColor.yellowColor()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        switchColorPartsHidden(true)
    }


    func switchColorPartsHidden(hidden: Bool) {
        startColorLabel.hidden = hidden
        startColorControl.hidden = hidden
        endColorLabel.hidden = hidden
        endColorControl.hidden = hidden
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
            KRProgressHUD.show(message: "Loading...")
        }

        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            KRProgressHUD.dismiss()
        }
    }

    @IBAction func showTextButtonTapped(withSender sender: UIButton) {
        KRProgressHUD.showText("Single line message :)")
    }

    @IBAction func showSuccessButtonTapped(withSender sender: UIButton) {
        if messageControl.selectedSegmentIndex == 0 {
            KRProgressHUD.showSuccess()
        } else {
            KRProgressHUD.showSuccess(message: "Success!")
        }
    }

    @IBAction func showInfoButtonTapped(withSender sender: UIButton) {
        if messageControl.selectedSegmentIndex == 0 {
            KRProgressHUD.showInfo()
        } else {
            KRProgressHUD.showInfo(message: "Info")
        }
    }

    @IBAction func showWarningButtonTapped(withSender sender: UIButton) {
        if messageControl.selectedSegmentIndex == 0 {
            KRProgressHUD.showWarning()
        } else {
            KRProgressHUD.showWarning(message: "Warning!")
        }
    }

    @IBAction func showErrorButtonTapped(withSender sender: UIButton) {
        if messageControl.selectedSegmentIndex == 0 {
            KRProgressHUD.showError()
        } else {
            KRProgressHUD.showError(message: "Error...")
        }
    }
}


/**
 *  UISegmentedControl value change actions -----------------
 */
extension ViewController {
    @IBAction func changedMaskTypeControlValue(withSender sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:  KRProgressHUD.setDefaultMaskType(type: .Black)
        case 1:  KRProgressHUD.setDefaultMaskType(type: .White)
        case 2:  KRProgressHUD.setDefaultMaskType(type: .Clear)
        default:  break
        }
    }

    @IBAction func changedProgressHUDStyleControlValue(withSender sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:  KRProgressHUD.setDefaultStyle(style: .White)
        case 1:  KRProgressHUD.setDefaultStyle(style: .Black)
        case 2:  KRProgressHUD.setDefaultStyle(style: .WhiteColor)
        case 3:  KRProgressHUD.setDefaultStyle(style: .BlackColor)
        default:  break
        }
    }

    @IBAction func changedActivityIndicatorStyleControlValue(withSender sender: UISegmentedControl) {
        switchColorPartsHidden(true)

        switch sender.selectedSegmentIndex {
        case 0:  KRProgressHUD.setDefaultActivityIndicatorStyle(style: .Black)
        case 1:  KRProgressHUD.setDefaultActivityIndicatorStyle(style: .White)
        case 2:
            switchColorPartsHidden(false)
            let startColor = colors[startColorControl.selectedSegmentIndex]
            let endColor = colors[endColorControl.selectedSegmentIndex]
            KRProgressHUD.setDefaultActivityIndicatorStyle(style: .Color(startColor, endColor))
        default:  break
        }
    }

    @IBAction func changedStartColorControlValue(withSender sender: UISegmentedControl) {
        let startColor = colors[startColorControl.selectedSegmentIndex]
        let endColor = colors[endColorControl.selectedSegmentIndex]
        KRProgressHUD.setDefaultActivityIndicatorStyle(style: .Color(startColor, endColor))
    }

    @IBAction func changedEndColorControlValue(withSender sender: UISegmentedControl) {
        let startColor = colors[startColorControl.selectedSegmentIndex]
        let endColor = colors[endColorControl.selectedSegmentIndex]
        KRProgressHUD.setDefaultActivityIndicatorStyle(style: .Color(startColor, endColor))
    }
}
