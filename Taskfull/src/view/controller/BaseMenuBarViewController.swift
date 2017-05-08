//
//  BaseMenuBarViewController.swift
//  Taskfull
//
//  Created by IscIsc on 2017/05/01.
//  Copyright © 2017年 isc. All rights reserved.
//


import UIKit

///
/// 基底メニューバークラス
///
class BaseMenuBarViewController : BaseViewController {

    /// メインナビゲーションコントローラー
    open var mainUINavigationController : UINavigationController? = nil
    
    ///
    /// MainViewController取得処理
    ///　- returns:nil以外:MainViewController nil:取得できなかった
    ///
    func getMainViewController() -> MainViewController? {
        // navigationControllerが有効な場合
        if nil != self.mainUINavigationController {
            // navigationControllerのview数分処理する
            for cntl : UIViewController in self.mainUINavigationController!.viewControllers {
                // MainViewControllerの場合
                if let parrentMainViewController = cntl as? MainViewController {
                    // MainViewControllerを返す
                    return parrentMainViewController
                }
            }
        }
        
        // nilを返す
        return nil
    }
    
    ///
    /// MainViewController切替処理
    ///　- parameter mainMenuType:CommonConst.MainMenuType
    ///
    func setMainViewController(mainMenuType: CommonConst.MainMenuType) {
        
        // MainViewControllerが有効な場合
        if let parrentMainViewController = getMainViewController() {
            // 画面遷移フラグを設定
            parrentMainViewController.transDisplayFlag = mainMenuType
            
            // メインメニュー形式
            switch(mainMenuType) {
            // タスク追加、GPS設定の場合
            case CommonConst.MainMenuType.taskAdd, CommonConst.MainMenuType.configGps:
                // キャンセルフラグを立てる
                parrentMainViewController.cancelFlag = true
                // 画面を切り替える
                self.slideMenuController()?.changeMainViewController(self.mainUINavigationController!, close: true)
                break
            // 上記以外の場合
            default:
                // キャンセルフラグを落とす
                parrentMainViewController.cancelFlag = false
                // 画面を切り替える
                self.slideMenuController()?.changeMainViewController(self.mainUINavigationController!, close: true)
                break
            }
        }
    }
    
}
