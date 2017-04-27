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
    
    /// OKボタン押下有無
    var isOkBtn : Bool = false
    
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
    
    ///
    /// 再描画処理
    ///
    func redraw()
    {
    }
  
    ///
    /// viewWillDisappearイベント
    ///　- parameter animated:アニメーションフラグ
    ///
    override func viewWillDisappear(_ animated: Bool) {
        // ナビゲーションコントローラが有効な場合
        if(nil != self.navigationController && false == self.isOkBtn){
            // ナビゲーションコントローラからビューコントロールを取得
            let viewControllers = self.navigationController?.viewControllers
            // 自分自身がいない場合
            if nil == indexOfArray(array: viewControllers!, searchObject: self) {
                // 戻るボタンが押された処理
                onClickNavigationBackBtn()
            }
        }
        
        // 規定のviewWillDisappearイベント処理
        super.viewWillDisappear(animated)
    }
    
    ///
    /// ビューコントロール配列から検索対象のビューコントロールを検索する
    ///　- parameter array:ビューコントロールの配列
    ///　- parameter searchObject:検索対象のビューコントロール
    ///　- returns:nil以外:存在する nil:存在しない
    ///
    func indexOfArray(array:[AnyObject], searchObject: AnyObject)-> Int? {
        for (index, value) in array.enumerated() {
            if value as! UIViewController == searchObject as! UIViewController {
                return index
            }
        }
        return nil
    }
    
    ///
    /// ナビゲーションからの戻るボタン押下処理
    ///
    func onClickNavigationBackBtn() {
    }
}
