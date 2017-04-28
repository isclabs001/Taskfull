//
//  MainMenuBarSubItemCell.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/26.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

struct MainMenuBarSubItemCellData {
    
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

class MainMenuBarSubItemCell : BaseTableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValues: UILabel!
    @IBOutlet weak var imgCircle: UIImageView!
    
    var category : Int = -1
    
    override class func height() -> CGFloat {
        return 120
    }
    
    override func setData(_ data: Any?) {
        // MainMenuBarSubItemCellDataが取得できた場合
        if let data = data as? MainMenuBarSubItemCellData {
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
