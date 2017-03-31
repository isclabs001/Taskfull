//
//  UIImageButton.swift
//  Taskfull
//
//  Created by IscIsc on 2017/03/11.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

//
// UIイメージボタンクラス
//
@IBDesignable
class UIImageButton : UICustomButton
{
    //
    // layoutSubviewsイベント
    //
    override func layoutSubviews() {
        // 規定のlayoutSubviewsを呼び出す
        super.layoutSubviews()
        // 画像をはみ出さないようにする
        self.clipsToBounds = true

        // 通常時の背景画像に変更する
        self.setBackgroundImage(nonHighlightedBackgroundImage, forState: UIControlState.Normal)
    }
    
    // 押下時の背景画像
    @IBInspectable var highlightedBackgroundImage :UIImage?
    // 通常時の背景画像
    @IBInspectable var nonHighlightedBackgroundImage :UIImage?
    
    // highlightedプロパティ
    override var highlighted :Bool {
        didSet {
            // 押下時の場合
            if highlighted
            {
                // 押下時の背景画像に変更する
                self.setBackgroundImage(highlightedBackgroundImage, forState: UIControlState.Normal)
            }
            // 上記以外の場合
            else
            {
                // 通常時の背景画像に変更する
                self.setBackgroundImage(nonHighlightedBackgroundImage, forState: UIControlState.Normal)
            }
        }
    }
    
    // 画像情報設定
    func setImageInfo(image: UIImage?, width : Double, height : Double) {
        // サイズ設定
        self.frame = CGRect(x: 0,y: 0,width: width,height: height)
        // 画像設定
        self.highlightedBackgroundImage = image
        self.nonHighlightedBackgroundImage = image
    }
}
