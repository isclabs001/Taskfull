//
//  UITaskImageButton.swift
//  Taskfull
//
//  Created by IscIsc on 2017/03/11.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

//
// タスク用イメージボタンクラス
//
@IBDesignable
class UITaskImageButton : UIView
{
    /**
     * 定数
     */
    // UITaskImageButtonの一意名
    static var UITaskImageButtonIdentifier : String = "UITaskImageButton";
    
    // アニメーションレイヤーの一意名
    static var AnimationLayerIdentifier : String = "AnimationLayerIdentifier";
    
    // タイトル切り替えのインターバルタイマー
    static var IntervalForTitleTimer : Double = 5.0;
    
    // ラベルのマージン
    static var LABEL_MARGIN : CGFloat = 6.0;
    // ラベルの行数
    static var LABEL_ROWS : CGFloat = 2.0;

    // 表示ラベルインデックス　タイトル
    static var DISPLAY_LABEL_TITLE : Int = 0;
    // 表示ラベルインデックス　タスク完了日
    static var DISPLAY_LABEL_DATE : Int = 1;
    // 表示ラベルインデックス　メモ
    static var DISPLAY_LABEL_MEMO : Int = 2;
    
    /**
     * 変数
     */
    // ラベル用　タイマー
    weak var timLabel: Timer?
    // ラベル用　現在表示中のラベル
    fileprivate var intCurrentLabel: Int = 0
    
    /**
     * コントロールOutlet変数
     */
    // ラベル
    @IBOutlet weak var txtLabel: UILabel!
    
    // イメージボタン
    @IBOutlet weak var btnImage: UICircleImageButton!
    
    /**
     * プロパティ
     */
    // ラベルタイトル文字列
    @IBInspectable var labelTitle: String = StringUtility.EMPTY {
        didSet{
            self.txtLabel.text = labelTitle
            self.intCurrentLabel = 0
        }
    }
    
    // ラベルメモ文字列
    @IBInspectable var labelMemo: String = StringUtility.EMPTY
    
    // ラベル日時文字列
    @IBInspectable var labelDateTime: String = StringUtility.EMPTY
    
    // ラベル文字色
    @IBInspectable var labelTextColor: Int = 0
    
    ///
    ///　初期化処理（Storyboard/xibから）
    ///　- parameter aDecoder:NSCoder
    ///
    required init?(coder aDecoder: NSCoder) {
        // 基底の初期化処理
        super.init(coder: aDecoder)
        
        // 初期化処理
        self.initCustumControl()
    }
    
    ///
    ///　初期化処理（コードから）
    ///　- parameter frame:位置・サイズ
    ///
    override init(frame: CGRect) {
        // 基底の初期化処理
        super.init(frame: frame)

        // 初期化処理
        self.initCustumControl()
    }
    
    ///
    ///　表示位置設定
    ///　- parameter frame:位置・サイズ
    ///
    open func setLocation(_ frame : CGRect) {
        // 表示位置設定
        self.layer.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height)
        
        // 初期化処理
        self.initCustumControl()
    }

    ///
    ///　初期化処理
    ///
    fileprivate func initCustumControl(){
        // xib からカスタムViewをロードする
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: UITaskImageButton.UITaskImageButtonIdentifier, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        // 親に追加
        addSubview(view)

        // 親コントロールのサイズを取得する
        let width = self.layer.frame.size.width
        let height = self.layer.frame.size.height

        // 子コントロールのサイズを設定する
        view.layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.txtLabel.layer.frame = CGRect(x: UITaskImageButton.LABEL_MARGIN, y: UITaskImageButton.LABEL_MARGIN, width: width - (UITaskImageButton.LABEL_MARGIN * 2), height: height - (UITaskImageButton.LABEL_MARGIN * 2))
        self.btnImage.layer.frame = CGRect(x: 0, y: 0, width: width, height: height)

        // ラベル文字色設定
        self.txtLabel.textColor = getLabelTextColor(self.labelTextColor)
        
        // フォントサイズ設定
        self.txtLabel.font = self.txtLabel.font.withSize(getFontSize(self.txtLabel.font.fontName, width: self.layer.frame.size.width, height: self.layer.frame.size.height, text: self.txtLabel.text!))
        
        // アニメーション設定
        setViewAnimation()
        
        // ラベル表示更新タイマー開始
        startTimerForLabel()
    }
    
    ///
    ///　ラベル用　フォントサイズ取得
    ///　- parameter fontName:フォント名
    ///　- parameter width:コントロール幅
    ///　- parameter height:コントロール高さ
    ///　- parameter text:表示文字
    ///　- returns:フォントサイズ
    ///
    fileprivate func getFontSize(_ fontName : String, width : CGFloat, height : CGFloat, text : String) -> CGFloat {
        var ret : CGFloat = 0
        let work : String = text
        let fontSizies : [CGFloat] = [42.0, 38.0, 34.0, 32.0, 28.0, 24.0, 22.0, 20.0, 18.0, 160, 14.0, 12.0, 11.0, 10.0, 9.0, 8.0, 7.0, 6.0, 5.0]
        let workWidth : CGFloat = width - (UITaskImageButton.LABEL_MARGIN * 2)
        
        // 調査するフォントサイズ数分処理する
        for fontSize in fontSizies {
            ret = fontSize
            // fontを利用時のテキストサイズを取得
            var attributes : [String: AnyObject]? = [String: AnyObject]()
            attributes![NSFontAttributeName] = UIFont(name: fontName, size: fontSize)
            let size = work.size(attributes: attributes)

            // 表示ラベルの行数は2行固定とする
            let workHeight : CGFloat = size.height * UITaskImageButton.LABEL_ROWS
            
            // コントロールの幅に収まっている、または、折り返した結果、高さに収まっている場合
            if(workWidth >= size.width || workHeight >= (size.height * (size.width / workWidth))) {
                // 確定
                break
            }
        }
        
        return ret
    }
    
    ///
    ///　アニメーション設定
    ///
    fileprivate func setViewAnimation(){
        // アニメーション削除
        self.layer.removeAllAnimations()

        // 開始インターバル設定
        let interval = (CFTimeInterval(arc4random() % 200) / 100)

        // 上下アニメーション
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = self.center.y - 5
        animation.toValue = self.center.y + 5
        animation.beginTime = CACurrentMediaTime() + interval;
        animation.duration = 3.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.layer.add(animation, forKey: UITaskImageButton.AnimationLayerIdentifier)
    }
    
    ///
    ///　ラベル用　タイマー開始
    ///
    fileprivate func startTimerForLabel() {
        self.timLabel = Timer.scheduledTimer(timeInterval: UITaskImageButton.IntervalForTitleTimer, target: self, selector: #selector(UITaskImageButton.updateForLabel(_:)), userInfo: nil, repeats: true)
    }
    
    ///
    ///　ラベル用　タイマー停止
    ///
    fileprivate func stopTimerForLabel() {
        self.timLabel?.invalidate()
    }
    
    ///
    ///　ラベル用　テキスト文字色取得
    ///　- parameter textColor:テキスト色
    ///　- returns:UIColor
    ///
    fileprivate func getLabelTextColor(_ textColor : Int) -> UIColor {
        return UIColorUtility.rgb(222, g: 255, b: 255)
    }
    
    ///
    ///　ラベル用　タイマー更新処理
    ///　- parameter timer:タイマー
    ///
    @objc func updateForLabel(_ timer: Timer) {
        var label : String = StringUtility.EMPTY
        
        switch(self.intCurrentLabel) {
        // タスク完了日の場合
        case UITaskImageButton.DISPLAY_LABEL_DATE:
            // メモが有効な場合
            if(false == self.labelMemo.isEmpty){
                // メモ表示
                label = self.labelMemo
                self.intCurrentLabel = UITaskImageButton.DISPLAY_LABEL_MEMO

            // 上記以外の場合
            } else {
                // タイトル表示
                label = self.labelTitle
                self.intCurrentLabel = UITaskImageButton.DISPLAY_LABEL_TITLE
            }
            break;
            
        // メモ表示の場合
        case UITaskImageButton.DISPLAY_LABEL_MEMO:
            // タイトル表示
            label = self.labelTitle
            self.intCurrentLabel = UITaskImageButton.DISPLAY_LABEL_TITLE
            break;
            
        // 上記以外の場合
        default:
            // タスク完了日表示
            label = self.labelDateTime
            self.intCurrentLabel = UITaskImageButton.DISPLAY_LABEL_DATE
            break;
        }
        
        // ラベル表示文字列が有効な場合
        if(false == label.isEmpty){
            // 文字列設定
            self.txtLabel.text = label

            // フォントサイズ設定
            self.txtLabel.font = self.txtLabel.font.withSize(getFontSize(self.txtLabel.font.fontName, width: self.layer.frame.size.width, height: self.layer.frame.size.height, text: label))
        }
    }
}

