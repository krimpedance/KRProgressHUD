//
//  ViewController.swift
//  KRProgressHUDDemo
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import UIKit
import KRProgressHUD
import KRActivityIndicatorView

class ViewController: UIViewController {

    @IBOutlet weak var messageControl: UISegmentedControl!
    @IBOutlet weak var headColorLabel: UILabel!
    @IBOutlet weak var headColorControl: UISegmentedControl!
    @IBOutlet weak var tailColorLabel: UILabel!
    @IBOutlet weak var tailColorControl: UISegmentedControl!

    let colors: [UIColor] = [.red, .green, .blue, .orange, .yellow]

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

// MARK: - Button action ---------------

extension ViewController {
    @IBAction func showButtonTapped(withSender sender: UIButton) {
        if messageControl.selectedSegmentIndex == 0 {
            KRProgressHUD.show {
                print("show() completion handler.")
            }
        } else {
            KRProgressHUD.show(withMessage: "Loading...")
        }

        let delay = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delay) {
            KRProgressHUD.dismiss {
                print("dismiss() completion handler.")
            }
        }
    }

    @IBAction func showTextButtonTapped(withSender sender: UIButton) {
        let rand = arc4random() % 10
        if rand > 2 {
            KRProgressHUD.showMessage("message only HUD :)\nThis can indicate multiline message.")
        } else {
            KRProgressHUD.showMessage("こ\nん\nに\nち\nは\n😃")
        }
    }

    @IBAction func showSuccessButtonTapped(withSender sender: UIButton) {
        KRProgressHUD.showSuccess(withMessage: messageControl.selectedSegmentIndex == 0 ? nil : "Success!")
    }

    @IBAction func showInfoButtonTapped(withSender sender: UIButton) {
        KRProgressHUD.showInfo(withMessage: messageControl.selectedSegmentIndex == 0 ? nil : "Info")
    }

    @IBAction func showWarningButtonTapped(withSender sender: UIButton) {
        KRProgressHUD.showWarning(withMessage: messageControl.selectedSegmentIndex == 0 ? nil : "Warning!")
    }

    @IBAction func showErrorButtonTapped(withSender sender: UIButton) {
        KRProgressHUD.showError(withMessage: messageControl.selectedSegmentIndex == 0 ? nil : "Error...")
    }

    @IBAction func showWithImageButtonTapped(withSender sender: UIButton) {
        let image = UIImage(named: "image.png")!
        KRProgressHUD.showImage(image, message: messageControl.selectedSegmentIndex == 0 ? nil : "Custom image")
    }
}

// MARK: - UISegmentedControl value change actions ---------------

extension ViewController {
    @IBAction func changedMaskTypeControlValue(withSender sender: UISegmentedControl) {
        let maskTypes: [KRProgressHUDMaskType] = [.black, .white, .clear]
        KRProgressHUD.set(maskType: maskTypes[sender.selectedSegmentIndex])
    }

    @IBAction func changedProgressHUDStyleControlValue(withSender sender: UISegmentedControl) {
        let styles: [KRProgressHUDStyle] = [.white, .black, .custom(background: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), text: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), icon: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1))]
        KRProgressHUD.set(style: styles[sender.selectedSegmentIndex])
    }

    @IBAction func changedActivityIndicatorStyleControlValue(withSender sender: UISegmentedControl) {
        let headColor = colors[headColorControl.selectedSegmentIndex]
        let tailColor = colors[tailColorControl.selectedSegmentIndex]
        let colorsList: [[UIColor]] = [
            [.black, .lightGray],
            [.white, UIColor(white: 0.7, alpha: 1)],
            [headColor, tailColor]
        ]
        KRProgressHUD.set(activityIndicatorViewColors: colorsList[sender.selectedSegmentIndex])
        switchColorPartsHidden(sender.selectedSegmentIndex != 2)
    }

    @IBAction func changedHeadColorControlValue(withSender sender: UISegmentedControl) {
        let headColor = colors[headColorControl.selectedSegmentIndex]
        let tailColor = colors[tailColorControl.selectedSegmentIndex]
        KRProgressHUD.set(activityIndicatorViewColors: [headColor, tailColor])
    }

    @IBAction func changedTailColorControlValue(withSender sender: UISegmentedControl) {
        let headColor = colors[headColorControl.selectedSegmentIndex]
        let tailColor = colors[tailColorControl.selectedSegmentIndex]
        KRProgressHUD.set(activityIndicatorViewColors: [headColor, tailColor])
    }
}
