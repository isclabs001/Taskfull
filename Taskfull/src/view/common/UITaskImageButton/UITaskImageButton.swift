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
     * 拡散イメージ数
     */
    static internal let DIFFUSION_NUM_X : Int = 16
    static internal let DIFFUSION_NUM_Y : Int = 8
    
    /**
     * 拡散イメージサイズ
     */
    static internal let DIFFUSION_IMAGE_SIZE : Int = 8
    
    /**
     * キー定義構造体
     */
    fileprivate struct AssociatedKeys {
        static var DiffusionCellsName = "EXDiffusionCells"
        static var ScaleSnapshotName = "EXDiffusionScaleSnapshot"
    }
    
    /**
     * 変数
     */
    // ラベル用　タイマー
    weak var timLabel: Timer? = nil
    // ラベル用　現在表示中のラベル
    fileprivate var intCurrentLabel: Int = 0
    
    /**
     * 拡散用　拡散イメージレイヤー配列
     */
    fileprivate var diffusionCells:[CALayer]?{
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.DiffusionCellsName) as? [CALayer]
        }
        set{
            if let newValue = newValue{
                willChangeValue(forKey: AssociatedKeys.DiffusionCellsName)
                objc_setAssociatedObject(self, &AssociatedKeys.DiffusionCellsName, newValue as [CALayer], .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                didChangeValue(forKey: AssociatedKeys.DiffusionCellsName)
            }
        }
    }
    
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
        //self.initCustumControlDiffusion()

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
        startAnimation()
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
    fileprivate func startViewAnimation(){
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
        // ラベル用　タイマー停止
        stopTimerForLabel()
        
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
    ///　アニメーション開始処理
    ///
    open func startAnimation() {
        // アニメーション開始
        startViewAnimation()
        // ラベル用　タイマー開始
        startTimerForLabel()
    }
    
    ///
    ///　アニメーション停止処理
    ///
    open func stopAnimation() {
        // アニメーション停止
        stopViewAnimation()
        // ラベル用　タイマー停止
        stopTimerForLabel()
        // メモリの解放
        removeDiffusionCells()
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
        
        // 割れたアニメーション実行
        execAnimationForDiffusion()
    }
    
    ///
    ///　拡散開始時の画像縮小アニメーション処理
    ///
    @objc fileprivate func scaleOpacityAnimations(){
        // 画像を縮小させる
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 0
        scaleAnimation.duration = 0.15
        scaleAnimation.fillMode = kCAFillModeRemoved
        
        // 透明度を0にする
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.duration = 0.15
        opacityAnimation.fillMode = kCAFillModeRemoved
        
        layer.add(scaleAnimation, forKey: "lscale")
        layer.add(opacityAnimation, forKey: "lopacity")
        layer.opacity = 0
    }
    
    ///
    ///　拡散アニメーション処理
    ///
    @objc fileprivate func cellAnimations(){
        
        var signX : CGFloat = 1.0
        var signY : CGFloat = 1.0
        var index : Int = 0
        
        // 拡散要素数分処理する
        for shape in diffusionCells!{
            switch(index) {
            case 1:
                signX = -0.5
                signY = 0.5
            case 2:
                signX = -1.0
                signY = 0
            case 3:
                signX = -0.5
                signY = -0.5
            case 4:
                signX = 0.0
                signY = -1.0
            case 5:
                signX = 0.5
                signY = -0.5
            case 6:
                signX = 1.0
                signY = 0.0
            case 7:
                signX = 0.5
                signY = 0.5
            default:
                signX = 1.0
                signY = 1.0
            }
            
            signX += CGFloat(arc4random() % 5) / 10
            signY += CGFloat(arc4random() % 5) / 10
            
            // 中央表示
            shape.position = center
            shape.opacity = 1
            // 表示位置アニメーション生成
            let moveAnimation = CAKeyframeAnimation(keyPath: "position")
            // 放物線移動設定
            //moveAnimation.path = makeRandomPath(shape).cgPath
            moveAnimation.path = makeRandomPath2(shape, signX:signX, signY:signY).cgPath
            moveAnimation.fillMode = kCAFillModeRemoved
            moveAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.590000, 0.240000, 0.026667, 0.506667)
            //moveAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.240000, 0.590000, 0.506667, 0.026667)
            //moveAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.46, 0.45, 0.94)
            //moveAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.215, 0.61, 0.355, 1)
            moveAnimation.duration = TimeInterval(arc4random()%10) * 0.05 + 0.3
            
            // 拡散イメージ縮小アニメーション生成
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.toValue = makeScaleValue()
            scaleAnimation.duration = moveAnimation.duration
            scaleAnimation.fillMode = kCAFillModeRemoved
            
            // フェードアウトアニメーション生成
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1
            opacityAnimation.toValue = 0
            opacityAnimation.duration = moveAnimation.duration
            opacityAnimation.fillMode = kCAFillModeRemoved
            opacityAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.380000, 0.033333, 0.963333, 0.260000)
            
            // 最終的にレイヤーを非表示に設定
            shape.opacity = 0
            
            // 各アニメーションを設定
            shape.add(scaleAnimation, forKey: "scaleAnimation")
            shape.add(moveAnimation, forKey: "moveAnimation")
            shape.add(opacityAnimation, forKey: "opacityAnimation")
            
            index = (index + 1) % 8
        }
    }
    
    ///
    ///　開始位置の作成（ランダムな位置を算出）
    /// - parameter position:座標
    ///
    fileprivate func makeShakeValue(_ position:CGFloat) -> CGFloat{
        let basicOrigin : CGFloat = -10.0
        let maxOffset : CGFloat  = -2.0 * basicOrigin
        return basicOrigin + maxOffset * (CGFloat(arc4random() % 101) / 100.0) + position
    }
    
    ///
    ///　縮小時アニメーション時のスケール算出
    ///
    fileprivate func makeScaleValue() -> CGFloat{
        return 1 - 0.7 * (CGFloat(arc4random() % 61) / 50.0)
    }
    
    ///
    ///　放物線移動の作成
    /// - parameter aLayer:親レイヤー
    ///
    fileprivate func makeRandomPath(_ aLayer:CALayer) -> UIBezierPath{
        // 放物線オブジェクトUIBezierPathの生成
        let particlePath = UIBezierPath()
        // 放物線の異動先位置を設定
        particlePath.move(to: layer.position)
        // 放物線の算出
        let basicLeft = -CGFloat(1.3 * layer.frame.size.width)
        let maxOffset = 2 * abs(basicLeft)
        let randomNumber = arc4random() % 101
        let endPointX = basicLeft + maxOffset * (CGFloat(randomNumber) / 100.0) + aLayer.position.x
        let controlPointOffSetX = (endPointX - aLayer.position.x) / 2  + aLayer.position.x
        let controlPointOffSetY = layer.position.y - 0.2 * layer.frame.size.height - CGFloat(arc4random() % UInt32(1.2 * layer.frame.size.height))
        let endPointY = layer.position.y + layer.frame.size.height / 2 + CGFloat(arc4random() % UInt32(layer.frame.size.height / 2))
        // 放物線の追加
        particlePath.addQuadCurve(to: CGPoint(x: endPointX, y: endPointY), controlPoint: CGPoint(x: controlPointOffSetX, y: controlPointOffSetY))
        
        // 作成した放物線を返す
        return particlePath
    }
    
    ///
    ///　放物線移動の作成
    /// - parameter aLayer:親レイヤー
    ///
    fileprivate func makeRandomPath2(_ aLayer:CALayer, signX:CGFloat, signY:CGFloat) -> UIBezierPath{
        // 放物線オブジェクトUIBezierPathの生成
        let particlePath = UIBezierPath()
        // 放物線の異動先位置を設定
        particlePath.move(to: layer.position)
        // 放物線の算出
        let basicLeft = -CGFloat(1.3 * layer.frame.size.width)
        let maxOffset = 2 * abs(basicLeft)
        let randomNumber = arc4random() % 101
        //let endPointX = basicLeft + maxOffset * (CGFloat(randomNumber) / 100.0) + aLayer.position.x
        let endPointX = aLayer.position.x + ((basicLeft + maxOffset * (CGFloat(randomNumber) / 100.0)) * signX)
        //let controlPointOffSetX = (endPointX - aLayer.position.x) / 2  + aLayer.position.x
        let controlPointOffSetX = aLayer.position.x
        //let controlPointOffSetY = layer.position.y - 0.2 * layer.frame.size.height - CGFloat(arc4random() % UInt32(1.2 * layer.frame.size.height))
        //let controlPointOffSetY = layer.position.y + ((CGFloat(arc4random() % UInt32(1.2 * layer.frame.size.height))) * signY)
        let controlPointOffSetY = layer.position.y
        //let endPointY = layer.position.y + ((layer.frame.size.height / 2 + CGFloat(arc4random() % UInt32(layer.frame.size.height / 2))) * signY)
        let endPointY = layer.position.y + ((layer.frame.size.height + CGFloat(arc4random() % UInt32(layer.frame.size.height / 2))) * signY)
        // 放物線の追加
        particlePath.addQuadCurve(to: CGPoint(x: endPointX, y: endPointY), controlPoint: CGPoint(x: controlPointOffSetX, y: controlPointOffSetY))
        
        // 作成した放物線を返す
        return particlePath
    }
    
    ///
    ///　拡散イメージ要素の解放
    ///
    fileprivate func removeDiffusionCells(){
        if diffusionCells == nil {
            return
        }
        for item in diffusionCells!{
            item.removeFromSuperlayer()
        }
        diffusionCells?.removeAll(keepingCapacity: false)
        diffusionCells = nil
    }
    
    ///
    ///　拡散イメージアニメーション実行
    ///
    func execAnimationForDiffusion(){
        // 縮小しながら透明にするアニメーション作成
        let shakeXAnimation = CAKeyframeAnimation(keyPath: "position.x")
        shakeXAnimation.duration = 0.2
        shakeXAnimation.values = [makeShakeValue(layer.position.x),makeShakeValue(layer.position.x),makeShakeValue(layer.position.x),makeShakeValue(layer.position.x),makeShakeValue(layer.position.x)]
        let shakeYAnimation = CAKeyframeAnimation(keyPath: "position.y")
        shakeYAnimation.duration = shakeXAnimation.duration
        shakeYAnimation.values = [makeShakeValue(layer.position.y),makeShakeValue(layer.position.y),makeShakeValue(layer.position.y),makeShakeValue(layer.position.y),makeShakeValue(layer.position.y)]
        
        // アニメーション追加
        layer.add(shakeXAnimation, forKey: "shakeXAnimation")
        layer.add(shakeYAnimation, forKey: "shakeYAnimation")
        
        // 縮小アニメーションを即時実行
        _ = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(UITaskImageButton.scaleOpacityAnimations), userInfo: nil, repeats: false)
        
        // 拡散配列が無効な場合
        if diffusionCells == nil{
            // 拡散配列を設定
            diffusionCells = [CALayer]()
            // 拡散X数分処理する
            for i in 0...UITaskImageButton.DIFFUSION_NUM_X{
                // 拡散Y数分処理する
                for j in 0...UITaskImageButton.DIFFUSION_NUM_Y{
                    // 拡散イメージサイズを画像のサイズ/32より算出
                    let pWidth = min(frame.size.width,frame.size.height) / 32
                    // 拡散イメージ色を水色を基調にランダムの色を設定
                    //let color = UIColorUtility.rgb(222, g: 255, b: 255)
                    let color = UIColorUtility.rgb(200 + Int(arc4random()%22), g: 220 + Int(arc4random()%35), b: 255)
                    let shape = CALayer()
                    // 円にする
                    shape.backgroundColor = color.cgColor
                    shape.opacity = 0
                    shape.cornerRadius = pWidth / 2
                    shape.frame = CGRect(x: CGFloat(i) * pWidth, y: CGFloat(j) * pWidth, width: pWidth, height: pWidth)
                    // 追加
                    layer.superlayer?.addSublayer(shape)
                    diffusionCells?.append(shape)
                }
            }
        }
        
        // 0.1秒後に拡散イメージアニメーションを実行
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UITaskImageButton.cellAnimations), userInfo: nil, repeats: false)
    }
    
    ///
    ///　初期化処理
    ///
    func initCustumControlDiffusion() {
        let originalSelector = #selector(UITaskImageButton.willMove(toSuperview:))
        let swizzledSelector = #selector(UITaskImageButton.willMoveToSuperviewEx(_:))
        
        let originalMethod = class_getInstanceMethod(UIView.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIView.self, swizzledSelector)
        
        let didAddMethod = class_addMethod(UIView.self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(UIView.self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
    
    ///
    ///　解放処理（デストラクタ）
    /// - parameter newSuperView:親レイヤー
    ///
    func willMoveToSuperviewEx(_ newSuperView:UIView){
        // メモリの解放
        removeDiffusionCells()
        willMoveToSuperviewEx(newSuperView)
    }
}

