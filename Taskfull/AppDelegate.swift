//
//  AppDelegate.swift
//  Taskfull
//
//  Created by IscIsc on 2017/02/24.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,CLLocationManagerDelegate{

    var window: UIWindow?
    
    // 通知用LocationManager:生成&&初期化
    var locationManager : CLLocationManager!
    
    ///
    /// スライドメニューありのメイン画面作成処理
    ///
    fileprivate func createMainSlideMenuView() {
        
        // create viewController code...
        // メイン画面のストーリーボード取得
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // メイン画面のコントローラーを取得
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainStoryBoard") as! MainViewController
        // タスクカテゴリーメニューバー画面のコントローラーを取得
        let taskCategoryMenuBarViewController = storyboard.instantiateViewController(withIdentifier: "TaskCategoryMenuBarStoryBoard") as! TaskCategoryMenuBarViewController
        // メインメニューバー画面のコントローラーを取得
        let mainMenuBarViewController = storyboard.instantiateViewController(withIdentifier: "MainMenuBarStoryBoard") as! MainMenuBarViewController

        // メイン画面にタスクカテゴリーメニューバーのコントローラを設定
        mainViewController.taskCategoryManuBarController = taskCategoryMenuBarViewController
        
        // メイン画面のナビゲーターコントローラを取得
        let mainNavigationController: UINavigationController = UINavigationController(rootViewController: mainViewController)
        // メニューバーに設定する
        taskCategoryMenuBarViewController.mainUINavigationController = mainNavigationController
        mainMenuBarViewController.mainUINavigationController = mainNavigationController
        
        // ExSlideMenuControllerを生成（メイン画面と左にメインメニューバー画面）
        let slideMenuController = ExSlideMenuController(mainViewController: mainNavigationController, leftMenuViewController: taskCategoryMenuBarViewController, rightMenuViewController: mainMenuBarViewController)
        // スクロールユーの装飾をする
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        // ExSlideMenuControllerのデリゲートをメイン画面に設定する
        slideMenuController.delegate = mainViewController
        // 初期表示画面をExSlideMenuControllerに設定する。
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    
    
    // LocationManager初期設定処理
    fileprivate func setupLocationManager(){
        
        // LocationManager:初期化
        locationManager = CLLocationManager()
        // 通知用LocationManager:Delegate設定
        self.locationManager.delegate = self
        // 初回起動時、GPS認証ダイアログ表示(常に許可)
        self.locationManager.requestAlwaysAuthorization()
        
    }
    
    
    
    
    ///
    /// Application起動処理
    ///　- parameter application:UIApplication
    ///　- parameter launchOptions:[UIApplicationLaunchOptionsKey: Any]?
    ///　- returns:true、false
    ///
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // スライドメニューありのメイン画面作成処理
        self.createMainSlideMenuView()
        
        // LocationManager初期設定処理
        setupLocationManager()
        
        return true
    }

    /// Application閉じる直前処理
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    /// Applicationバックグラウンド移行時処理
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        // アプリケーションがバックグラウンドに移行する際にイベントを通知する
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "applicationDidEnterBackground"), object: nil)
    }

    /// Applicationフォアグラウンド移行時処理
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

        // アプリケーションがフォアグラウンドに移行する際にイベントを通知する
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
    }
    
    /// Applicationフォアグラウンド時処理
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    /// Applicationフリック終了時処理
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

