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
            let center : UNUserNotificationCenter = UNUserNotificationCenter.current()
            //　ローカル通知初期化
            center.removeAllPendingNotificationRequests()

            // 通知デリゲート設定
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
                let calender : Calendar = Calendar(identifier:.gregorian)
                
                // システム日付取得
                let systemDate : Date = Date()
                
                //　未完了タスク数分処理
                for item in self.getIncompleteTaskData() {
                    // タスクの通知設定処理
                    self.setNotifiedTask(center : center, taskInfoData : item, systemDate : systemDate, calender : calender)
                }
            })

        // iOS 10.0より前の場合
        } else {
            // 処理しない
            return
        }
    }

    ///
    /// タスク通知設定処理
    ///　- parameter center:UNUserNotificationCenter
    ///　- parameter taskInfoData:タスク情報
    ///　- parameter systemDate:システム日付
    ///　- parameter calender:Calendar
    ///
    fileprivate func setNotifiedTask(center : UNUserNotificationCenter, taskInfoData : TaskInfoDataEntity, systemDate : Date, calender : Calendar) {
        //　DEBUG：ローカル通知日時
        #if DEBUG
            print("-----------------------------------")
            print("タスク項目名:" + taskInfoData.Title)
        #endif

        // タスク完了時間
        let taskDate : Date = FunctionUtility.yyyyMMddHHmmssToDate(taskInfoData.DateTime)
        
        // 現在秒以降の場合
        if(0 <= FunctionUtility.DiffSec(taskDate, date2: systemDate)) {
            // 通知を設定する
            setNotifiedTask(center : center, taskInfoData : taskInfoData, systemDate : systemDate, calender : calender, taskDate : taskDate, key : String(taskInfoData.Id), addMessage : StringUtility.EMPTY)
            
            // 事前設定通知
            setBeforeNotifiedTask(center : center, taskInfoData : taskInfoData, systemDate : systemDate, calender : calender, taskDate : taskDate)
        }
        
        // GPS位置通知設定
        setNotifiedLocation(center : center, taskInfoData : taskInfoData)
    }
    
    ///
    /// タスク通知設定処理
    ///　- parameter center:UNUserNotificationCenter
    ///　- parameter taskInfoData:タスク情報
    ///　- parameter systemDate:システム日付
    ///　- parameter calender:Calendar
    ///　- parameter taskDate:タスク完了日時
    ///　- parameter key:登録キー
    ///　- parameter addMessage:追加メッセージ
    ///
    fileprivate func setNotifiedTask(center : UNUserNotificationCenter, taskInfoData : TaskInfoDataEntity, systemDate : Date, calender : Calendar, taskDate : Date, key : String, addMessage : String) {
        
        // 現在秒以降の場合
        if(0 <= FunctionUtility.DiffSec(taskDate, date2: systemDate)) {
            // UNMutableNotificationContent作成
            let content = UNMutableNotificationContent()
        
            // 通知タイトル設定
            content.title = String(taskInfoData.Title) + ((0 < addMessage.length) ? StringUtility.HALF_SPACE + addMessage : StringUtility.EMPTY)
            
            // メモが空欄である場合
            if(true == StringUtility.isEmpty(taskInfoData.Memo)){
                //通知ボディ = 空白文字挿入
                content.body = StringUtility.HALF_SPACE
            }
            else{
                //通知ボディ ＝ メモ設定
                content.body = String(taskInfoData.Memo)
            }
        
            // 通知サウンド:デフォルト
            content.sound = UNNotificationSound.default()
        
            // 画像パスが取得できた場合
            if let path = Bundle.main.path(forResource: CommonConst.TASK_BUTTON_COLOR_RESOURCE[taskInfoData.ButtonColor].stringByDeletingPathExtension, ofType: "png") {
                // 通知に画像を設定する
                content.attachments = [try! UNNotificationAttachment(identifier: taskInfoData.Title + "_" + String(taskInfoData.ButtonColor), url: URL(fileURLWithPath: path), options: nil)]
            }
        
            // タスク終了日時をdateComponetsへ変換
            let dateComponents = calender.dateComponents([.year,.month,.day,.hour,.minute], from: taskDate)
        
            // 変換したタスク日時をトリガーに設定(リピート:なし)
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        
            //　DEBUG：ローカル通知日時
            #if DEBUG
                debugPrint(key)
                debugPrint("------ローカル通知日時------ ")
                debugPrint(calender.dateComponents([.year,.month,.day,.hour,.minute], from: taskDate))
                debugPrint("-------------------------")
            #endif
        
            // UNNotificationRequest作成(identifier:key,content: タスク内容,trigger: 設定日時)
            let request = UNNotificationRequest.init(identifier: key, content: content, trigger: trigger)
        
            // UNUserNotificationCenterに作成したUNNotificationRequestを追加
            center.add(request)
        }
    }
    
    ///
    /// 事前タスク通知設定処理
    ///　- parameter center:UNUserNotificationCenter
    ///　- parameter taskInfoData:タスク情報
    ///　- parameter systemDate:システム日付
    ///　- parameter calender:Calendar
    ///　- parameter taskDate:タスク完了日時
    ///
    fileprivate func setBeforeNotifiedTask(center : UNUserNotificationCenter, taskInfoData : TaskInfoDataEntity, systemDate : Date, calender : Calendar, taskDate : Date) {

        // 事前通知設定値取得
        let configBeforeNotified : [Int] = [
            TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().MinuteAgo5,
            TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().MinuteAgo10,
            TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().MinuteAgo15,
            TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().MinuteAgo30,
            TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().HoursAgo1,
            TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().HoursAgo3,
            TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().HoursAgo6
        ]
        let addMessage : [String] = [
            "ConfigNoticeTime5MinutesAgo",
            "ConfigNoticeTime10MinutesAgo",
            "ConfigNoticeTime15MinutesAgo",
            "ConfigNoticeTime30MinutesAgo",
            "ConfigNoticeTime1HoursAgo",
            "ConfigNoticeTime3HoursAgo",
            "ConfigNoticeTime6HoursAgo",
        ]
        
        // 設定値数分処理する
        for i in (0 ..< configBeforeNotified.count) {
            // 有効な場合
            if(CommonConst.ON == configBeforeNotified[i]){
                // タスク完了時間から事前通知時間を算出する
                let diffDate = taskDate.addingTimeInterval(Double(CommonConst.BEFORE_NOTIFICATION_TIME_SEC[i] * -1))
                
                // 通知を設定する
                setNotifiedTask(center : center, taskInfoData : taskInfoData, systemDate : systemDate, calender : calender, taskDate : diffDate, key : String(taskInfoData.Id) + "_before_" + String(i), addMessage : MessageUtility.getMessage(key: addMessage[i]))
            }
        }
    }
    
    ///
    /// 位置通知設定処理
    ///　- parameter center:UNUserNotificationCenter
    ///　- parameter taskInfoData:タスク情報
    ///
    fileprivate func setNotifiedLocation(center : UNUserNotificationCenter, taskInfoData : TaskInfoDataEntity) {
        // GPS通知作成処理
        // 通知地点初期値(未設定)ではない場合
        if(taskInfoData.NotifiedLocation != CommonConst.INPUT_NOTIFICATION_POINT_LIST_INITIAL_VALUE){
            // UNMutableNotificationContent作成
            let content = UNMutableNotificationContent()
            
            // GPS用　UNMutableNotificationContent作成
            content.title = String((taskInfoData.Title) + "_IN")
            
            //メモが空欄である場合
            if(true == StringUtility.isEmpty(taskInfoData.Memo)){
                //通知ボディ = 空白文字挿入※空欄対策
                content.body = " "
            }
            else{
                //通知ボディ ＝ メモ設定
                content.body = String(taskInfoData.Memo)
            }
            //通知サウンド:デフォルト
            content.sound = UNNotificationSound.default()
            
            
            // TaskInfoLocationDataEntity
            let taskLocationDataEntity : TaskInfoLocationDataEntity  = TaskInfoUtility.DefaultInstance.GetInfoLocationDataForId(taskInfoData.NotifiedLocation)!
            
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
            let region = CLCircularRegion(center: coordinate, radius: CommonConst.NOTIFICATION_GEOFENCE_RADIUS_RANGE, identifier: "region" + taskInfoData.Title)
            
            // 設定地点に範囲に入った時に通知する
            region.notifyOnEntry = true
            region.notifyOnExit = false
            
            // GPS通知トリガー作成(通知範囲,通知リピートなし)
            let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: false)
            
            // GPS通知リクエスト作成(identifier: 項目名 + "_GPS",content: content,trigger: locationTrigger)
            let locationRequest = UNNotificationRequest(identifier: String(taskInfoData.Id) + "_GPS", content: content, trigger: locationTrigger)
            
            // UNUserNotificationCenterに作成したUNNotificationRequestを追加
            center.add(locationRequest)
        }
    }
    
    ///
    /// 未完了タスクEntity取得処理
    /// - Returns: 未完了タスクEntity
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
    
    
    @available(iOS 10.0, *)
    ///
    /// フォアグラウンド時:ローカル通知受信時イベント
    ///
    /// - Parameters:
    ///   - center: UNUserNotificationCenter
    ///   - notification: notification
    ///   - completionHandler: completionHandler
    ///
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // ローカル通知：バッジ、サウンド、アラート
        completionHandler([.badge,.sound, .alert])
        
        // アイコンバッジ追加処理:仮実装
        //UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        
    }
    
    @available(iOS 10.0, *)
    ///
    /// ローカル通知タップ時イベント
    ///
    /// - Parameters:
    ///   - center: UNUserNotificationCenter
    ///   - response: UNNotificationResponse
    ///   - completionHandler: completionHandler
    ///
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // アイコンバッジ初期化処理:テスト実装
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        //通知：なし
        completionHandler()
    }
}
