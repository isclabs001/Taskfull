//
//  UIViewExtensionToastWindow.swift
//  Taskfull
//
//  Created by IscIsc on 2017/05/24.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

/*
 *  トーストウィンドウ用　グローバル変数
 */
// デフォルト設定値
let HRToastDefaultDuration  =   2.0
let HRToastFadeDuration     =   0.5
let HRToastHorizontalMargin : CGFloat  =   10.0
let HRToastVerticalMargin   : CGFloat  =   10.0

let HRToastPositionDefault  =   "bottom"
let HRToastPositionTop      =   "top"
let HRToastPositionCenter   =   "center"

// 画像サイズ
let HRToastImageViewWidth :  CGFloat  = 80.0
let HRToastImageViewHeight:  CGFloat  = 80.0

// ラベルサイズ
let HRToastMaxWidth       :  CGFloat  = 0.8;      // 幅を80%とする
let HRToastMaxHeight      :  CGFloat  = 0.8;
let HRToastFontSize       :  CGFloat  = 16.0
let HRToastMaxTitleLines              = 0
let HRToastMaxMessageLines            = 0

// トーストウィンドウの影
let HRToastShadowOpacity  : CGFloat   = 0.8
let HRToastShadowRadius   : CGFloat   = 6.0
let HRToastShadowOffset   : CGSize    = CGSize(width: CGFloat(4.0), height: CGFloat(4.0))

// トーストウィンドウの形式
let HRToastOpacity        : CGFloat   = 0.8
let HRToastCornerRadius   : CGFloat   = 10.0

// トーストウィンドウで使用する作業変数
var HRToastActivityView: UnsafePointer<UIView>?    =   nil
var HRToastTimer: UnsafePointer<Timer>?          =   nil
var HRToastView: UnsafePointer<UIView>?            =   nil
var HRToastThemeColor : UnsafePointer<UIColor>?    =   nil
var HRToastTitleFontName: UnsafePointer<String>?   =   nil
var HRToastFontName: UnsafePointer<String>?        =   nil
var HRToastFontColor: UnsafePointer<UIColor>?      =   nil

/*
 *  トーストウィンドウ動作設定値
 */
let HRToastHidesOnTap       =   false
let HRToastDisplayShadow    =   true

///
/// UIView拡張クラス
///
extension UIView {
    
    ///
    ///　トーストウィンドウの背景色設定
    ///　- parameter color:色
    ///
    class func setToastWindowThemeColor(color: UIColor) {
        // トーストウィンドウの背景色設定
        objc_setAssociatedObject(self, &HRToastThemeColor, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    ///
    ///　トーストウィンドウの背景色取得
    ///　- returns:背景色
    ///
    class func getToastWindowThemeColor() -> UIColor {
        // トーストウィンドウの背景色取得
        var color = objc_getAssociatedObject(self, &HRToastThemeColor) as! UIColor?
        // 取得できなかった場合
        if nil == color {
            // 黒とする
            color = UIColor.black
            UIView.setToastWindowThemeColor(color: color!)
        }
        return color!
    }
    
    ///
    ///　トーストウィンドウのタイトルフォント名設定
    ///　- parameter fontName:フォント名
    ///
    class func setToastWindowTitleFontName(fontName: String) {
        // トーストウィンドウのタイトルフォント名設定
        objc_setAssociatedObject(self, &HRToastTitleFontName, fontName, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    ///
    ///　トーストウィンドウのタイトルフォント名取得
    ///　- returns:フォント名
    ///
    class func getToastWindowTitleFontName() -> String {
        // トーストウィンドウのタイトルフォント名取得
        var name = objc_getAssociatedObject(self, &HRToastTitleFontName) as! String?
        // 取得できなかった場合
        if nil == name {
            // システムフォントとする
            let font = UIFont.systemFont(ofSize: 12.0)
            name = font.fontName
            UIView.setToastWindowTitleFontName(fontName: name!)
        }
        
        return name!
    }
    
    ///
    ///　トーストウィンドウのフォント名設定
    ///　- parameter fontName:フォント名
    ///
    class func setToastWindowFontName(fontName: String) {
        // トーストウィンドウのフォント名設定
        objc_setAssociatedObject(self, &HRToastFontName, fontName, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    ///
    ///　トーストウィンドウのフォント名取得
    ///　- returns:フォント名
    ///
    class func getToastWindowFontName() -> String {
        // トーストウィンドウのタイトルフォント名取得
        var name = objc_getAssociatedObject(self, &HRToastFontName) as! String?
        // 取得できなかった場合
        if nil == name {
            // システムフォントとする
            let font = UIFont.systemFont(ofSize: 12.0)
            name = font.fontName
            UIView.setToastWindowFontName(fontName: name!)
        }
        
        return name!
    }
    
    ///
    ///　トーストウィンドウのフォント色設定
    ///　- parameter color:色
    ///
    class func setToastWindowFontColor(color: UIColor) {
        // トーストウィンドウのフォント色設定
        objc_setAssociatedObject(self, &HRToastFontColor, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    ///
    ///　トーストウィンドウのフォント色取得
    ///　- returns:フォント色
    ///
    class func getToastWindowFontColor() -> UIColor {
        // トーストウィンドウのフォント色取得
        var color = objc_getAssociatedObject(self, &HRToastFontColor) as! UIColor?
        // 取得できなかった場合
        if nil == color {
            // 白とする
            color = UIColor.white
            UIView.setToastWindowFontColor(color: color!)
        }
        
        return color!
    }
    
    ///
    ///　トーストウィンドウの作成（表示位置はbottom）
    ///　- parameter msg:メッセージ
    ///
    func makeToastWindow(message msg: String) {
        // トーストウィンドウの作成（表示秒数は２秒、表示位置はbottomとする）
        makeToastWindow(message: msg, duration: HRToastDefaultDuration, position: HRToastPositionDefault as AnyObject)
    }
    
    ///
    ///　トーストウィンドウの作成
    ///　- parameter msg:メッセージ
    ///　- parameter duration:トーストウィンドウを表示する秒数
    ///　- parameter position:表示位置　bottom、top、center
    ///
    func makeToastWindow(message msg: String, duration: Double, position: AnyObject) {
        // トーストウィンドウの作成
        let toast = self.viewForMessage(msg, title: nil, image: nil)
        showToastWindow(toast: toast!, duration: duration, position: position)
    }
    
    ///
    ///　トーストウィンドウの作成
    ///　- parameter msg:メッセージ
    ///　- parameter duration:トーストウィンドウを表示する秒数
    ///　- parameter position:表示位置　bottom、top、center
    ///　- parameter title:タイトル
    ///
    func makeToastWindow(message msg: String, duration: Double, position: AnyObject, title: String) {
        // トーストウィンドウの作成
        let toast = self.viewForMessage(msg, title: title, image: nil)
        showToastWindow(toast: toast!, duration: duration, position: position)
    }
    
    ///
    ///　トーストウィンドウの作成
    ///　- parameter msg:メッセージ
    ///　- parameter duration:トーストウィンドウを表示する秒数
    ///　- parameter position:表示位置　bottom、top、center
    ///　- parameter image:画像
    ///
    func makeToastWindow(message msg: String, duration: Double, position: AnyObject, image: UIImage) {
        // トーストウィンドウの作成
        let toast = self.viewForMessage(msg, title: nil, image: image)
        showToastWindow(toast: toast!, duration: duration, position: position)
    }
    
    ///
    ///　トーストウィンドウの作成
    ///　- parameter msg:メッセージ
    ///　- parameter duration:トーストウィンドウを表示する秒数
    ///　- parameter position:表示位置　bottom、top、center
    ///　- parameter title:タイトル
    ///　- parameter image:画像
    ///
    func makeToastWindow(message msg: String, duration: Double, position: AnyObject, title: String, image: UIImage) {
        // トーストウィンドウの作成
        let toast = self.viewForMessage(msg, title: title, image: image)
        showToastWindow(toast: toast!, duration: duration, position: position)
    }
    
    ///
    ///　トーストウィンドウの表示
    ///　- parameter toast:UIView
    ///
    func showToastWindow(toast: UIView) {
        // トーストウィンドウの表示
        showToastWindow(toast: toast, duration: HRToastDefaultDuration, position: HRToastPositionDefault as AnyObject)
    }
    
    ///
    ///　トーストウィンドウの表示
    ///　- parameter toast:UIView
    ///　- parameter msg:メッセージ
    ///　- parameter duration:トーストウィンドウを表示する秒数
    ///　- parameter position:表示位置　bottom、top、center
    ///
    fileprivate func showToastWindow(toast: UIView, duration: Double, position: AnyObject) {
        // トーストウィンドウが表示済の場合
        let existToast = objc_getAssociatedObject(self, &HRToastView) as! UIView?
        if nil != existToast {
            // トーストウィンドウを非表示にする
            if let timer: Timer = objc_getAssociatedObject(existToast, &HRToastTimer) as? Timer {
                timer.invalidate()
            }
            hideToastWindow(toast: existToast!, force: false);
        }
        
        // 中央位置を取得
        toast.center = centerPointForPosition(position, toast: toast)
        // 最初は透明に設定
        toast.alpha = 0.0
        
        // トーストウィンドウのタップが有効になっている場合
        if true == HRToastHidesOnTap {
            // タップイベントを設定する
            let tapRecognizer = UITapGestureRecognizer(target: toast, action: #selector(UIView.handleToastTapped(_:)))
            toast.addGestureRecognizer(tapRecognizer)
            toast.isUserInteractionEnabled = true;
            toast.isExclusiveTouch = true;
        }
        
        // トーストウィンドウを追加する
        addSubview(toast)
        objc_setAssociatedObject(self, &HRToastView, toast, .OBJC_ASSOCIATION_RETAIN)
        
        // 表示用のアニメーションを動作させる
        UIView.animate(withDuration: HRToastFadeDuration,
                       delay: 0.0, options: ([.curveEaseOut, .allowUserInteraction]),
                       animations: {
                        toast.alpha = 1.0
        },
                       // 表示完了後、トーストウィンドウを閉じる
            completion: { (finished: Bool) in
                let timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(UIView.toastWindowTimerDidFinish(_:)), userInfo: toast, repeats: false)
                objc_setAssociatedObject(toast, &HRToastTimer, timer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        })
    }
    
    ///
    ///　トーストウィンドウの非表示
    ///　- parameter toast:UIView
    ///
    func hideToastWindow(toast: UIView) {
        // トーストウィンドウを非表示にする
        hideToastWindow(toast: toast, force: false);
    }
    
    ///
    ///　トーストウィンドウの非表示
    ///　- parameter toast:UIView
    ///　- parameter force:非表示する際のアニメーションの有無
    ///
    func hideToastWindow(toast: UIView, force: Bool) {
        // 完了用の関数を定義する
        let completeClosure = { (finish: Bool) -> () in
            // トーストウィンドウを削除
            toast.removeFromSuperview()
            objc_setAssociatedObject(self, &HRToastTimer, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        // アニメーションしない場合
        if true == force {
            // 完了の関数を呼び出す
            completeClosure(true)
            
            // 上記以外の場合
        } else {
            // トーストウィンドウ閉じる際のアニメーション
            UIView.animate(withDuration: HRToastFadeDuration,
                           delay: 0.0,
                           options: ([.curveEaseIn, .beginFromCurrentState]),
                           animations: {
                            toast.alpha = 0.0
            },
                           // 完了の関数を呼び出す
                completion:completeClosure)
        }
    }
    
    ///
    ///　トーストウィンドウ表示時のタイマー完了処理
    ///　- parameter timer:Timer
    ///
    func toastWindowTimerDidFinish(_ timer: Timer) {
        // トーストウィンドウを閉じる
        hideToastWindow(toast: timer.userInfo as! UIView)
    }
    
    ///
    ///　トーストウィンドウタップ処理
    ///　- parameter recognizer:UITapGestureRecognizer
    ///
    func handleToastTapped(_ recognizer: UITapGestureRecognizer) {
        // タイマーを停止する
        let timer = objc_getAssociatedObject(self, &HRToastTimer) as! Timer
        timer.invalidate()
        
        // トーストウィンドウを閉じる
        hideToastWindow(toast: recognizer.view!)
    }
    
    ///
    ///　トーストウィンドウのセンター位置取得処理
    ///　- parameter recognizer:UITapGestureRecognizer
    ///　- returns:CGPoint:センター位置
    ///
    fileprivate func centerPointForPosition(_ position: AnyObject, toast: UIView) -> CGPoint {
        // 引数「position」がString型の場合
        if position is String {
            // トーストウィンドウのサイズを取得
            let toastSize = toast.bounds.size
            let viewSize  = self.bounds.size
            // 上に表示する場合
            if position.lowercased == HRToastPositionTop {
                // ウィンドウ上部の位置座標とする
                return CGPoint(x: viewSize.width/2, y: toastSize.height/2 + HRToastVerticalMargin)
                
                // 下に表示する場合
            } else if position.lowercased == HRToastPositionDefault {
                // ウィンドウ下部の位置座標とする
                return CGPoint(x: viewSize.width/2, y: viewSize.height - toastSize.height/2 - HRToastVerticalMargin)
                
                // 中央に表示する場合
            } else if position.lowercased == HRToastPositionCenter {
                // ウィンドウ中央の位置座標とする
                return CGPoint(x: viewSize.width/2, y: viewSize.height/2)
            }
            
            // 引数「position」がNSValue型の場合
        } else if position is NSValue {
            // そのままの値を使用する
            return position.cgPointValue
        }
        
        // 上記以外の場合、ウィンドウ下部の位置座標とする
        return self.centerPointForPosition(HRToastPositionDefault as AnyObject, toast: toast)
    }
    
    ///
    ///　トーストウィンドウの作成処理
    ///　- parameter msg:メッセージ
    ///　- parameter title:タイトル
    ///　- parameter image:画像
    ///　- returns:UIView
    ///
    fileprivate func viewForMessage(_ msg: String?, title: String?, image: UIImage?) -> UIView? {
        if msg == nil && title == nil && image == nil { return nil }
        
        var msgLabel: UILabel?
        var titleLabel: UILabel?
        var imageView: UIImageView?
        
        // トーストウィンドウを作成する
        let wrapperView = UIView()
        wrapperView.autoresizingMask = ([.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin])
        wrapperView.layer.cornerRadius = HRToastCornerRadius
        wrapperView.backgroundColor = UIView.getToastWindowThemeColor().withAlphaComponent(HRToastOpacity)
        
        // トーストウィンドウの影を有効にする場合
        if true == HRToastDisplayShadow {
            // トーストウィンドウの影を作成
            wrapperView.layer.shadowColor = UIView.getToastWindowThemeColor().cgColor
            wrapperView.layer.shadowOpacity = Float(HRToastShadowOpacity)
            wrapperView.layer.shadowRadius = HRToastShadowRadius
            wrapperView.layer.shadowOffset = HRToastShadowOffset
        }
        
        // トーストウィンドウにイメージを表示する場合
        if nil != image {
            // イメージを作成
            imageView = UIImageView(image: image)
            imageView!.contentMode = .scaleAspectFit
            imageView!.frame = CGRect(x: HRToastHorizontalMargin, y: HRToastVerticalMargin, width: CGFloat(HRToastImageViewWidth), height: CGFloat(HRToastImageViewHeight))
        }
        
        // イメージのサイズを取得
        var imageWidth: CGFloat, imageHeight: CGFloat, imageLeft: CGFloat
        if nil != imageView {
            imageWidth = imageView!.bounds.size.width
            imageHeight = imageView!.bounds.size.height
            imageLeft = HRToastHorizontalMargin
        } else {
            imageWidth  = 0.0; imageHeight = 0.0; imageLeft   = 0.0
        }
        
        // タイトルを表示する場合
        if nil != title {
            // タイトルを作成する
            titleLabel = UILabel()
            titleLabel!.numberOfLines = HRToastMaxTitleLines
            titleLabel!.font = UIFont(name: UIView.getToastWindowFontName(), size: HRToastFontSize)
            titleLabel!.textAlignment = .center
            titleLabel!.lineBreakMode = .byWordWrapping
            titleLabel!.textColor = UIView.getToastWindowFontColor()
            titleLabel!.backgroundColor = UIColor.clear
            titleLabel!.alpha = 1.0
            titleLabel!.text = title
            
            let maxSizeTitle = CGSize(width: (self.bounds.size.width * HRToastMaxWidth) - imageWidth, height: self.bounds.size.height * HRToastMaxHeight);
            let expectedHeight = title!.stringHeightWithFontSize(UIView.getToastWindowFontName(), fontSize: HRToastFontSize, width: maxSizeTitle.width)
            titleLabel!.frame = CGRect(x: 0.0, y: 0.0, width: maxSizeTitle.width, height: expectedHeight)
        }
        
        // メッセージを表示する場合
        if nil != msg {
            // メッセージを作成する
            msgLabel = UILabel();
            msgLabel!.numberOfLines = HRToastMaxMessageLines
            msgLabel!.font = UIFont(name: UIView.getToastWindowFontName(), size: HRToastFontSize)
            msgLabel!.lineBreakMode = .byWordWrapping
            msgLabel!.textAlignment = .center
            msgLabel!.textColor = UIView.getToastWindowFontColor()
            msgLabel!.backgroundColor = UIColor.clear
            msgLabel!.alpha = 1.0
            msgLabel!.text = msg
            
            let maxSizeMessage = CGSize(width: (self.bounds.size.width * HRToastMaxWidth) - imageWidth, height: self.bounds.size.height * HRToastMaxHeight)
            let expectedHeight = msg!.stringHeightWithFontSize(UIView.getToastWindowFontName(), fontSize: HRToastFontSize, width: maxSizeMessage.width)
            msgLabel!.frame = CGRect(x: 0.0, y: 0.0, width: maxSizeMessage.width, height: expectedHeight)
        }
        
        // タイトルのサイズを取得
        var titleWidth: CGFloat, titleHeight: CGFloat, titleTop: CGFloat, titleLeft: CGFloat
        if nil != titleLabel {
            titleWidth = titleLabel!.bounds.size.width
            titleHeight = titleLabel!.bounds.size.height
            titleTop = HRToastVerticalMargin
            titleLeft = imageLeft + imageWidth + HRToastHorizontalMargin
        } else {
            titleWidth = 0.0; titleHeight = 0.0; titleTop = 0.0; titleLeft = 0.0
        }
        
        // メッセージのサイズを取得
        var msgWidth: CGFloat, msgHeight: CGFloat, msgTop: CGFloat, msgLeft: CGFloat
        if nil != msgLabel {
            msgWidth = msgLabel!.bounds.size.width
            msgHeight = msgLabel!.bounds.size.height
            msgTop = titleTop + titleHeight + HRToastVerticalMargin
            msgLeft = imageLeft + imageWidth + HRToastHorizontalMargin
        } else {
            msgWidth = 0.0; msgHeight = 0.0; msgTop = 0.0; msgLeft = 0.0
        }
        
        // トーストメッセージのウィンドウサイズを取得
        let largerWidth = max(titleWidth, msgWidth)
        let largerLeft  = max(titleLeft, msgLeft)
        
        let wrapperWidth  = max(imageWidth + HRToastHorizontalMargin * 2, largerLeft + largerWidth + HRToastHorizontalMargin)
        let wrapperHeight = max(msgTop + msgHeight + HRToastVerticalMargin, imageHeight + HRToastVerticalMargin * 2)
        wrapperView.frame = CGRect(x: 0.0, y: 0.0, width: wrapperWidth, height: wrapperHeight)
        
        // タイトルが有効な場合
        if nil != titleLabel {
            // トーストウィンドウにタイトルを追加する
            titleLabel!.frame = CGRect(x: titleLeft, y: titleTop, width: titleWidth, height: titleHeight)
            wrapperView.addSubview(titleLabel!)
        }
        // メッセージが有効な場合
        if nil != msgLabel {
            // トーストウィンドウにメッセージを追加する
            msgLabel!.frame = CGRect(x: msgLeft, y: msgTop, width: msgWidth, height: msgHeight)
            wrapperView.addSubview(msgLabel!)
        }
        // イメージが有効な場合
        if nil != imageView {
            // トーストウィンドウにイメージを追加する
            wrapperView.addSubview(imageView!)
        }
        
        // トーストウィンドウを返す
        return wrapperView
    }
}
