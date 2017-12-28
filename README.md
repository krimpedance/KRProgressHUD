[日本語](./README_Ja.md)

# KRProgressHUD

[![Version](https://img.shields.io/cocoapods/v/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![License](https://img.shields.io/cocoapods/l/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![Platform](https://img.shields.io/cocoapods/p/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![Download](https://img.shields.io/cocoapods/dt/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CI Status](http://img.shields.io/travis/krimpedance/KRProgressHUD.svg?style=flat)](https://travis-ci.org/krimpedance/KRProgressHUD)

`KRProgressHUD` is a beautiful and easy-to-use progress HUD for your iOS written by Swift.

[KRActivityIndicatorView](https://github.com/krimpedance/KRActivityIndicatorView) is used for loading view.

<img src="./Resources/demo.gif" height=400>
<img src="./Resources/styles.png" width=400>

## Features
- Round indicator
- Indicator color can be customized

## Requirements
- iOS 8.0+
- Xcode 9.0+
- Swift 4.0+

## DEMO
To run the example project, clone the repo, and open `KRProgressHUDDemo.xcodeproj` from the DEMO directory.

or [appetize.io](https://appetize.io/app/nw022juw0znkf1n5u6ynga5ntm)

## Installation
KRProgressHUD is available through [CocoaPods](http://cocoapods.org) and [Carthage](https://github.com/Carthage/Carthage).
To install it, simply add the following line to your Podfile or Cartfile:

```ruby
# CocoaPods
pod "KRProgressHUD"
```

```ruby
# Carthage
github "Krimpedance/KRProgressHUD"
```

## Usage
(see sample Xcode project in /Demo)

#### Caution :
**Only use it if you absolutely need to perform a task before taking the user forward.**

**If you want to use it with other cases (ex. pull to refresh), I suggest using [KRActivityIndicatorView](https://github.com/krimpedance/KRActivityIndicator).**


`KRProgressHUD` is created as a singleton.

At first, import `KRProgressHUD` in your swift file.


Show simple HUD :
```Swift
KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
```

### Showing the HUD

```Swift
class func show(withMessage message:String? = nil, completion: CompleteHandler? = nil)

// Example
KRProgressHUD.show()
KRProgressHUD.show(withMessage: "Loading...")
KRProgressHUD.show(withMessage: "Loading...") {
   print("Complete handler")
}
```

**Show on ViewController**

If you want to show HUD on a view controller, set at `showOn()`.

(This is applied only once.)

```Swift
  KRProgressHUD.showOn(viewController).show()
```

Show a confirmation glyph before getting dismissed a little bit later.
(The display time is 1 sec in default. You can change the timing.)

```Swift
class func showSuccess()
class func showInfo()
class func showWarning()
class func showError()
class func showImage() // This can set custom image. (Max size is 50x50)
```

Show the HUD (only message)

```Swift
public class func showMessage(_ message: String)

// Example
KRProgressHUD.showMessage("Completed! \n Let's start!")
```

### Update the HUD's message
The HUD can update message.

```Swift
class func update(message: String)

// Example
KRProgressHUD.update(message: "20%")
```

### Dismissing the HUD
The HUD can be dismissed using:

```Swift
class func dismiss(_ completion: CompleteHandler? = nil)
```

### Customization
`KRProgressHUD.appearance()` can set default styles.

```Swift
class KRProgressHUDAppearance {
   /// Default style.
   public var style = KRProgressHUDStyle.white
   /// Default mask type.
   public var maskType = KRProgressHUDMaskType.black
   /// Default KRActivityIndicatorView style.
   public var activityIndicatorStyle = KRActivityIndicatorViewStyle.gradationColor(head: .black, tail: .lightGray)
   /// Default message label font.
   public var font = UIFont.systemFont(ofSize: 13)
   /// Default HUD center position.
   public var viewCenterPosition = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
   /// Default time to show HUD.
   public var deadlineTime = Double(1.0)
}
```

When you'd like to make styles reflected only in specific situation, use following methods.

```Swift
@discardableResult public class func set(style: KRProgressHUDStyle) -> KRProgressHUD.Type
@discardableResult public class func set(maskType: KRProgressHUDMaskType) -> KRProgressHUD.Type
@discardableResult public class func set(activityIndicatorViewStyle style: KRActivityIndicatorViewStyle) -> KRProgressHUD.Type
@discardableResult public class func set(font: UIFont) -> KRProgressHUD.Type
@discardableResult public class func set(centerPosition point: CGPoint) -> KRProgressHUD.Type
@discardableResult public class func set(deadlineTime time: Double) -> KRProgressHUD.Type


// Example
KRProgressHUD
   .set(style: .custom(background: .blue, text: .white, icon: nil))
   .set(maskType: .white)
   .show()
```

These `set()` setting can be reset by

```Swift
@discardableResult public class func resetStyles() -> KRProgressHUD.Type
```

## Contributing to this project
I'm seeking bug reports and feature requests.

## Release Note
+ 3.2.0 :
  - Can now customize mask color.
  - Fixed bug of HUD layout when the screen orientation changes.

+ 3.1.2 :
  - Fixed bug of custom small image.

## License
KRProgressHUD is available under the MIT license.

See the LICENSE file for more info.
