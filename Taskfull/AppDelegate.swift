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
    let locationManager : CLLocationManager! = CLLocationManager()
    
    ///
    /// スライドメニューありのメイン画面作成処理
    ///
    fileprivate func createMainSlideMenuView() {
        
        // create viewController code...
        // メイン画面のストーリーボード取得
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // メイン画面のコントローラーを取得
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainStoryBoard") as! MainViewController
        // メインメニューバー画面のコントローラーを取得
        let mainMenuBarViewController = storyboard.instantiateViewController(withIdentifier: "MainMenuBarStoryBoard") as! MainMenuBarViewController

        // メイン画面にメニューバーのコントローラを設定
        mainViewController.taskManuBarController = mainMenuBarViewController
        
        // メイン画面のナビゲーターコントローラを取得
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        // メインメニューバー画面にメイン画面のナビゲータコントローラを指定する
        mainMenuBarViewController.mainViewController = nvc
        
        // ExSlideMenuControllerを生成（メイン画面と左にメインメニューバー画面）
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: mainMenuBarViewController)
        // スクロールユーの装飾をする
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        // ExSlideMenuControllerのデリゲートをメイン画面に設定する
        slideMenuController.delegate = mainViewController
        // 初期表示画面をExSlideMenuControllerに設定する。
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
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
        
        // 通知用LocationManager:Delegate設定
        self.locationManager.delegate = self
        // 初回起動時、GPS認証ダイアログ表示(常に許可)※使用時のみでも可？
        self.locationManager.requestAlwaysAuthorization()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

