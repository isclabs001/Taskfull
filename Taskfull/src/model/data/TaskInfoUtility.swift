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