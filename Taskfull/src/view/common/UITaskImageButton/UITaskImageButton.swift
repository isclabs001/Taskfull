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
    static let UITaskImageButtonIdentifier : String = "UITaskImageButton"
    
    // アニメーションレイヤーの一意名
    static let AnimationLayerIdentifier : String = "AnimationLayerIdentifier"
    
    // アニメーションレイヤーの一意名
    static let AnimationLayerClashIdentifier : String = "AnimationLayerClashIdentifier"
    
    // タイトル切り替えのインターバルタイマー
    static let IntervalForTitleTimer : Double = 5.0
    
    // ラベルのマージン
    static let LABEL_MARGIN : CGFloat = 6.0
    // ラベルの行数
    static let LABEL_ROWS : CGFloat = 2.0

    // 表示ラベルインデックス　タイトル
    static let DISPLAY_LABEL_TITLE : Int = 0
    // 表示ラベルインデックス　タスク完了日
    static let DISPLAY_LABEL_DATE : Int = 1
    // 表示ラベルインデックス　メモ
    static let DISPLAY_LABEL_MEMO : Int = 2
    
    // 表示フォントサイズ
    static let FONT_SIZE_MIN : Int = 5
    static let FONT_SIZE_MAX : Int = 26
    
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
            
            // フォントサイズ設定
            self.txtLabel.font = self.txtLabel.font.withSize(getFontSize(self.txtLabel.font.fontName, width: self.layer.frame.size.width, height: self.layer.frame.size.height, text: self.txtLabel.text!))
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
    /// デイニシャライズ（デストラクタ）
    ///
    deinit {
        // メモリ解放処理
        allocRelease()
    }
    
    ///
    /// メモリ解放処理
    ///
    open func allocRelease() {
        // アニメーション停止
        stopAnimation()
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
        // 破裂用初期化処理
        self.initCustumControlDiffusion()

        // 一旦非表示にする
        self.alpha = 0
        // 親に追加
        self.addSubview(view)

        // 親コントロールのサイズを取得する
        let width = self.layer.frame.size.width
        let height = self.layer.frame.size.height

        // 子コントロールのサイズを設定する
        view.layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.txtLabel.layer.frame = CGRect(x: UITaskImageButton.LABEL_MARGIN, y: UITaskImageButton.LABEL_MARGIN, width: width - (UITaskImageButton.LABEL_MARGIN * 2), height: height - (UITaskImageButton.LABEL_MARGIN * 2))
        self.btnImage.layer.frame = CGRect(x: 0, y: 0, width: width, height: height)

        // ラベル文字色設定
        self.txtLabel.textColor = getLabelTextColor(self.labelTextColor)
        
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
        let workWidth : CGFloat = width - (UITaskImageButton.LABEL_MARGIN * 2 + 2.0)
        
        // 改行数チェック
        let range = text.range(of: StringUtility.LF)
        var lfCount : CGFloat = 0
        if(nil != range && false == range?.isEmpty){
            lfCount += 1
        }
        
        // 調査するフォントサイズ数分処理する(5ポイント〜26ポイント)
        for fontSize in (UITaskImageButton.FONT_SIZE_MIN...UITaskImageButton.FONT_SIZE_MAX).reversed() {
            ret = CGFloat(fontSize)
            // fontを利用時のテキストサイズを取得
            var attributes : [String: AnyObject]? = [String: AnyObject]()
            attributes![NSFontAttributeName] = UIFont(name: fontName, size: CGFloat(fontSize))
            let size = work.size(attributes: attributes)

            // 表示行数取得
            let workRowsDown : CGFloat = CGFloat(Int(size.width / workWidth))
            let workRows : CGFloat = size.width / workWidth + lfCount
            
            // 表示行が０の場合
            if(0 == workRowsDown) {
                // 確定
                break

            // 上記以外の場合
            } else {
                // 表示ラベルの行数は最大2行固定とする
                let workHeight : CGFloat = (height >= size.height * UITaskImageButton.LABEL_ROWS) ? size.height * UITaskImageButton.LABEL_ROWS : size.height

                // 幅が2行以内の場合
                if((size.width / workWidth) <= UITaskImageButton.LABEL_ROWS && workRows <= UITaskImageButton.LABEL_ROWS) {
                    // コントロールの幅に収まっている、または、折り返した結果、高さに収まっている場合
                    if(workWidth >= size.width || ((workWidth >= (size.width / workRowsDown)) && (workHeight >= (size.height * workRowsDown)))) {
                        // 確定
                        break
                    }
                }
            }
        }
        
        return ret
    }
    
    ///
    ///　アニメーション設定
    ///
    fileprivate func setViewAnimation(){
        // アニメーション停止
        stopViewAnimation()

        // 開始インターバル設定
        let interval = (CFTimeInterval(arc4random() % 200) / 100)

        // 開始アニメーション設定
        setStartAnimation(interval: interval)
        
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
    ///　アニメーション停止
    ///
    fileprivate func stopViewAnimation(){
        // アニメーション削除
        self.layer.removeAllAnimations()
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
        if(nil != self.timLabel){
            self.timLabel?.invalidate()
            self.timLabel = nil
        }
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
    
    ///
    ///　アニメーション停止処理
    ///
    open func stopAnimation() {
        // アニメーション停止
        stopViewAnimation()
        // ラベル用　タイマー停止
        stopTimerForLabel()
    }
    
    ///
    ///　シャボン玉が割れたアニメーション処理
    ///
    open func clashAnimation() {
        // アニメーション停止処理
        stopAnimation()
        // シャボン玉が割れたアニメーション設定
        setClashAnimation()
    }
    
    ///
    ///　シャボン玉を表示する際の開始アニメーション設定処理
    ///　- parameter interval:表示の開始時間
    ///
    fileprivate func setStartAnimation(interval : CFTimeInterval){
        
        // 徐々に表示するアニメーション
        UIView.animate(withDuration: 0.75,
                       delay: interval,
                       animations: {
                            self.alpha = 1
                        })
    }
    
    ///
    ///　シャボン玉が割れたアニメーション設定処理
    ///
    fileprivate func setClashAnimation(){
        
        // TODO:割れたアニメーションにする！！
        execAnimationForDiffusion()
        /*
        // 徐々に消えるアニメーション
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 0.75
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.layer.add(animation, forKey: UITaskImageButton.AnimationLayerClashIdentifier)
        self.layer.opacity = 0
        */
    }
}

