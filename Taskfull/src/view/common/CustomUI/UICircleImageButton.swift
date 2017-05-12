//
//  UICircleImageButton.swift
//  Taskfull
//
//  Created by IscIsc on 2017/03/11.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

//
// UI円形イメージボタンクラス
//
@IBDesignable
class UICircleImageButton : UIImageButton
{
    //
    // layoutSubviewsイベント
    //
    override func layoutSubviews() {
        // 規定のlayoutSubviewsを呼び出す
        super.layoutSubviews()
        // 角丸指定をフレームサイズの半分を設定
        super.layer.cornerRadius = self.frame.size.height / 2
        // 円形にクリップする
        super.clipsToBounds = true
    }
    
    //
    // タップ座標のコントロール座標内チェック
    ///　- parameter point:タップ座標
    ///　- parameter event:UIEvent
    ///　- returns UIView:nil:コントロール外 nil以外:タップされたコントロールオブジェクト
    //
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 押下ポイントがコントロールに入っていない場合
        if(false == self.bounds.contains(point)){
            // 処理しない
            return nil
        }

        // 現在の背景画像が無い場合
        if(nil == self.currentBackgroundImage) {
            // 処理しない
            return nil
        }

        // コントロールのサイズ取得
        let ctrlSize: Int = Int(self.frame.size.height)
        // 画像のサイズ取得
        let imageSize: Int = Int((self.currentBackgroundImage?.size.height)!)
        
        // 透過色（Alpha）を取得
        let pixelAlphaColor = UIColorUtility.getAlphaColor(
            imageSize,
            image: (self.currentBackgroundImage?.cgImage)!,
            pos: UIColorUtility.convImagePos(point, orgImageSize: ctrlSize, crntImageSize: imageSize), pixelDataByteSize: 4)
        
        // 透明な場合
        if(0 == pixelAlphaColor){
            // 処理しない
            return nil
        }

        // 処理する
        return self
    }
}

