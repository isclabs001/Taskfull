//
//  UICommon.swift
//  Problem04
//
//  Created by IscIsc on 2016/07/05.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import UIKit

// 
// UI共通クラス
//
class UICommon
{
    ///
    /// グラデーションレイヤーの作成
    /// - parameter parrentView:親コントロール
    /// - parameter startColor:グラデーションの開始色
    /// - parameter endColor:グラデーションの終了色
    /// - returns:CAGradientLayer
    ///
    static internal func CreateGradientLayer(_ parrentView : UIView, startColor : UIColor, endColor : UIColor) -> CAGradientLayer
    {
        // グラデーションレイヤーを作成
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        // グラデーションの色をレイヤーに割り当てる
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        
        // グラデーションレイヤーを親コントロールサイズに設定する
        gradientLayer.frame = parrentView.bounds
        
        // 作成したグラデーションレイヤーを返す
        return gradientLayer
    }
    
    ///
    /// グラデーション色の有効判断処理
    /// - parameter startColor:グラデーションの開始色
    /// - parameter endColor:グラデーションの終了色
    /// - returns:true:有効 false:無効
    ///
    static internal func IsGradation(_ startColor : UIColor?, endColor : UIColor?) -> Bool
    {
        // 開始色が設定されている場合
        if let _ : UIColor = startColor
        {
            // 終了色が設定されている場合
            if let _ : UIColor = endColor
            {
                // 有効
                return true
            }
        }
        
        // 無効
        return false
    }
}
