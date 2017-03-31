//
//  UICustomButton.swift
//  Problem04
//
//  Created by IscIsc on 2016/07/04.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import UIKit

//
// UIカスタムボタンクラス
//
@IBDesignable
class UICustomButton : UIButton
{
    // グラデーション背景色インデックス
    private var mintGradationBackgroundColorIndex : [Int] = [-1, -1]
    
    // ボタン角丸の設定
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // ボタン角丸時のマスクON/OFF
    @IBInspectable var masksToBounds: Bool = false {
        didSet {
            layer.masksToBounds = masksToBounds
        }
    }
    
    // ボタン枠の線幅
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    // ボタン枠の色
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    // 通常背景色
    // 押下時の背景色
    @IBInspectable var highlightedBackgroundColor :UIColor?
    // 通常時の背景色
    @IBInspectable var nonHighlightedBackgroundColor :UIColor?
    
    // グラデーション用背景色
    // グラデーション　押下時の背景色　開始
    @IBInspectable var highlightedGradationBackgroundStartColor :UIColor?
    // グラデーション　押下時の背景色　終了
    @IBInspectable var highlightedGradationBackgroundEndColor :UIColor? = UIColor.clearColor() {
        didSet {
            SetGradationLayerForHighlighted()
        }
    }
    // グラデーション　通常時の背景色　開始
    @IBInspectable var nonHighlightedGradationBackgroundStartColor :UIColor?
    // グラデーション　通常時の背景色　終了
    @IBInspectable var nonHighlightedGradationBackgroundEndColor :UIColor? = UIColor.clearColor() {
        didSet {
            SetGradationLayerForNonHighlighted()
        }
    }
    
    // highlightedプロパティ
    override var highlighted :Bool {
        didSet {
            // 押下時の場合
            if highlighted
            {
                // 押下時の背景色を設定
                SetBackGroundColorForHighlight(
                    highlightedBackgroundColor,
                    gradationStartColor: highlightedGradationBackgroundStartColor,
                    gradationEndColor: highlightedGradationBackgroundEndColor,
                    subLayerIndex1 : mintGradationBackgroundColorIndex[1],
                    subLayerIndex2 : mintGradationBackgroundColorIndex[0],
                    subLayerIndex : mintGradationBackgroundColorIndex[0])
            }
            // 上記以外の場合
            else
            {
                // 通常時の背景色を設定
                SetBackGroundColorForHighlight(
                    nonHighlightedBackgroundColor,
                    gradationStartColor: nonHighlightedGradationBackgroundStartColor,
                    gradationEndColor: nonHighlightedGradationBackgroundEndColor,
                    subLayerIndex1 : mintGradationBackgroundColorIndex[0],
                    subLayerIndex2 : mintGradationBackgroundColorIndex[1],
                    subLayerIndex : mintGradationBackgroundColorIndex[0])

            }
        }
    }
    
    /// 背景色の設定（ハイライト用）
    /// - parameter normalColor:通常の背景色
    /// - parameter gradationStartColor:グラデーションの開始色
    /// - parameter gradationEndColor:グラデーションの終了色
    /// - parameter subLayerIndex1:サブレイヤーインデックス１（グラデーション切替用）
    /// - parameter subLayerIndex2:サブレイヤーインデックス２（グラデーション切替用）
    /// - parameter subLayerIndex:サブレイヤーインデックス（グラデーション無し）
    private func SetBackGroundColorForHighlight(
        normalColor : UIColor?,
        gradationStartColor : UIColor?,
        gradationEndColor : UIColor?,
        subLayerIndex1 : Int,
        subLayerIndex2 : Int,
        subLayerIndex : Int)
    {
        // グラデーション色が有効な場合
        if true == UICommon.IsGradation(gradationStartColor, endColor: gradationEndColor)
        {
            // サブレイヤーが2より大きい場合（必ず１つはデフォルトで存在する）
            if(2 < self.layer.sublayers?.count){
                // レイヤー1を表示
                self.layer.sublayers![subLayerIndex1].hidden = false
                // レイヤー2を非表示
                self.layer.sublayers![subLayerIndex2].hidden = true
            }
            // 上記以外の場合
            else
            {
                // レイヤーを表示
                self.layer.sublayers![subLayerIndex].hidden = false
            }
        }
        // 上記以外の場合
        else
        {
            // 押下時の背景色を設定
            self.backgroundColor = normalColor
        }
    }
    
    // グラデーション背景色　通常時のレイアウト設定
    private func SetGradationLayerForNonHighlighted()
    {
        // 通常時のグラデーション色が有効な場合
        if true == UICommon.IsGradation(nonHighlightedGradationBackgroundStartColor, endColor: nonHighlightedGradationBackgroundEndColor)
        {
            // 背景をグラデーションに設定
            self.layer.insertSublayer(UICommon.CreateGradientLayer(
                self,
                startColor : nonHighlightedGradationBackgroundStartColor!,
                endColor : nonHighlightedGradationBackgroundEndColor!), atIndex: 0)

            // 通常時のインデックスを0に設定
            mintGradationBackgroundColorIndex[0] = 0
            // 押下時のインデックスが設定されている場合
            if(-1 != mintGradationBackgroundColorIndex[1])
            {
                // 押下時のインデックスを1に設定
                mintGradationBackgroundColorIndex[1] = 1
                // 押下時のレイヤーを非表示
                self.layer.sublayers![mintGradationBackgroundColorIndex[1]].hidden = true
            }
            // 通常時のレイヤーを表示
            self.layer.sublayers![mintGradationBackgroundColorIndex[0]].hidden = false
        }
    }
    
    // グラデーション背景色　押下時のレイアウト設定
    private func SetGradationLayerForHighlighted()
    {
        // 押下時のグラデーション色が有効な場合
        if true == UICommon.IsGradation(highlightedGradationBackgroundStartColor, endColor: highlightedGradationBackgroundEndColor)
        {
            // 背景をグラデーションに設定
            self.layer.insertSublayer(UICommon.CreateGradientLayer(
                self,
                startColor : highlightedGradationBackgroundStartColor!,
                endColor : highlightedGradationBackgroundEndColor!), atIndex: 0)
                
            // 押下時のインデックスを1に設定
            mintGradationBackgroundColorIndex[1] = 0
            // 通常時のインデックスが設定されている場合
            if(-1 != mintGradationBackgroundColorIndex[0])
            {
                // 押下時のインデックスを1に設定
                mintGradationBackgroundColorIndex[1] = 1
            }
            // 押下時のレイヤーを非表示
            self.layer.sublayers![mintGradationBackgroundColorIndex[1]].hidden = true
        }
    }
}

extension UIButton {
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func setBackgroundColor(color: UIColor, forUIControlState state: UIControlState) {
        self.setBackgroundImage(imageWithColor(color), forState: state)
    }
}