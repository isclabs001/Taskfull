//
//  UICustomButton.swift
//  Problem04
//
//  Created by IscIsc on 2016/07/04.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


//
// UIカスタムボタンクラス
//
@IBDesignable
class UICustomButton : UIButton
{
    // グラデーション背景色インデックス
    fileprivate var mintGradationBackgroundColorIndex : [Int] = [-1, -1]
    
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
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
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
    @IBInspectable var highlightedGradationBackgroundEndColor :UIColor? = UIColor.clear {
        didSet {
            SetGradationLayerForHighlighted()
        }
    }
    // グラデーション　通常時の背景色　開始
    @IBInspectable var nonHighlightedGradationBackgroundStartColor :UIColor?
    // グラデーション　通常時の背景色　終了
    @IBInspectable var nonHighlightedGradationBackgroundEndColor :UIColor? = UIColor.clear {
        didSet {
            SetGradationLayerForNonHighlighted()
        }
    }
    
    // highlightedプロパティ
    override var isHighlighted :Bool {
        didSet {
            // 押下時の場合
            if isHighlighted
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
    
    ///
    /// 背景色の設定（ハイライト用）
    /// - parameter normalColor:通常の背景色
    /// - parameter gradationStartColor:グラデーションの開始色
    /// - parameter gradationEndColor:グラデーションの終了色
    /// - parameter subLayerIndex1:サブレイヤーインデックス１（グラデーション切替用）
    /// - parameter subLayerIndex2:サブレイヤーインデックス２（グラデーション切替用）
    /// - parameter subLayerIndex:サブレイヤーインデックス（グラデーション無し）
    ///
    fileprivate func SetBackGroundColorForHighlight(
        _ normalColor : UIColor?,
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
                self.layer.sublayers![subLayerIndex1].isHidden = false
                // レイヤー2を非表示
                self.layer.sublayers![subLayerIndex2].isHidden = true
            }
            // 上記以外の場合
            else
            {
                // レイヤーを表示
                self.layer.sublayers![subLayerIndex].isHidden = false
            }
        }
        // 上記以外の場合
        else
        {
            // 押下時の背景色を設定
            self.backgroundColor = normalColor
        }
    }
    
    ///
    /// グラデーション背景色　通常時のレイアウト設定
    ///
    fileprivate func SetGradationLayerForNonHighlighted()
    {
        // 通常時のグラデーション色が有効な場合
        if true == UICommon.IsGradation(nonHighlightedGradationBackgroundStartColor, endColor: nonHighlightedGradationBackgroundEndColor)
        {
            // 背景をグラデーションに設定
            self.layer.insertSublayer(UICommon.CreateGradientLayer(
                self,
                startColor : nonHighlightedGradationBackgroundStartColor!,
                endColor : nonHighlightedGradationBackgroundEndColor!), at: 0)

            // 通常時のインデックスを0に設定
            mintGradationBackgroundColorIndex[0] = 0
            // 押下時のインデックスが設定されている場合
            if(-1 != mintGradationBackgroundColorIndex[1])
            {
                // 押下時のインデックスを1に設定
                mintGradationBackgroundColorIndex[1] = 1
                // 押下時のレイヤーを非表示
                self.layer.sublayers![mintGradationBackgroundColorIndex[1]].isHidden = true
            }
            // 通常時のレイヤーを表示
            self.layer.sublayers![mintGradationBackgroundColorIndex[0]].isHidden = false
        }
    }
    
    ///
    /// グラデーション背景色　押下時のレイアウト設定
    ///
    fileprivate func SetGradationLayerForHighlighted()
    {
        // 押下時のグラデーション色が有効な場合
        if true == UICommon.IsGradation(highlightedGradationBackgroundStartColor, endColor: highlightedGradationBackgroundEndColor)
        {
            // 背景をグラデーションに設定
            self.layer.insertSublayer(UICommon.CreateGradientLayer(
                self,
                startColor : highlightedGradationBackgroundStartColor!,
                endColor : highlightedGradationBackgroundEndColor!), at: 0)
                
            // 押下時のインデックスを1に設定
            mintGradationBackgroundColorIndex[1] = 0
            // 通常時のインデックスが設定されている場合
            if(-1 != mintGradationBackgroundColorIndex[0])
            {
                // 押下時のインデックスを1に設定
                mintGradationBackgroundColorIndex[1] = 1
            }
            // 押下時のレイヤーを非表示
            self.layer.sublayers![mintGradationBackgroundColorIndex[1]].isHidden = true
        }
    }
}

//
// UIButton拡張クラス
//
extension UIButton {
    ///
    /// 指定色でUIImage生成
    /// - parameter color:色
    /// - returns:UIImage
    ///
    fileprivate func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    ///
    /// 背景色設定
    /// - parameter color:色
    /// - parameter state:UIControlStateオブジェクト
    /// - returns:UIImage
    ///
    func setBackgroundColor(_ color: UIColor, forUIControlState state: UIControlState) {
        self.setBackgroundImage(imageWithColor(color), for: state)
    }
}
