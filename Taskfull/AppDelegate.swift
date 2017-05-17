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
    
    /// 通知用LocationManager:生成&&初期化
    var locationManager : CLLocationManager! = nil
    
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
        mainViewController.taskCategoryMenuBarController = taskCategoryMenuBarViewController
        // メイン画面にメインメニューバーのコントローラを設定
        mainViewController.mainMenuBarController = mainMenuBarViewController
        
        // メイン画面のナビゲーターコントローラを取得
        let mainNavigationController: UINavigationController = UINavigationController(rootViewController: mainViewController)
        // メニューバーに設定する
        taskCategoryMenuBarViewController.mainUINavigationController = mainNavigationController
        mainMenuBarViewController.mainUINavigationController = mainNavigationController
        
        // ExSlideMenuControllerを生成（メイン画面と左にメインメニューバー画面）
        let slideMenuController = ExSlideMenuController(mainViewController: mainNavigationController, leftMenuViewController: taskCategoryMenuBarViewController, rightMenuViewController: mainMenuBarViewController)
        // スクロールビューの装飾（枠の凹み）を自動調整する
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        // 初期表示画面をExSlideMenuControllerに設定する。
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    
    ///
    /// LocationManager初期設定処理
    ///
    fileprivate func setupLocationManager(){
        
        // LocationManager:初期化
        if(nil == locationManager){
            locationManager = CLLocationManager()
        
            // 通知用LocationManager:Delegate設定
            self.locationManager.delegate = self
        }

        // GPS認証ステータスを取得
        let status = CLLocationManager.authorizationStatus()
        
        // GPS認証がまだである場合(アプリ起動初回のみ)
        if(status == .notDetermined) {
            
           // 初回起動時、GPS認証ダイアログ表示(常に許可)
            self.locationManager.requestAlwaysAuthorization()
            
        }
        
        
        // GPSローカル通知に不要であるためコメントアウト
        /*
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.distanceFilter = 100
        if #available(iOS 9.0, *) {
            self.locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        //locationManager.pausesLocationUpdatesAutomatically = false
        //locationManager.startUpdatingLocation()
        */
        
        // バックグラウンド時：最高精度取得
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
        
        // 位置情報一回のみ取得
        //locationManager.requestLocation()
    }
    
    /// 位置情報サービス通知権限確認アラート
    func LocationManagerAuthorizationStatusAleart() {
        
        if(CLLocationManager.locationServicesEnabled() == true){
            switch CLLocationManager.authorizationStatus() {
                
            //　位置情報サービス権限未設定の場合
            case CLAuthorizationStatus.notDetermined:
                
                // LocationManager:初期化
                if(nil == locationManager){
                    locationManager = CLLocationManager()
                    
                    // 通知用LocationManager:Delegate設定
                    self.locationManager.delegate = self
                }
                
                // 位置情報サービス権限許可通知表示
                locationManager.requestAlwaysAuthorization()
                
            //　機能制限されている場合
            case CLAuthorizationStatus.restricted:
                
                // "位置情報サービスの利用が制限されている為、利用できません。"
                MessageUtility.dispAlertOK(viewController: (self.window?.rootViewController)!, title: "", message: MessageUtility.getMessage(key: "MessageStringCLLocationManagerStatusRestricted"))
                
            //「許可しない」に設定されている場合
            case CLAuthorizationStatus.denied:
                
                // "位置情報サービスの利用が許可されていない為、利用できません。"
                MessageUtility.dispAlertOK(viewController: (self.window?.rootViewController)!, title: "", message: MessageUtility.getMessage(key: "MessageStringCLLocationManagerStatusDenied"))
                
            //「このAppの使用中のみ許可」に設定されている場合
            case CLAuthorizationStatus.authorizedWhenInUse:
                
                // "位置情報サービスの利用が制限されています。"
                MessageUtility.dispAlertOK(viewController: (self.window?.rootViewController)!, title: "", message: MessageUtility.getMessage(key: "MessageStringCLLocationManagerStatusAuthorizedWhenInUse"))
                
            //「常に許可」に設定されている場合
            case CLAuthorizationStatus.authorizedAlways:
                
                break
                
            }
            // 位置情報サービスがOFFの場合
        } else {
            
            // "位置情報サービスがONになっていない為、利用できません。"
            MessageUtility.dispAlertOK(viewController: (self.window?.rootViewController)!, title: "", message: MessageUtility.getMessage(key: "MessageStringCLLocationManagerStatusOFF"))
        }
        
    }
    
    
    /// 位置情報取得時イベント
    ///
    /// - Parameters manager: CLLocationManager
    /// - Parameters locations: CLLocation
    ///
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //　DEBUG：補足座標
        #if DEBUG
        print("位置情報取得日時：" + FunctionUtility.DateToyyyyMMddHHmmss(Date(), separation: true))
        print("緯度：" + String(describing: manager.location?.coordinate.latitude))
        print("経度：" + String(describing: manager.location?.coordinate.longitude))
        #endif
        
    }
    
    /// 位置情報取得失敗時
    ///
    /// - Parameters:
    ///   - manager: CLLocationManager
    ///   - error: Error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        //　DEBUG：位置情報取得失敗
        #if DEBUG
            print("位置情報取得失敗")
            print("位置情報取得失敗日時：" + FunctionUtility.DateToyyyyMMddHHmmss(Date(), separation: true))
        #endif
        
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
        
        // 位置情報サービス通知権限確認アラート
        LocationManagerAuthorizationStatusAleart()
        
        // LocationManager初期設定処理
        setupLocationManager()
        
        // タスクローカル通知生成処理
        NotificationUtility.DefaultInstance.taskExpirationNotification()
        
        return true
    }

    ///
    /// applicationWillResignActiveイベント処理
    ///　- parameter application:UIApplication
    ///
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        // LocationManager初期設定処理
        //setupLocationManager()
        
        // タスク通知生成処理
        NotificationUtility.DefaultInstance.taskExpirationNotification()
    }

    ///
    /// applicationDidEnterBackgroundイベント処理
    ///　- parameter application:UIApplication
    ///
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        // アプリケーションがバックグラウンドに移行する際にイベントを通知する
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "applicationDidEnterBackground"), object: nil)
        
        // LocationManager初期設定処理
        setupLocationManager()
        
        // タスク通知生成処理
        NotificationUtility.DefaultInstance.taskExpirationNotification()
        
    }

    ///
    /// applicationWillEnterForegroundイベント処理
    ///　- parameter application:UIApplication
    ///
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

        // アプリケーションがフォアグラウンドに移行する際にイベントを通知する
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        // 位置情報サービス通知権限確認アラート
        LocationManagerAuthorizationStatusAleart()
        
        // LocationManager初期設定処理
        setupLocationManager()
        
        // タスク通知生成処理
        NotificationUtility.DefaultInstance.taskExpirationNotification()
    }

    ///
    /// applicationDidBecomeActiveイベント処理
    ///　- parameter application:UIApplication
    ///
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    ///
    /// applicationWillTerminateイベント処理
    ///　- parameter application:UIApplication
    ///
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
 }

