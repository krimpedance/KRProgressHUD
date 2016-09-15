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
        UIColor.red,
        UIColor.green,
        UIColor.blue,
        UIColor.orange,
        UIColor.yellow
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        switchColorPartsHidden(hidden: true)
    }


    func switchColorPartsHidden(hidden: Bool) {
        startColorLabel.isHidden = hidden
        startColorControl.isHidden = hidden
        endColorLabel.isHidden = hidden
        endColorControl.isHidden = hidden
    }
}


/**
 *  Button Action ---------------
 */
extension ViewController {
    @IBAction func showButtonTapped(_ sender: UIButton) {
        if messageControl.selectedSegmentIndex == 0 {
            KRProgressHUD.show()
        } else {
            KRProgressHUD.show(message: "Loading...")
        }

        let delay = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: delay) {
            KRProgressHUD.dismiss()
        }
    }

    @IBAction func showSuccessButtonTapped(_ sender: UIButton) {
        if messageControl.selectedSegmentIndex == 0 {
            KRProgressHUD.showSuccess()
        } else {
            KRProgressHUD.showSuccess(message: "Success!")
        }
    }

    @IBAction func showInfoButtonTapped(_ sender: UIButton) {
        if messageControl.selectedSegmentIndex == 0 {
            KRProgressHUD.showInfo()
        } else {
            KRProgressHUD.showInfo(message: "Info")
        }
    }

    @IBAction func showWarningButtonTapped(_ sender: UIButton) {
        if messageControl.selectedSegmentIndex == 0 {
            KRProgressHUD.showWarning()
        } else {
            KRProgressHUD.showWarning(message: "Warning!")
        }
    }

    @IBAction func showErrorButtonTapped(_ sender: UIButton) {
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
    @IBAction func changedMaskTypeControlValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:  KRProgressHUD.set(maskType: .black)
        case 1:  KRProgressHUD.set(maskType: .white)
        case 2:  KRProgressHUD.set(maskType: .clear)
        default:  break
        }
    }

    @IBAction func changedProgressHUDStyleControlValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:  KRProgressHUD.set(style: .white)
        case 1:  KRProgressHUD.set(style: .black)
        case 2:  KRProgressHUD.set(style: .whiteColor)
        case 3:  KRProgressHUD.set(style: .blackColor)
        default:  break
        }
    }

    @IBAction func changedActivityIndicatorStyleControlValue(_ sender: UISegmentedControl) {
        switchColorPartsHidden(hidden: true)

        switch sender.selectedSegmentIndex {
        case 0:  KRProgressHUD.set(activityIndicatorStyle: .black)
        case 1:  KRProgressHUD.set(activityIndicatorStyle: .white)
        case 2:
            switchColorPartsHidden(hidden: false)
            let startColor = colors[startColorControl.selectedSegmentIndex]
            let endColor = colors[endColorControl.selectedSegmentIndex]
            KRProgressHUD.set(activityIndicatorStyle: .color(startColor, endColor))
        default:  break
        }
    }

    @IBAction func changedStartColorControlValue(_ sender: UISegmentedControl) {
        let startColor = colors[startColorControl.selectedSegmentIndex]
        let endColor = colors[endColorControl.selectedSegmentIndex]
        KRProgressHUD.set(activityIndicatorStyle: .color(startColor, endColor))
    }

    @IBAction func changedEndColorControlValue(_ sender: UISegmentedControl) {
        let startColor = colors[startColorControl.selectedSegmentIndex]
        let endColor = colors[endColorControl.selectedSegmentIndex]
        KRProgressHUD.set(activityIndicatorStyle: .color(startColor, endColor))
    }
}
