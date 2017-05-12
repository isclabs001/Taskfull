//
//  ExSlideMenuController.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/26.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

//
// ExSlideMenuControllerクラス
//
class ExSlideMenuController : SlideMenuController {
    ///
    /// 手前に表示されているMainViewControllerの判定処理
    ///　- returns true:手前にMainViewControllerが表示されている false:表示されていない
    ///
    override func isTagetViewController() -> Bool {
        if let vc = UIApplication.topViewController() {
            if vc is MainViewController {
                return true
            }
        }
        return false
    }
}
