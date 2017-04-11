//
//  UICustomView.swift
//  Problem04
//
//  Created by IscIsc on 2016/07/04.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import UIKit

//
// UIカスタムビュークラス
//
@IBDesignable
class UICustomView : UIView
{
    // グラデーションレイヤー
    fileprivate var mGradientLayer : CAGradientLayer? = nil
    
    // テキスト文字列色
    @IBInspectable var textColor: UIColor?
    
    // 角丸の設定
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // 角丸時のマスクON/OFF
    @IBInspectable var masksToBounds: Bool = false {
        didSet {
            layer.masksToBounds = masksToBounds
        }
    }
    
    // 枠の線幅
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    // 枠の色
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    // グラデーション　通常時の背景色　開始
    @IBInspectable var gradationBackgroundStartColor :UIColor?
    // グラデーション　通常時の背景色　終了
    @IBInspectable var gradationBackgroundEndColor :UIColor? = UIColor.clear {
        didSet {
            SetGradationLayerForNonHighlighted()
        }
    }
    
    // グラデーション背景色　通常時のレイアウト設定
    fileprivate func SetGradationLayerForNonHighlighted()
    {
        // グラデーション色が有効な場合
        if true == UICommon.IsGradation(gradationBackgroundStartColor, endColor: gradationBackgroundEndColor)
        {
            // CAGradientLayer生成
            let gradientLayer : CAGradientLayer = UICommon.CreateGradientLayer(
                self,
                startColor : gradationBackgroundStartColor!,
                endColor : gradationBackgroundEndColor!)
            
            // 背景をグラデーションに設定
            if(nil != self.mGradientLayer){
                self.layer.replaceSublayer(self.mGradientLayer!, with: gradientLayer)
            } else {
                self.layer.insertSublayer(gradientLayer, at: 0)
            }
            self.mGradientLayer = gradientLayer
        }
    }
}
