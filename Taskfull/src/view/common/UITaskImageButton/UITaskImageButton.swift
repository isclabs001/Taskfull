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
    
    /**
     * 変数
     */
    // ラベル用　タイマー
    weak var timLabel: NSTimer?
    // ラベル用　現在表示中のラベル
    private var intCurrentLabel: Int = 0
    
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
    public func setLocation(frame : CGRect) {
        // 表示位置設定
        self.layer.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height)
        
        // 初期化処理
        self.initCustumControl()
    }

    ///
    ///　初期化処理
    ///
    private func initCustumControl(){
        // xib からカスタムViewをロードする
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: UITaskImageButton.UITaskImageButtonIdentifier, bundle: bundle)
        guard let view = nib.instantiateWithOwner(self, options: nil).first as? UIView else {
            return
        }
        // 親に追加
        addSubview(view)

        // 親コントロールのサイズを取得する
        let width = self.layer.frame.size.width
        let height = self.layer.frame.size.height

        // 子コントロールのサイズを設定する
        let txtMargin : CGFloat = 6
        view.layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.txtLabel.layer.frame = CGRect(x: txtMargin, y: 0, width: width - (txtMargin * 2), height: height)
        self.btnImage.layer.frame = CGRect(x: 0, y: 0, width: width, height: height)

        // ラベル文字色設定
        self.txtLabel.textColor = getLabelTextColor(self.labelTextColor)
        
        // アニメーション設定
        setViewAnimation()
        
        // ラベル表示更新タイマー開始
        startTimerForLabel()
    }
    
    ///
    ///　アニメーション設定
    ///
    private func setViewAnimation(){
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
        self.layer.addAnimation(animation, forKey: UITaskImageButton.AnimationLayerIdentifier)
    }
    
    ///
    ///　ラベル用　タイマー開始
    ///
    private func startTimerForLabel() {
        self.timLabel = NSTimer.scheduledTimerWithTimeInterval(UITaskImageButton.IntervalForTitleTimer, target: self, selector: #selector(UITaskImageButton.updateForLabel(_:)), userInfo: nil, repeats: true)
    }
    
    ///
    ///　ラベル用　タイマー停止
    ///
    private func stopTimerForLabel() {
        self.timLabel?.invalidate()
    }
    
    ///
    ///　ラベル用　テキスト文字色取得
    ///　- parameter textColor:テキスト色
    ///　- returns:UIColor
    ///
    private func getLabelTextColor(textColor : Int) -> UIColor {
        return UIColorUtility.rgb(222, g: 255, b: 255)
    }
    
    ///
    ///　ラベル用　タイマー更新処理
    ///　- parameter timer:タイマー
    ///
    @objc func updateForLabel(timer: NSTimer) {
        var label : String = StringUtility.EMPTY
        
        switch(self.intCurrentLabel) {
        // メモ表示の場合
        case 1:
            label = self.labelTitle
            self.intCurrentLabel = 0
            break;
            
        // 上記以外の場合
        default:
            // 日時、かつ、メモが有効な場合
            if(false == self.labelDateTime.isEmpty && false == self.labelMemo.isEmpty){
                label = self.labelDateTime + ":" + self.labelMemo
            } else if(false == self.labelDateTime.isEmpty && true == self.labelMemo.isEmpty){
                label = self.labelDateTime
            } else {
                label = self.labelMemo
            }
            if(false == label.isEmpty){
                self.intCurrentLabel = 1
            }
            break;
        }
        
        // ラベル表示文字列が有効な場合
        if(false == label.isEmpty){
            // 文字列設定
            self.txtLabel.text = label
        }
    }
}

