//
//   BaseViewController.swift
//  SchoolCafeteriaMap
//
//  Created by IscIsc on 2016/07/13.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import UIKit

///
/// UIViewController基底クラス
///
class BaseViewController: UIViewController {
    
    ///
    ///　初期化処理
    ///　- returns:true:正常終了 false:以上終了
    ///
    func initializeProc() ->Bool
    {
        return true
    }

    ///
    /// 処理中画面表示
    ///
    func showProgress()
    {
    }
    
    ///
    /// 処理中画面非表示
    ///
    func hideProgress()
    {
    }
  
}