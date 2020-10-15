[English](./README.md)

<img src="https://github.com/krimpedance/Resources/blob/master/KRProgressHUD/logo.png" width="100%">

[![Version](https://img.shields.io/cocoapods/v/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![License](https://img.shields.io/cocoapods/l/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![Platform](https://img.shields.io/cocoapods/p/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![Download](https://img.shields.io/cocoapods/dt/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CI Status](http://img.shields.io/travis/krimpedance/KRProgressHUD.svg?style=flat)](https://travis-ci.org/krimpedance/KRProgressHUD)

`KRProgressHUD`は, Swiftで書かれた綺麗で使いやすいローディング画面を表示するライブラリです.

インジケータには[KRActivityIndicatorView](https://github.com/krimpedance/KRActivityIndicatorView)を使用しています.

<img src="https://github.com/krimpedance/Resources/blob/master/KRProgressHUD/demo.gif" height=400>
<img src="https://github.com/krimpedance/Resources/blob/master/KRProgressHUD/styles.png" width=400>

## 特徴
- 丸いインジケータ
- カラーのカスタマイズ性

## 必要環境
- iOS 9.0+
- Xcode 12.0+
- Swift 5.3+

## デモ
`DEMO/`以下にあるサンプルプロジェクトから確認してください.

または, [Appetize.io](https://appetize.io/app/nw022juw0znkf1n5u6ynga5ntm)にてシュミレートしてください.

## インストール
KRProgressHUDは[CocoaPods](http://cocoapods.org)と[Carthage](https://github.com/Carthage/Carthage)で
インストールすることができます.

```ruby
# Podfile
pod "KRProgressHUD"
```

```ruby
# Cartfile
github "Krimpedance/KRProgressHUD"
```

## 使い方
(`/Demo`以下のサンプルを見てみてください)

#### 注意 :
**このライブラリは同期通信のようなユーザの操作を止めて処理を行うときなどに使用してください**

**PullRefreshなど, 他の場面で使用したい場合は, [KRActivityIndicatorView](https://github.com/krimpedance/KRActivityIndicator)を使用することをお勧めします**


`KRProgressHUD`はシングルトンパターンで作られています.

まず, `KRProgressHUD`をインポートします.

GCDを使用した一番簡単な表示：
```Swift
KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
   KRProgressHUD.dismiss()
}
```

### HUDの表示

```Swift
class func show(withMessage message:String? = nil, completion: CompleteHandler? = nil)

// 例
KRProgressHUD.show()
KRProgressHUD.show(withMessage: "Loading...")
KRProgressHUD.show(withMessage: "Loading...") {
   print("Complete handler")
}
```

**ViewController上に表示**

もしViewController上にHUDを表示したいときは, `showOn()` で設定してください.

この設定は一度だけ適用されます.

```Swift
  KRProgressHUD.showOn(viewController).show()
```

HUDを閉じる前に, 成功やエラーなどの情報をアイコン付きで表示することもできます.
(表示は1秒間. 秒数は設定可能です.)

```Swift
class func showSuccess()
class func showInfo()
class func showWarning()
class func showError()
class func showImage() // 好きな画像を設定できます. (最大サイズは50x50です)
```

メッセージだけのHUDを表示

```Swift
public class func showMessage(_ message: String)

// 例
KRProgressHUD.showText("完了しました! \n 早速始めましょう!")
```

### HUDのメッセージの更新
パーセンテージの表示などのために, メッセージの更新メソッドがあります.

```Swift
class func update(text: String)

// 例
KRProgressHUD.update(text: "20%")
```

### HUDを閉じる
HUDを閉じるときは, 以下を実行します.

```Swift
class func dismiss(_ completion: CompleteHandler? = nil)
```

## カスタマイズ
`KRProgressHUD.appearance()` では, 標準のスタイルを設定できます.

```Swift
class KRProgressHUDAppearance {
   /// HUDのスタイル.
   public var style = KRProgressHUDStyle.white
   /// マスクタイプ
   public var maskType = KRProgressHUDMaskType.black
   /// ローディングインジケータのグラデーションカラー
    public var activityIndicatorColors = [UIColor]([.black, .lightGray])
   /// ラベルのフォント
   public var font = UIFont.systemFont(ofSize: 13)
   /// HUDのセンター位置
   public var viewCenterPosition = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
   /// HUDの表示時間.
    public var duration = Double(1.0)
}
```

特定の場面だけでスタイルを適用したいときは, 以下の関数を使用できます.

```Swift
@discardableResult public class func set(style: KRProgressHUDStyle) -> KRProgressHUD.Type
@discardableResult public class func set(maskType: KRProgressHUDMaskType) -> KRProgressHUD.Type
@discardableResult public class func set(activityIndicatorViewColors colors: [UIColor]) -> KRProgressHUD.Type
@discardableResult public class func set(font: UIFont) -> KRProgressHUD.Type
@discardableResult public class func set(centerPosition point: CGPoint) -> KRProgressHUD.Type
@discardableResult public class func set(duration: Double) -> KRProgressHUD.Type


// 例
KRProgressHUD
   .set(style: .custom(background: .blue, text: .white, icon: nil))
   .set(maskType: .white)
   .show()
```

`set()` で設定したスタイルは以下の関数でリセットできます.

```Swift
@discardableResult public class func resetStyles() -> KRProgressHUD.Type
```


## ライブラリに関する質問等
バグや機能のリクエストがありましたら, 気軽にコメントしてください.

## リリースノート
+ 3.4.7 :
  - iOS 11 以下をサポート

+ 3.4.6 :
  - Xcode 12 に対応.

## ライセンス
KRProgressHUDはMITライセンスに準拠しています.

詳しくは`LICENSE`ファイルをみてください.
