//
//  TaskCategoryMenuBarSubItemCell.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/28.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

//
// TaskCategoryMenuBarSubItemCellDataのデータ構造体
//
struct TaskCategoryMenuBarSubItemCellData {
    
    ///
    ///　初期化処理
    ///　- parameter category:カテゴリー形式
    ///　- parameter title:タイトル
    ///　- parameter values:値
    ///　- parameter backgroundColor:背景色
    ///
    init(category: Int, title: String, values: Int, backgroundColor: UIColor) {
        self.category = category
        self.title = title
        self.values = values
        self.backgroundColor = backgroundColor
    }
    var category: Int
    var title: String
    var values: Int
    var backgroundColor: UIColor
}

//
// TaskCategoryMenuBarSubItemCellクラス
//
class TaskCategoryMenuBarSubItemCell : BaseTableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValues: UILabel!
    @IBOutlet weak var imgCircle: UIImageView!
    
    var category : Int = -1
    
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
        // セルデータが「TaskCategoryMenuBarSubItemCellData型」の場合
        if let data = data as? TaskCategoryMenuBarSubItemCellData {
            // セル情報設定
            self.category = data.category
            self.lblTitle.text = data.title
            self.lblValues.text = String(data.values)
            self.backgroundColor = data.backgroundColor
            self.lblTitle.textColor = UIColor.white
            self.lblTitle.shadowColor = UIColor.brown
            self.lblValues.textColor = UIColor.white
            self.lblValues.shadowColor = UIColor.brown
        }
    }
}
