//
//  MainMenuBarSubItemCell.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/26.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

//
// MainMenuBarSubItemCellのデータ構造体
//
struct MainMenuBarSubItemCellData {
    
    ///
    ///　初期化処理
    ///　- parameter mainMenu:メニューID
    ///　- parameter title:タイトル
    ///　- parameter backgroundColor:背景色
    ///
    init(mainMenu: Int, title: String, backgroundColor: UIColor) {
        self.mainMenu = mainMenu
        self.title = title
        self.backgroundColor = backgroundColor
    }
    var mainMenu: Int
    var title: String
    var backgroundColor: UIColor
}

//
// MainMenuBarSubItemCellクラス
//
class MainMenuBarSubItemCell : BaseTableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgImage: UIImageView!

    ///
    /// セルの高さを取得
    /// - returns: セルの高さ
    ///
    override class func height() -> CGFloat {
        // 120を返す
        return 120
    }
    
    ///
    /// セルのデータ設定
    ///　- parameter data:セルのデータ
    ///
    override func setData(_ data: Any?) {
        // セルデータが「MainMenuBarSubItemCellData型」の場合
        if let data = data as? MainMenuBarSubItemCellData {
            // セル情報設定
            self.lblTitle.text = data.title
            self.backgroundColor = data.backgroundColor
            self.lblTitle.textColor = UIColor.white
            self.lblTitle.shadowColor = UIColor.brown
        }
    }
}
