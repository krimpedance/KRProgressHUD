[English](./README.md)

# KRProgressHUD

[![Version](https://img.shields.io/cocoapods/v/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![License](https://img.shields.io/cocoapods/l/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![Platform](https://img.shields.io/cocoapods/p/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CI Status](http://img.shields.io/travis/krimpedance/KRProgressHUD.svg?style=flat)](https://travis-ci.org/krimpedance/KRProgressHUD)

`KRProgressHUD`は，Swiftでかかれた綺麗で使いやすいローディング画面を表示するライブラリです．

#### 特徴

- 丸いインジケータ
- カラーのカスタマイズ性

インジケータには[KRActivityIndicatorView](https://github.com/krimpedance/KRActivityIndicator)を使用しています．

<img src="./Images/styles.png" height=300>

## 必要環境
#### ver. 2.\*系 (現在のバージョン) 
- iOS 9.0+
- Xcode 8.0+
- Swift 3.\*

#### ver. 1.\*系(1.7.0以上)
- iOS 8.0+
- Xcode 8.0+
- Swift 2.3.\*

#### ver. 1.\*系(1.7.0未満)
- iOS 8.0+
- Xcode 7.\*
- Swift 2.2.\*

## デモ
`DEMO/`以下にあるサンプルプロジェクトから確認してください．

または，[Appetize.io](https://appetize.io/app/nw022juw0znkf1n5u6ynga5ntm?device=iphone5s&scale=75&orientation=portrait&osVersion=9.2)にてシュミレートしてください．

## インストール
KRProgressHUDは[CocoaPods](http://cocoapods.org)と[Carthage](https://github.com/Carthage/Carthage)で
インストールすることができます．

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

###### 注意 :
**このライブラリは同期通信のようなユーザの操作を止めて処理を行うときなどに使用してください**

**PullRefreshなど，他の場面で使用したい場合は，[KRActivityIndicatorView](https://github.com/krimpedance/KRActivityIndicator)を使用することをお勧めします**

　　
`KRProgressHUD`はシングルトンパターンで作られています．

まず，`KRProgressHUD`をインポートします．

GCDを使用した一番簡単な表示：
```Swift
KRProgressHUD.show()

let delay = DispatchTime.now() + 1
DispatchQueue.main.asyncAfter(deadline: delay) {
		KRProgressHUD.dismiss()
}
```

#### HUDの表示
HUDの表示は，幾つかの引数を指定して行うことができます．
この引数は，オプションであるため，指定したいものだけ追加することが可能です．
また，この時の指定は，その表示の時有効となります．

```Swift
// progressHUDStyle : HUDの背景色の指定
// maskType : HUDの後ろ側のビューの色
// activityIndicatorStyle : KRActivityIndicatorViewのスタイル
// message : インジケータと一緒に表示するテキスト
// image : インジケータの代わりに表示する画像
class func show(
    progressHUDStyle progressStyle :KRProgressHUDStyle? = nil,
    maskType type:KRProgressHUDMaskType? = nil,
    activityIndicatorStyle indicatorStyle :KRActivityIndicatorStyle? = nil,
    message :String? = nil,
    font :UIFont? = nil,
    image :UIImage? = nil,
    completion: (()->())? = nil
)

// 例
KRProgressHUD.show()
KRProgressHUD.show(message: "Loading...")
KRProgressHUD.show(progressHUDStyle: .Black, message: "Loading...")
```

#### HUDのメッセージの更新
パーセンテージの表示などのために，メッセージの更新メソッドがあります．
```Swift
class func update(text: String)

// 例
KRProgressHUD.update(text: "20%")
```

#### メッセージだけのHUDを表示
```Swift
	public class func showText(
            message: String, font: UIFont? = nil,
            centerPosition position: CGPoint? = nil,
            progressHUDStyle progressStyle: KRProgressHUDStyle? = nil,
            maskType type: KRProgressHUDMaskType? = nil)

// 例
KRProgressHUD.showText("セットアップが完了しました!")
```

#### HUDを閉じる
HUDを閉じるときは，以下を実行します．
```Swift
class func dismiss(_ completion: (()->())?)
```
HUDを閉じる前に，成功やエラーなどの情報をアイコン付きで表示することもできます．
(表示は1秒間)

```Swift
class func showSuccess()
class func showInfo()
class func showWarning()
class func showError()
```

## カスタマイズ
`KRProgressHUD`は，以下の設定が可能です．
```Swift
public class func set(maskType: KRProgressHUDMaskType)  // デフォルト: .black
public class func set(style: KRProgressHUDStyle)  // デフォルト: .white
public class func set(activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle)  // デフォルト: .black
public class func set(font: UIFont)  // デフォルト: ヒラギノ角ゴ W3 13px(ない場合はシステムフォント13px)
public class func set(centerPosition: CGPoint)  // デフォルト: デバイスの画面の中央
```
`KRActivityIndicatorView`のスタイルは[こちら](https://github.com/krimpedance/KRActivityIndicator/blob/master/README.md)を参考にしてください．

## ライブラリに関する質問等
バグや機能のリクエストがありましたら，気軽にコメントしてください．

## リリースノート
- 2.1.0 : テキストだけのHUDを表示する機能を追加．
          標準フォントをシステムフォントに変更しました．
- 2.0.0 : Swift3に対応

## ライセンス
KRProgressHUDはMITライセンスに準拠しています．詳しくは`LICENSE`ファイルをみてください．
