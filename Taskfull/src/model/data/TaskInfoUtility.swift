//
//  TaskInfoUtility.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/01.
//  Copyright © 2017年 isc. All rights reserved.
//

import Foundation

public class TaskInfoUtility {
    /**
     * 定数定義
     */

    /**
     * 変数定義
     */
    /**
     * TaskInfoUtilityシングルトン変数
     */
    public static var DefaultInstance : TaskInfoUtility = TaskInfoUtility()
    
    /**
     * TaskInfoHeaderEntity変数
     */
    private var _taskInfo : TaskInfoHeaderEntity = TaskInfoHeaderEntity()
    
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
    public func getTaskInfoData() -> [TaskInfoDataEntity] {
        return self._taskInfo.Data
    }
    
    ///
    /// タスク登録データ情報の設定
    ///　- parameter:taskInfoDataEntity:TaskInfoDataEntity
    ///
    public func setTaskInfoData(taskInfoDataEntity : [TaskInfoDataEntity]) {
        self._taskInfo.Data.removeAll()
        self._taskInfo.Data = taskInfoDataEntity
    }
    
    ///
    /// バージョンの取得
    ///　- returns:バージョン情報
    ///
    public func getVersion() -> String {
        return (self._taskInfo.Version)
    }
    
    ///
    /// 次IDの採番
    ///　- returns:次ID
    ///
    public func NextId() -> Int {
        self._taskInfo.AssignmentId += 1
        return (self._taskInfo.AssignmentId)
    }
    
    ///
    /// タスク登録情報の読込み
    ///
    public func ReadTaskInfo() {
        let taskJsonUtility : TaskJsonUtility = TaskJsonUtility()
        self._taskInfo = taskJsonUtility.readJSONFile()
    }
    
    ///
    /// タスク登録情報の保存
    ///
    public func WriteTaskInfo() {
        let taskJsonUtility : TaskJsonUtility = TaskJsonUtility()
        taskJsonUtility.writeJSONFile(self._taskInfo)
    }
    
    ///
    /// タスク登録情報の追加
    ///　- parameter:taskInfoDataEntity:TaskInfoDataEntity
    ///
    public func AddTaskInfo(taskInfoDataEntity : TaskInfoDataEntity) {
        self._taskInfo.Data.append(taskInfoDataEntity)
    }
    
    ///
    /// タスク登録情報の削除
    ///　- parameter:id:削除対象のID
    ///
    public func RemoveTaskInfo(id : Int) {
        
        // IDに紐付いているのインデックスを取得
        let index : Int = GetIndex(id)
        
        // IDに紐付いているデータが見つかった場合
        if(-1 != index) {
            // 削除する
            self._taskInfo.Data.removeAtIndex(index)
        }
    }
    
    ///
    /// 親IDに紐付いているタスク登録情報の削除
    ///　- parameter:id:削除対象の親ID
    ///
    private func RemoveTaskInfoForChild(parrentId : Int) {

        // 親IDに紐付いている子供のインデックスを取得
        let index : Int = GetParrentIndex(parrentId)

        // 親IDに紐付いている子供が見つかった場合
        if(-1 != index) {
            // 削除する
            self._taskInfo.Data.removeAtIndex(index)
        }
    }
    
    ///
    /// 指定したIDと一致したIDのタスク登録情報インデックスを取得
    ///　- parameter:id:検索対象のID
    ///　- returns:-1以外:見つかったIDのインデックス -1:見つからなかった
    ///
    private func GetIndex(id : Int) -> Int {
        
        // データ数分処理する
        for(var i = 0 ; i < self._taskInfo.Data.count ; i += 1) {
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
    private func GetParrentIndex(parrentId : Int) -> Int {
        
        // データ数分処理する
        for(var i = 0 ; i < self._taskInfo.Data.count ; i += 1) {
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
    /// タスク登録情報のクリア
    ///
    public func ClearTaskInfo() {
        // タスク登録情報のクリア
        self._taskInfo.AssignmentId = 0
        self._taskInfo.Data.removeAll()
    }
    
    ///
    /// タスク登録情報の削除
    ///
    public func DeleteTaskInfo() {
        let taskJsonUtility : TaskJsonUtility = TaskJsonUtility()
        taskJsonUtility.deleteJSONFile()
    }
}