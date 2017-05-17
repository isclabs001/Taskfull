//
//  NotificationUtility.swift
//  Taskfull
//
//  Created by IscIsc on 2017/05/17.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import NotificationCenter

///
/// 通知共通関数群
///
open class NotificationUtility : NSObject, UNUserNotificationCenterDelegate
{
   /**
     * 定数定義
     */
    
    /**
     * 変数定義
     */
    /**
     * NotificationUtilityシングルトン変数
     */
    open static var DefaultInstance : NotificationUtility = NotificationUtility()
    
    ///
    /// タスクローカル通知生成処理
    ///
    open func taskExpirationNotification(){
        
        //　iOS 10.0以降の場合
        if #available(iOS 10.0, *) {
            //　ローカル通知初期化
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

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
                    
                    // 画像パスが取得できた場合
                    if let path = Bundle.main.path(forResource: CommonConst.TASK_BUTTON_COLOR_RESOURCE[item.ButtonColor].stringByDeletingPathExtension, ofType: "png") {
                        // 通知に画像を設定する
                        content.attachments = [try! UNNotificationAttachment(identifier: item.Title + "_" + String(item.ButtonColor), url: URL(fileURLWithPath: path), options: nil)]
                    }
                    
                    // タスク終了日時をdateComponetsへ変換
                    let dateComponents =   calender.dateComponents([.year,.month,.day,.hour,.minute], from: FunctionUtility.yyyyMMddHHmmssToDate(item.DateTime))
                    
                    // 変換したタスク日時をトリガーに設定(リピート:なし)
                    let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
                    
                    
                    //　DEBUG：ローカル通知日時
                    #if DEBUG
                        debugPrint("------ローカル通知日時------")
                        debugPrint(calender.dateComponents([.year,.month,.day,.hour,.minute], from: FunctionUtility.yyyyMMddHHmmssToDate(item.DateTime)))
                        debugPrint("-------------------------")
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
                            debugPrint("------ローカル通知指定座標------")
                            debugPrint("地点名:" + taskLocationDataEntity.Title)
                            debugPrint("緯度:" + String(taskLocationDataEntity.Latitude))
                            debugPrint("経度:" + String(taskLocationDataEntity.Longitude))
                            debugPrint("----------------------------")
                            debugPrint("-----------------------------------")
                        #endif
                        
                        
                        // 通知範囲指定
                        let region = CLCircularRegion(center: coordinate, radius: CommonConst.NOTIFICATION_GEOFENCE_RADIUS_RANGE, identifier: "region" + item.Title)
                        
                        // 設定地点に範囲に入った時に通知する
                        region.notifyOnEntry = true
                        region.notifyOnExit = false
                        
                        // GPS通知トリガー作成(通知範囲,通知リピートなし)
                        let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: false)
                        
                        // GPS通知リクエスト作成(identifier: 項目名 + "_GPS",content: content,trigger: locationTrigger)
                        let locationRequest = UNNotificationRequest(identifier: String(item.Id) + "_GPS",content: content,trigger: locationTrigger)
                        
                        // UNUserNotificationCenterに作成したUNNotificationRequestを追加
                        center.add(locationRequest)
                    }
                    
                }
                
            })

        // iOS 10.0より前の場合
        } else {
            // 処理しない
            return
        }
    }
    
    
    /// 未完了タスクEntity取得処理
    ///
    /// - Returns: 未完了タスクEntity
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
    
    
    @available(iOS 10.0, *)
    /// フォアグラウンド時:ローカル通知受信時イベント
    ///
    /// - Parameters:
    ///   - center: UNUserNotificationCenter
    ///   - notification: notification
    ///   - completionHandler: completionHandler
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // ローカル通知：バッジ、サウンド、アラート
        completionHandler([.badge,.sound, .alert])
        
        // アイコンバッジ追加処理:仮実装
        //UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        
    }
    
    @available(iOS 10.0, *)
    /// ローカル通知タップ時イベント
    ///
    /// - Parameters:
    ///   - center: UNUserNotificationCenter
    ///   - response: UNNotificationResponse
    ///   - completionHandler: completionHandler
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // アイコンバッジ初期化処理:テスト実装
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        //通知：なし
        completionHandler()
    }
}
