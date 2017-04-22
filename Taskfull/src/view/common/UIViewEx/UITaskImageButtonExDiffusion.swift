//
//  UITaskImageButtonExDiffusion.swift
//

import UIKit
/**
 * UITaskImageButton拡張クラス
 */
extension UITaskImageButton {
    
    /**
     * 定数
     */
    /**
     * 拡散イメージ数
     */
    static internal let DIFFUSION_NUM_X : Int = 16
    static internal let DIFFUSION_NUM_Y : Int = 4

    /**
     * 拡散イメージサイズ
     */
    static internal let DIFFUSION_IMAGE_SIZE : Int = 32

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
        
        // 拡散要素数分処理する
        for shape in diffusionCells!{
            // 中央表示
            shape.position = center
            shape.opacity = 1
            // 表示位置アニメーション生成
            let moveAnimation = CAKeyframeAnimation(keyPath: "position")
            // 放物線移動設定
            moveAnimation.path = makeRandomPath(shape).cgPath
            moveAnimation.fillMode = kCAFillModeRemoved
            moveAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.240000, 0.590000, 0.506667, 0.026667)
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
