//
//  BaseTableViewCell.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/26.
//  Copyright © 2017年 isc. All rights reserved.
//
import UIKit

//
// TableViewCell基底クラス
//
open class BaseTableViewCell : UITableViewCell {
    ///
    /// identifierを取得
    /// - returns: クラス名を「identifier」とする
    ///
    class var identifier: String { return self.className }
    
    ///
    ///　初期化処理（Storyboard/xibから）
    ///　- parameter aDecoder:NSCoder
    ///
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    ///
    ///　初期化処理
    ///　- parameter style:UITableViewCellStyle
    ///　- parameter reuseIdentifier:String
    ///
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    ///
    /// セルの高さを取得
    /// - returns: セルの高さ
    ///
    open class func height() -> CGFloat {
        // 48を返す
        return 48
    }
    
    ///
    /// セルのデータ設定
    ///　- parameter data:セルのデータ
    ///
    open func setData(_ data: Any?) {
        // フォントサイズを18で設定
        self.textLabel?.font = UIFont.italicSystemFont(ofSize: 18)
        // セルデータが「String型」の場合
        if let menuText = data as? String {
            // ラベルに文字列を設定
            self.textLabel?.text = menuText
        }
    }
    
    ///
    /// セルのデータ設定
    ///　- parameter highlighted:true:ハイライト表示 false:通常表示
    ///　- parameter animated:true:アニメーション表示する false:アニメーション表示しない
    ///
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // ハイライト表示の場合
        if highlighted {
            // 透過を60%に設定
            self.alpha = 0.4
            
        // 上記以外の場合
        } else {
            // 透過を0%に設定
            self.alpha = 1.0
        }
    }
}
