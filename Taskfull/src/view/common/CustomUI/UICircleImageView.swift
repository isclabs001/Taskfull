//
//  UICircleImageView.swift
//  Taskfull
//
//  Created by IscIsc on 2017/03/11.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

//
// UI円形イメージクラス
//
@IBDesignable
class UICircleImageView : UIImageView
{
    override func layoutSubviews() {
        // 規定のlayoutSubviewsを呼び出す
        super.layoutSubviews()
        // 角丸指定をフレームサイズの半分を設定
        super.layer.cornerRadius = self.frame.size.height / 2
        // 円形にクリップする
        super.clipsToBounds = true
    }
    
    // 画像情報設定
    func setImageInfo(_ image: UIImage?, x : Double, y : Double, whidth : Double, height : Double) {
        // サイズ設定
        self.frame = CGRect(x: x,y: y,width: whidth,height: height)
        // 画像設定
        self.image = image
    }
}
