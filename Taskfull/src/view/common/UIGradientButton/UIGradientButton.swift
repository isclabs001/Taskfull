//
//  UIGradientButton.swift
//  SchoolCafeteriaMap
//
//  Created by IscIsc on 2016/05/02.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import Foundation
import UIKit

class UIGradientButton : UIButton {
    fileprivate var gradientLayer : CAGradientLayer

    internal var startGradient : CGColor
    internal var endGradient : CGColor


    ///
    ///　初期化処理（Storyboard/xibから）
    ///　- parameter aDecoder:NSCoder
    ///
    required init?(coder aDecoder: NSCoder) {
        
        // グラデーションレイヤー初期化
        self.gradientLayer = CAGradientLayer()
        
        // グラデーションの色初期化（白）
        self.startGradient = UIColor.init(colorLiteralRed: 255, green: 255, blue: 255, alpha: 1.0).cgColor
        self.endGradient = UIColor.init(colorLiteralRed: 255, green: 255, blue: 255, alpha: 1.0).cgColor
        
        // 基底の初期化呼び出し
        super.init(coder: aDecoder)
    }
    
    ///
    ///　グラデーション設定
    ///　- parameter startGradient:グラデーション開始色
    ///　- parameter endGradient:グラデーション終了色
    ///
    internal func setGradient(startColor startGradient : CGColor, endColor endGradient : CGColor)
    {
    
    }
}
