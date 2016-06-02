# KRProgressHUD

[![Version](https://img.shields.io/cocoapods/v/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![License](https://img.shields.io/cocoapods/l/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)
[![Platform](https://img.shields.io/cocoapods/p/KRProgressHUD.svg?style=flat)](http://cocoapods.org/pods/KRProgressHUD)

`KRProgressHUD`は，Swiftでかかれた綺麗で使いやすいローディング画面を表示するライブラリです．

[SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD)を参考にしており，

- 丸いインジケータ
- カラーのカスタマイズ性

を意識して作っています．
インジケータには[KRActivityIndicatorView](https://github.com/krimpedance/KRActivityIndicator)を使用しています．

<img src="./Images/styles.png" height=300>

## デモ
`DEMO/`以下にあるサンプルプロジェクトから確認してください．
実行前は，`pod install`を行ってください．

または，[Appetize.io](https://appetize.io/app/nw022juw0znkf1n5u6ynga5ntm?device=iphone5s&scale=75&orientation=portrait&osVersion=9.2)にてシュミレートしてください．

## インストール
KRProgressHUDは[CocoaPods](http://cocoapods.org)ライブラリです．
`Podfile`に以下を追記してください．

```ruby
pod "KRProgressHUD"
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

let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
dispatch_after(delay, dispatch_get_main_queue()) {
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
    image :UIImage? = nil
)

KRProgressHUD.show()
KRProgressHUD.show(message: "Loading...")
KRProgressHUD.show(progressHUDStyle: .Black, message: "Loading...")
```

#### HUDを閉じる
HUDを閉じるときは，以下を実行します．
```
class func dismiss()
```
HUDを閉じる前に，成功やエラーなどの情報をアイコン付きで表示することもできます．
(表示は1秒間)

```
class func showSuccess()
class func showInfo()
class func showWarning()
class func showError()
```

## カスタマイズ
`KRProgressHUD`は，以下の設定が可能です．
```
public class func setDefaultMaskType(type :KRProgressHUDMaskType)  // デフォルト: .Black
public class func setDefaultStyle(style :KRProgressHUDStyle)  // デフォルト: .White
public class func setDefaultActivityIndicatorStyle(style :KRActivityIndicatorStyle)  // デフォルト: .Black
public class func setDefaultFont(font :UIFont)  // デフォルト: ヒラギノ角ゴ W3 13px(ない場合はシステムフォント13px)
```
`KRActivityIndicatorView`のスタイルは[こちら](https://github.com/krimpedance/KRActivityIndicator/blob/master/README.md)を参考にしてください．

## ライブラリに関する質問等
バグや機能のリクエストがありましたら，気軽にコメントしてください．

## リリースノート
- 1.4.0 : メッセージラベルの更新機能を追加．
- 1.3.0 : 横画面に対応．
- 1.2.1 : アイコンがカラーリングされない問題を修正．
- 1.2.0 : ドキュメントコメントを追加．


## ライセンス
KRProgressHUDはMITライセンスに準拠しています．詳しくは`LICENSE`ファイルをみてください．
