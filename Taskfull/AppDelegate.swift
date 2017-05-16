//
//  AppDelegate.swift
//  Taskfull
//
//  Created by IscIsc on 2017/02/24.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import NotificationCenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,CLLocationManagerDelegate,UNUserNotificationCenterDelegate{

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
        // スクロールビューの装飾（枠の凹み）を自動調整する
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
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


    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //　DEBUG：補足座標
        #if DEBUG
        print("緯度：" + String(describing: manager.location?.coordinate.latitude))
        print("経度：" + String(describing: manager.location?.coordinate.longitude))
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
        
        // LocationManager初期設定処理
        setupLocationManager()
        
        // タスクローカル通知生成処理
        taskExpirationNotification()
        
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
        taskExpirationNotification()
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
        taskExpirationNotification()
        
    }

    ///
    /// applicationWillEnterForegroundイベント処理
    ///　- parameter application:UIApplication
    ///
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

        // アプリケーションがフォアグラウンドに移行する際にイベントを通知する
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        // LocationManager初期設定処理
        setupLocationManager()
        
        // タスク通知生成処理
        taskExpirationNotification()
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
    
    
    // タスクローカル通知生成処理
    fileprivate func taskExpirationNotification(){
        
        //　ローカル通知初期化
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
        } else {
            // Fallback on earlier versions
        };
        
        
        if #available(iOS 10.0, *) {
            
            // 通知デリゲート設定
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            
            // 通知種類(バッチ,サウンド,アラート)
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if error != nil {
                    return
                }
                
                // DEBUG:通知権限判定
                #if DEBUG
                if granted {
                    debugPrint("通知許可")
                } else {
                    debugPrint("通知拒否")
                }
                debugPrint("ローカル通知設定開始")
                #endif
                
                //　DateComponents変換用カレンダー生成(西暦)
                let calender  =  Calendar(identifier:.gregorian)
                
                //　未完了タスク数分処理
                for item in self.getIncompleteTaskData() {
                    
                    //　DEBUG：ローカル通知日時
                    #if DEBUG
                        print("-----------------------------------")
                        print("タスク項目名:" + item.Title)
                    #endif
                    
                    
                    // UNMutableNotificationContent作成
                    let content = UNMutableNotificationContent()
                    
                    // 通知タイトル設定
                    content.title = String(item.Title)
                    
                    // メモが空欄である場合
                    if(true == StringUtility.isEmpty(item.Memo)){
                        //通知ボディ = 空白文字挿入
                        content.body = " "
                    }
                    else{
                        //通知ボディ ＝ メモ設定
                        content.body = String(item.Memo)
                    }
                    
                    // 通知サウンド:デフォルト
                    content.sound = UNNotificationSound.default()
                    
                    // 画像TODO:冗長の為、要修正
                    switch item.ButtonColor {
                        
                    case CommonConst.TASK_BUTTON_COLOR_WHITE:
                        
                        if let path = Bundle.main.path(forResource: "soap001", ofType: "png") {
                            content.attachments = [try! UNNotificationAttachment(identifier: item.Title + "_" + String(item.ButtonColor), url: URL(fileURLWithPath: path), options: nil)]
                        }
                    case CommonConst.TASK_BUTTON_COLOR_LIGHT_BLUE:
                        
                        if let path = Bundle.main.path(forResource: "soap002", ofType: "png") {
                            content.attachments = [try! UNNotificationAttachment(identifier: item.Title + "_" + String(item.ButtonColor), url: URL(fileURLWithPath: path), options: nil)]
                        }
                    case CommonConst.TASK_BUTTON_COLOR_GLAY:
                        
                        if let path = Bundle.main.path(forResource: "soap003", ofType: "png") {
                            content.attachments = [try! UNNotificationAttachment(identifier: item.Title + "_" + String(item.ButtonColor), url: URL(fileURLWithPath: path), options: nil)]
                        }
                    case CommonConst.TASK_BUTTON_COLOR_GREEN:
                        
                        if let path = Bundle.main.path(forResource: "soap004", ofType: "png") {
                            content.attachments = [try! UNNotificationAttachment(identifier: item.Title + "_" + String(item.ButtonColor), url: URL(fileURLWithPath: path), options: nil)]
                        }
                    case CommonConst.TASK_BUTTON_COLOR_ORANGE:
                        
                        if let path = Bundle.main.path(forResource: "soap005", ofType: "png") {
                            content.attachments = [try! UNNotificationAttachment(identifier: item.Title + "_" + String(item.ButtonColor), url: URL(fileURLWithPath: path), options: nil)]
                        }
                    case CommonConst.TASK_BUTTON_COLOR_BLUE:
                        
                        if let path = Bundle.main.path(forResource: "soap006", ofType: "png") {
                            content.attachments = [try! UNNotificationAttachment(identifier: item.Title + "_" + String(item.ButtonColor), url: URL(fileURLWithPath: path), options: nil)]
                        }
                    case CommonConst.TASK_BUTTON_COLOR_YELLOW:
                        
                        if let path = Bundle.main.path(forResource: "soap007", ofType: "png") {
                            content.attachments = [try! UNNotificationAttachment(identifier: item.Title + "_" + String(item.ButtonColor), url: URL(fileURLWithPath: path), options: nil)]
                        }
                    case CommonConst.TASK_BUTTON_COLOR_PINK:
                        
                        if let path = Bundle.main.path(forResource: "soap008", ofType: "png") {
                            content.attachments = [try! UNNotificationAttachment(identifier: item.Title + "_" + String(item.ButtonColor), url: URL(fileURLWithPath: path), options: nil)]
                        }
                    case CommonConst.TASK_BUTTON_COLOR_PURPLE:
                        
                        if let path = Bundle.main.path(forResource: "soap009", ofType: "png") {
                            content.attachments = [try! UNNotificationAttachment(identifier: item.Title + "_" + String(item.ButtonColor), url: URL(fileURLWithPath: path), options: nil)]
                        }
                    case CommonConst.TASK_BUTTON_COLOR_DARK_YELLOW:
                        
                        if let path = Bundle.main.path(forResource: "soap010", ofType: "png") {
                            content.attachments = [try! UNNotificationAttachment(identifier: item.Title + "_" + String(item.ButtonColor), url: URL(fileURLWithPath: path), options: nil)]
                        }
                    case CommonConst.TASK_BUTTON_COLOR_DARK_PINK:
                        
                        if let path = Bundle.main.path(forResource: "soap011", ofType: "png") {
                            content.attachments = [try! UNNotificationAttachment(identifier: item.Title + "_" + String(item.ButtonColor), url: URL(fileURLWithPath: path), options: nil)]
                        }
                    case CommonConst.TASK_BUTTON_COLOR_DARK_PURPLE:
                        
                        if let path = Bundle.main.path(forResource: "soap012", ofType: "png") {
                            content.attachments = [try! UNNotificationAttachment(identifier: item.Title + "_" + String(item.ButtonColor), url: URL(fileURLWithPath: path), options: nil)]
                        }
                    default:
                        break;
                    }
                    
                    
                    
                    // タスク終了日時をdateComponetsへ変換
                    let dateComponents =   calender.dateComponents([.year,.month,.day,.hour,.minute], from: FunctionUtility.yyyyMMddHHmmssToDate(item.DateTime))
                    
                    // 変換したタスク日時をトリガーに設定(リピート:なし)
                    let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
                    

                    //　DEBUG：ローカル通知日時
                    #if DEBUG
                    print("------ローカル通知日時------")
                    print(calender.dateComponents([.year,.month,.day,.hour,.minute], from: FunctionUtility.yyyyMMddHHmmssToDate(item.DateTime)))
                    print("-------------------------")
                    #endif
                        
                    // UNNotificationRequest作成(identifier:タスクID,content: タスク内容,trigger: 設定日時)
                    let request = UNNotificationRequest.init(identifier: String(item.Id), content: content, trigger: trigger)
                    
                    // UNUserNotificationCenterに作成したUNNotificationRequestを追加
                    center.add(request)
                    
                    // GPS通知作成処理
                    // 通知地点初期値(未設定)ではない場合
                    if(item.NotifiedLocation != CommonConst.INPUT_NOTIFICATION_POINT_LIST_INITIAL_VALUE){

                        // GPS用　UNMutableNotificationContent作成
                        content.title = String((item.Title) + "_IN")
                        
                        //メモが空欄である場合
                        if(true == StringUtility.isEmpty(item.Memo)){
                            //通知ボディ = 空白文字挿入※空欄対策
                            content.body = " "
                        }
                        else{
                            //通知ボディ ＝ メモ設定
                            content.body = String(item.Memo)
                        }
                        //通知サウンド:デフォルト
                        content.sound = UNNotificationSound.default()
                        
                        
                        // TaskInfoLocationDataEntity
                        let taskLocationDataEntity : TaskInfoLocationDataEntity  = TaskInfoUtility.DefaultInstance.GetInfoLocationDataForId(item.NotifiedLocation)!
                        
                        // 通知座標指定
                        let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(taskLocationDataEntity.Latitude,taskLocationDataEntity.Longitude)
                        
                        // DEBUG:ローカル通知指定座標読み出し
                        #if DEBUG
                        print("------ローカル通知指定座標------")
                        debugPrint("地点名:" + taskLocationDataEntity.Title)
                        debugPrint("緯度:" + String(taskLocationDataEntity.Latitude))
                        debugPrint("経度:" + String(taskLocationDataEntity.Longitude))
                        print("----------------------------")
                        print("-----------------------------------")
                        #endif
                            
                        
                        // 通知範囲指定
                        let region = CLCircularRegion(center: coordinate, radius: CommonConst.NOTIFICATION_GEOFENCE_RADIUS_RANGE, identifier: "region" + item.Title)
                        
                        // 通知範囲In
                        region.notifyOnEntry = true
                        
                        // GPS通知トリガー作成(通知範囲,通知リピートなし)
                        let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: true)
                        
                        // GPS通知リクエスト作成(identifier: 項目名 + "_GPS",content: content,trigger: locationTrigger)
                        let locationRequest = UNNotificationRequest(identifier: String(item.Id) + "_GPS",content: content,trigger: locationTrigger)
                        
                        // UNUserNotificationCenterに作成したUNNotificationRequestを追加
                        center.add(locationRequest)
                        
                    }

                }

            })
        }
    }
    
    ///
    /// 未完了タスクデータの取得
    ///　- returns:未完了タスクデータ配列
    ///
    fileprivate func getIncompleteTaskData() -> [TaskInfoDataEntity] {
        
        var taskData : [TaskInfoDataEntity] = [TaskInfoDataEntity]()
        
        // データ数分表示する
        for data in TaskInfoUtility.DefaultInstance.GetTaskInfoData() {
            // 未完了である場合
            if(CommonConst.TASK_COMPLETE_FLAG_INVALID == data.CompleteFlag) {
                
                // 通知対象に追加
                taskData.append(data)
                
            }
        }
        
        // 結果を返す
        return taskData
    }
    
    // フォアグラウンド時:ローカル通知受信時イベント
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
        // ローカル通知：バッジ、サウンド、アラート
        completionHandler([.badge,.sound, .alert])
        
        // アイコンバッジ追加処理:仮実装
        //UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        
    }
    
    // ローカル通知タップ時イベント
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // アイコンバッジ初期化処理:テスト実装
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        //通知：なし
        completionHandler()
    }

}

