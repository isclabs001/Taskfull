//
//  MainMenuBarSubItemCell.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/26.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

struct MainMenuBarSubItemCellData {
    
    init(mainMenu: Int, title: String, backgroundColor: UIColor) {
        self.mainMenu = mainMenu
        self.title = title
        self.backgroundColor = backgroundColor
    }
    var mainMenu: Int
    var title: String
    var backgroundColor: UIColor
}

class MainMenuBarSubItemCell : BaseTableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgImage: UIImageView!

    override class func height() -> CGFloat {
        return 120
    }
    
    override func setData(_ data: Any?) {
        // MainMenuBarSubItemCellDataが取得できた場合
        if let data = data as? MainMenuBarSubItemCellData {
            // セル情報設定
            self.lblTitle.text = data.title
            self.backgroundColor = data.backgroundColor
            self.lblTitle.textColor = UIColor.white
            self.lblTitle.shadowColor = UIColor.brown
        }
    }
}
