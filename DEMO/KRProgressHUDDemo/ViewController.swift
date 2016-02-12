//
//  ViewController.swift
//  KRProgressHUDDemo
//
//  Created by Ryunosuke Kirikihira on 2016/02/12.
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
    
    let colors :[UIColor] = [
        UIColor.redColor(),
        UIColor.greenColor(),
        UIColor.blueColor(),
        UIColor.orangeColor(),
        UIColor.yellowColor()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.switchColorPartsHidden(true)
    }
    
    
    func switchColorPartsHidden(hidden :Bool) {
        self.startColorLabel.hidden = hidden
        self.startColorControl.hidden = hidden
        self.endColorLabel.hidden = hidden
        self.endColorControl.hidden = hidden
    }
}


/**
 *  Button Action ---------------
 */
extension ViewController {
    @IBAction func showButtonTapped(sender: UIButton) {
        if self.messageControl.selectedSegmentIndex == 0 { KRProgressHUD.show() }
        else { KRProgressHUD.show(message: "Loading...") }
        
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            KRProgressHUD.dismiss()
        }
    }
    
    @IBAction func showSuccessButtonTapped(sender: UIButton) {
        if self.messageControl.selectedSegmentIndex == 0 { KRProgressHUD.showSuccess() }
        else { KRProgressHUD.showSuccess(message: "Success!") }
    }
    
    @IBAction func showInfoButtonTapped(sender: UIButton) {
        if self.messageControl.selectedSegmentIndex == 0 { KRProgressHUD.showInfo() }
        else { KRProgressHUD.showInfo(message: "Info") }
    }
    
    @IBAction func showWarningButtonTapped(sender: UIButton) {
        if self.messageControl.selectedSegmentIndex == 0 { KRProgressHUD.showWarning() }
        else { KRProgressHUD.showWarning(message: "Warning!") }
    }
    
    @IBAction func showErrorButtonTapped(sender: UIButton) {
        if self.messageControl.selectedSegmentIndex == 0 { KRProgressHUD.showError() }
        else { KRProgressHUD.showError(message: "Error...") }
    }
}


/**
 *  UISegmentedControl value change actions -----------------
 */
extension ViewController {
    @IBAction func changedMaskTypeControlValue(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 : KRProgressHUD.setDefaultMaskType(.Black)
        case 1 : KRProgressHUD.setDefaultMaskType(.White)
        case 2 : KRProgressHUD.setDefaultMaskType(.Clear)
        default : break
        }
    }
    
    @IBAction func changedProgressHUDStyleControlValue(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 : KRProgressHUD.setDefaultStyle(.White)
        case 1 : KRProgressHUD.setDefaultStyle(.Black)
        case 2 : KRProgressHUD.setDefaultStyle(.WhiteColor)
        case 3 : KRProgressHUD.setDefaultStyle(.BlackColor)
        default : break
        }
    }
    
    @IBAction func changedActivityIndicatorStyleControlValue(sender: UISegmentedControl) {
        self.switchColorPartsHidden(true)
        
        switch sender.selectedSegmentIndex {
        case 0 : KRProgressHUD.setDefaultActivityIndicatorStyle(.Black)
        case 1 : KRProgressHUD.setDefaultActivityIndicatorStyle(.White)
        case 2 :
            self.switchColorPartsHidden(false)
            let startColor = self.colors[self.startColorControl.selectedSegmentIndex]
            let endColor = self.colors[self.endColorControl.selectedSegmentIndex]
            KRProgressHUD.setDefaultActivityIndicatorStyle(.Color(startColor, endColor))
            
        default : break
        }
    }
    
    @IBAction func changedStartColorControlValue(sender: UISegmentedControl) {
        let startColor = self.colors[self.startColorControl.selectedSegmentIndex]
        let endColor = self.colors[self.endColorControl.selectedSegmentIndex]
        KRProgressHUD.setDefaultActivityIndicatorStyle(.Color(startColor, endColor))
    }
    
    @IBAction func changedEndColorControlValue(sender: UISegmentedControl) {
        let startColor = self.colors[self.startColorControl.selectedSegmentIndex]
        let endColor = self.colors[self.endColorControl.selectedSegmentIndex]
        KRProgressHUD.setDefaultActivityIndicatorStyle(.Color(startColor, endColor))
    }
    
}