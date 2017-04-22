//
//  TaskInfoUtility.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/01.
//  Copyright © 2017年 isc. All rights reserved.
//

import Foundation

open class TaskInfoUtility {
    /**
     * 定数定義
     */

    /**
     * 変数定義
     */
    /**
     * TaskInfoUtilityシングルトン変数
     */
    open static var DefaultInstance : TaskInfoUtility = TaskInfoUtility()
    
    /**
     * TaskInfoHeaderEntity変数
     */
    fileprivate var _taskInfo : TaskInfoHeaderEntity = TaskInfoHeaderEntity()
    
    /**
     * 初期化
     */
    public init() {
        // タスク登録情報の読込
        ReadTaskInfo()
    }
    
    ///
    /// タスク登録データ情報の取得
    ///　- returns:TaskInfoDataEntity
    ///
    open func getTaskInfoData() -> [TaskInfoDataEntity] {
        return self._taskInfo.Data
    }
    
    ///
    /// タスク登録データ情報の設定
    ///　- parameter:taskInfoDataEntity:TaskInfoDataEntity
    ///
    open func setTaskInfoData(_ taskInfoDataEntity : [TaskInfoDataEntity]) {
        self._taskInfo.Data.removeAll()
        self._taskInfo.Data = taskInfoDataEntity
    }
    
    ///
    /// バージョンの取得
    ///　- returns:バージョン情報
    ///
    open func getVersion() -> String {
        return (self._taskInfo.Version)
    }
    
    ///
    /// 次IDの採番
    ///　- returns:次ID
    ///
    open func NextId() -> Int {
        self._taskInfo.AssignmentId += 1
        return (self._taskInfo.AssignmentId)
    }
    
    ///
    /// タスク登録情報の読込み
    ///
    open func ReadTaskInfo() {
        let taskJsonUtility : TaskJsonUtility = TaskJsonUtility()
        self._taskInfo = taskJsonUtility.readJSONFile()
    }
    
    ///
    /// タスク登録情報の保存
    ///
    open func WriteTaskInfo() {
        let taskJsonUtility : TaskJsonUtility = TaskJsonUtility()
        taskJsonUtility.writeJSONFile(self._taskInfo)
    }
    
    ///
    /// タスク登録情報の追加
    ///　- parameter:taskInfoDataEntity:TaskInfoDataEntity
    ///
    open func AddTaskInfo(_ taskInfoDataEntity : TaskInfoDataEntity) {
        self._taskInfo.Data.append(taskInfoDataEntity)
    }
    
    ///
    /// タスク登録情報の削除
    ///　- parameter:id:削除対象のID
    ///
    open func RemoveTaskInfo(_ id : Int) {
        
        // IDに紐付いているのインデックスを取得
        let index : Int = GetIndex(id)
        
        // IDに紐付いているデータが見つかった場合
        if(-1 != index) {
            // 削除する
            self._taskInfo.Data.remove(at: index)
        }
    }
    
    ///
    /// 親IDに紐付いているタスク登録情報の削除
    ///　- parameter:id:削除対象の親ID
    ///
    open func RemoveTaskInfoForChild(_ parrentId : Int) {

        // 親IDに紐付いている子供のインデックスを取得
        let index : Int = GetParrentIndex(parrentId)

        // 親IDに紐付いている子供が見つかった場合
        if(-1 != index) {
            // 削除する
            self._taskInfo.Data.remove(at: index)
        }
    }
    
    ///
    /// 指定したIDと一致したIDのタスク登録情報インデックスを取得
    ///　- parameter:id:検索対象のID
    ///　- returns:-1以外:見つかったIDのインデックス -1:見つからなかった
    ///
    fileprivate func GetIndex(_ id : Int) -> Int {
        
        // データ数分処理する
        for i in (0 ..< self._taskInfo.Data.count ) {
            // IDが見つかった場合
            if(self._taskInfo.Data[i].Id == id) {
                // インデックスを返す
                return i
            }
        }
            
        // 見つからない場合は「-1」を返す
        return -1
    }
    
    ///
    /// 指定した親IDと一致した親IDのタスク登録情報インデックスを取得
    ///　- parameter:id:検索対象のID
    ///　- returns:-1以外:見つかったIDのインデックス -1:見つからなかった
    ///
    open func GetParrentIndex(_ parrentId : Int) -> Int {
        
        // データ数分処理する
        for i in (0 ..< self._taskInfo.Data.count) {
            // 親IDが見つかった場合
            if(self._taskInfo.Data[i].ParrentId == parrentId) {
                // インデックスを返す
                return i
            }
        }
        
        // 見つからない場合は「-1」を返す
        return -1
    }
    
    ///
    /// 指定したIDのタスク登録情報を取得
    ///　- parameter:id:検索対象のID
    ///　- returns:nil以外:見つかったIDのタスク登録情報 nil:見つからなかった
    ///
    open func GetTaskInfoDataForId(_ id : Int) -> TaskInfoDataEntity? {

        var ret : TaskInfoDataEntity? = nil
        let index = GetIndex(id)
        
        if(-1 < index) {
            ret = getTaskInfoData()[index]
        }
        
        return ret
    }
    
    ///
    /// 指定したタスク登録情報を設定
    ///　- parameter:setData:設定対象のタスク登録情報
    ///
    open func SetTaskInfoDataForId(_ setData : TaskInfoDataEntity) {
        
        // IDに対する配列インデックスを取得する
        let index = GetIndex(setData.Id)
        
        // 存在する場合
        if(-1 < index) {
            // 置き換える
            self._taskInfo.Data.remove(at: index)
            self._taskInfo.Data.insert(setData, at: index)
            
        // 上記以外の場合
        } else {
            // 追加する
            self._taskInfo.Data.append(setData)
        }
    }

    ///
    /// 指定したタスク登録情報を設定
    ///　- parameter:setData:設定対象のタスク登録情報
    ///
    open func SetTaskInfoDataForComplete(_ id : Int) {
        
        // IDに対する配列インデックスを取得する
        let index = GetIndex(id)
        
        // 存在する場合
        if(-1 < index) {
            // 完了フラグ設定
            self._taskInfo.Data[index].CompleteFlag = CommonConst.TASK_COMPLETE_FLAG_VALID
            self._taskInfo.Data[index].UpdateDateTime = GetSystemDate()
        }
    }
    
    ///
    /// システム日付取得
    ///
    open func GetSystemDate() -> String {
        return FunctionUtility.DateToyyyyMMddHHmmss(Date(), separation: true)
    }

    ///
    /// タスク登録情報のクリア
    ///
    open func ClearTaskInfo() {
        // タスク登録情報のクリア
        self._taskInfo.AssignmentId = 0
        self._taskInfo.Data.removeAll()
    }
    
    ///
    /// タスク登録情報の削除
    ///
    open func DeleteTaskInfo() {
        let taskJsonUtility : TaskJsonUtility = TaskJsonUtility()
        taskJsonUtility.deleteJSONFile()
    }
    
    
    ///
    /// 指定した親IDの子タスク登録情報を取得
    ///　- parameter:id:検索対象のID
    ///　- returns:nil以外:見つかったIDのタスク登録情報 nil:見つからなかった
    ///
    open func GetParrentTaskInfoDataForId(_ id : Int) -> TaskInfoDataEntity? {
        
        var ret : TaskInfoDataEntity? = nil
        let index = GetParrentIndex(id)
        
        if(-1 < index) {
            ret = getTaskInfoData()[index]
        }
        
        return ret
    }
    
}
