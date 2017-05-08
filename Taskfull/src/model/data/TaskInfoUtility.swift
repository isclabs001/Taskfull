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
    open func GetTaskInfoData() -> [TaskInfoDataEntity] {
        return self._taskInfo.Data
    }
    
    ///
    /// タスク登録データ情報の設定
    ///　- parameter:taskInfoDataEntity:TaskInfoDataEntity
    ///
    open func SetTaskInfoData(_ taskInfoDataEntity : [TaskInfoDataEntity]) {
        self._taskInfo.Data.removeAll()
        self._taskInfo.Data = taskInfoDataEntity
    }
    
    ///
    /// バージョンの取得
    ///　- returns:バージョン情報
    ///
    open func GetVersion() -> String {
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
    /// 現在のカテゴリー形式の取得
    ///　- returns:現在のカテゴリー形式
    ///
    open func GetCategoryType() -> Int {
        return (self._taskInfo.CategoryType)
    }
    
    ///
    /// 現在のカテゴリー形式の設定
    ///　- parameter:categoryType:現在のカテゴリー形式
    ///
    open func SetCategoryType(categoryType : Int) {
        self._taskInfo.CategoryType = categoryType
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
        let _ = taskJsonUtility.writeJSONFile(self._taskInfo)
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
    open func GetIndex(_ id : Int) -> Int {
        
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
    ///　- returns:-1以外:見つかった親IDのインデックス -1:見つからなかった
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
            ret = GetTaskInfoData()[index]
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
        self._taskInfo.Location.removeAll()
    }
    
    ///
    /// タスク登録情報の削除
    ///
    open func DeleteTaskInfo() {
        let taskJsonUtility : TaskJsonUtility = TaskJsonUtility()
        let _ = taskJsonUtility.deleteJSONFile()
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
            ret = GetTaskInfoData()[index]
        }
        
        return ret
    }
    
    ///
    /// 指定した親IDの子タスク登録情報を取得
    ///　- parameter:id:検索対象のID
    ///　- returns:nil以外:見つかったIDのタスク登録情報 nil:見つからなかった
    ///
    open func GetCategoryCount(categoryType : Int) -> Int {

        var ret : Int = 0
        
        // データ数分処理する
        for data in self._taskInfo.Data {
            // 同一カテゴリー、かつ、完了していない場合
            if(data.CategoryType == categoryType
                && CommonConst.TASK_COMPLETE_FLAG_INVALID == data.CompleteFlag) {
                // 件数増加
                ret += 1
            }
        }

        return ret
    }
    
    ///
    /// 位置情報データ情報の取得
    ///　- returns:TaskInfoLocationDataEntity
    ///
    open func GetTaskInfoLocation() -> [TaskInfoLocationDataEntity] {
        return self._taskInfo.Location
    }
    
    ///
    /// 位置情報データ情報の設定
    ///　- parameter:taskInfoLocationDataEntity:TaskInfoLocationDataEntity
    ///
    open func SetTaskInfoLocation(_ taskInfoLocationDataEntity : [TaskInfoLocationDataEntity]) {
        self._taskInfo.Location.removeAll()
        self._taskInfo.Location = taskInfoLocationDataEntity
    }
    
    ///
    /// 指定したIDと一致したIDの位置情報インデックスを取得
    ///　- parameter:id:検索対象の位置ID
    ///　- returns:-1以外:見つかった位置IDのインデックス -1:見つからなかった
    ///
    open func GetIndexForLocation(_ id : Int) -> Int {
        
        // データ数分処理する
        for i in (0 ..< self._taskInfo.Location.count ) {
            // IDが見つかった場合
            if(self._taskInfo.Location[i].Id == id) {
                // インデックスを返す
                return i
            }
        }
        
        // 見つからない場合は「-1」を返す
        return -1
    }
    
    ///
    /// 位置情報の追加
    ///　- parameter:taskInfoLocationDataEntity:TaskInfoLocationDataEntity
    ///
    open func AddLocationInfo(_ taskInfoLocationDataEntity : TaskInfoLocationDataEntity) {
        
        self._taskInfo.Location.append(taskInfoLocationDataEntity)
        
    }
    
    ///
    /// 位置情報の削除
    ///　- parameter:id:削除対象のID
    ///
    open func RemoveLocationInfo(_ id : Int) {
        
        // IDに紐付いているの位置情報インデックスを取得
        let index : Int = GetIndexForLocation(id)
        
        // IDに紐付いている位置情報データが見つかった場合
        if(-1 != index) {
            // 削除する
            self._taskInfo.Location.remove(at: index)
        }
    }
    
    
    ///
    /// 指定したIDの位置情報を取得
    ///　- parameter:id:検索対象のID
    ///　- returns:nil以外:見つかったIDの位置情報 nil:見つからなかった
    ///
    open func GetInfoLocationDataForId(_ id : Int) -> TaskInfoLocationDataEntity? {
        
        var ret : TaskInfoLocationDataEntity? = nil
        let index = GetIndexForLocation(id)
        
        if(-1 < index) {
            ret = GetTaskInfoLocation()[index]
        }
        
        return ret
    }
    
    ///
    ///
    ///　位置情報格納数を取得
    ///　- returns:位置情報格納数
    ///
    open func GetInfoLocationCount() -> Int {

        //
        return self._taskInfo.Location.count
    }
    
    ///
    /// 
    ///　- parameter:id:検索対象のID
    ///　- returns:-1以外:見つかった親IDのインデックス -1:見つからなかった
    ///
    open func GetInfoLocationEmptyIndex(_ Id : Int) -> Int {
        
        // データ数分処理する
        for i in (0 ..< self._taskInfo.Location.count) {
            // が見つかった場合
            if(self._taskInfo.Location[i].Id == 0) {
                // インデックスを返す
                return i
            }
        }
        
        // 見つからない場合は「-1」を返す
        return -1
    }
    
    
}
