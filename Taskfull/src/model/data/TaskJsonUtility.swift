//
//  TaskJsonUtility.swift
//  Taskfull
//
//  Created by IscIsc on 2017/03/31.
//  Copyright © 2017年 isc. All rights reserved.
//

import Foundation


///
/// TaskJsonUtilityクラス
///
public class TaskJsonUtility : BaseJsonDataUtility
{
    /**
     * 定数定義
     */
    /**
     * タスク用JSONファイル名
     */
    static internal let FILE_NAME_TASK_JSON : String = "task.json";

    /**
     * タスク用JSONヘッダー部フィールド名
     */
    static internal let JSON_FIELD_HEADER_VERSION : String = "version";
    static internal let JSON_FIELD_HEADER_ASSIGNMENT_ID : String = "assignment_id";
    static internal let JSON_FIELD_HEADER_DATA : String = "data";
    
    /**
     * タスク用JSONデータ部フィールド名
     */
    static internal let JSON_FIELD_DATA_ID : String = "id";
    static internal let JSON_FIELD_DATA_TITLE : String = "title";
    static internal let JSON_FIELD_DATA_MEMO : String = "memo";
    static internal let JSON_FIELD_DATA_DATETIME : String = "datetime";
    static internal let JSON_FIELD_DATA_NOTIFIED_LOCATION : String = "notified_location";
    static internal let JSON_FIELD_DATA_IMPORTANCE : String = "importance";
    static internal let JSON_FIELD_DATA_BUTTON_COLOR : String = "button_color";
    static internal let JSON_FIELD_DATA_TEXT_COLOR : String = "text_color";
    static internal let JSON_FIELD_DATA_PARRENT_ID : String = "parrent_id";
    static internal let JSON_FIELD_DATA_COMPLETE_FLAG : String = "complete_flag";
    static internal let JSON_FIELD_DATA_CREATE_DATETIME : String = "create_datetime";
    static internal let JSON_FIELD_DATA_UPDATE_DATETIME : String = "update_datetime";

    ///
    ///　タスク用JSONオブジェクトの初期データ作成
    ///　- returns:初期データ[String:AnyObject]
    ///
    func initData() -> [String:AnyObject] {
        // Dictionaryを生成
        var taskHeader : Dictionary<String, AnyObject> = [:]
        let taskData : [Dictionary<String, AnyObject>] = []
        
        // バージョン設定
        taskHeader[TaskJsonUtility.JSON_FIELD_HEADER_VERSION] = TaskInfoHeaderEntity.VERSION
        // 採番ID設定
        taskHeader[TaskJsonUtility.JSON_FIELD_HEADER_ASSIGNMENT_ID] = 0
        // データ設定
        taskHeader[TaskJsonUtility.JSON_FIELD_HEADER_DATA] = taskData
        
        return taskHeader
    }

    ///
    ///　タスク用JSONファイルからTaskInfoHeaderEntityを取得する
    ///　- returns:読み込んだJSONファイルから変換したTaskInfoHeaderEntity
    ///
    public func readJSONFile() -> TaskInfoHeaderEntity {
        var ret : TaskInfoHeaderEntity
        let fullPath : String = TaskJsonUtility.getJSONSaveDirectory().stringByAppendingPathComponent(TaskJsonUtility.FILE_NAME_TASK_JSON)
        
        var obj : AnyObject? = nil

        // JSONファイルが存在する場合
        if(NSFileManager.defaultManager().fileExistsAtPath(fullPath)){
            // JSONファイルを読込む
            let jsonData = NSData(contentsOfFile: fullPath)!
            
            // TaskJsonUtilityオブジェクトに変換する
            obj = NSDataToAnyObject(jsonData)
        }
        
        // データが無効な場合
        if(nil == obj){
            // 新規作成する
            obj = super.JSONItemToObject(initData())
        }
        
        // JSONからTaskInfoHeaderEntityに変換する
        ret = JSONToTaskInfo(obj)
        
        return ret
    }
    
    ///
    ///　タスク用JSON形式からTaskInfoHeaderEntityに変換する
    ///　- parameter:obj:JSON形式データ
    ///　- returns:TaskInfoHeaderEntity
    ///
    func JSONToTaskInfo(obj : AnyObject?) -> TaskInfoHeaderEntity {
        let ret : TaskInfoHeaderEntity = TaskInfoHeaderEntity()
        
        // JSONが有効な場合
        if(nil != obj){
            switch(obj!){
            // NSDictionaryの場合
            case let dict as NSDictionary:
                // NSDictionaryの配列数分処理する
                for (key, value) in dict {
                    // キー項目をStringに変換
                    if let workKey = key as? String {
                        switch(workKey){
                        // キー項目がJSON_FIELD_HEADER_VERSION
                        case TaskJsonUtility.JSON_FIELD_HEADER_VERSION:
                            // バージョン取得
                            ret.Version = value as! String
                            break
                        // キー項目がJSON_FIELD_HEADER_ASSIGNMENT_ID
                        case TaskJsonUtility.JSON_FIELD_HEADER_ASSIGNMENT_ID:
                            // 採番ID取得
                            ret.AssignmentId = value as! Int
                            break
                        // キー項目がJSON_FIELD_HEADER_DATA
                        case TaskJsonUtility.JSON_FIELD_HEADER_DATA:
                            var workArry : [AnyObject] = [AnyObject]()

                            // データ部のデータ配列を取得する
                            workArry = JSONItemToObject(value) as! [AnyObject]
                            
                            for workItemArry in workArry {
                                // TaskInfoDataEntity項目生成
                                let data : TaskInfoDataEntity = TaskInfoDataEntity()

                                // データ配列数分処理する
                                for (dataKey, dataValue) in workItemArry as! Dictionary<String, AnyObject> {
                                    // キー項目をStringに変換
                                    switch(dataKey){
                                    // キー項目がJSON_FIELD_DATA_ID
                                    case TaskJsonUtility.JSON_FIELD_DATA_ID:
                                        data.Id = dataValue as! Int
                                        break
                                    // キー項目がJSON_FIELD_DATA_TITLE
                                    case TaskJsonUtility.JSON_FIELD_DATA_TITLE:
                                        data.Title = decodeJsonString(dataValue as! String)
                                        break
                                    // キー項目がJSON_FIELD_DATA_MEMO
                                    case TaskJsonUtility.JSON_FIELD_DATA_MEMO:
                                        data.Memo = decodeJsonString(dataValue as! String)
                                        break
                                    // キー項目がJSON_FIELD_DATA_DATETIME
                                    case TaskJsonUtility.JSON_FIELD_DATA_DATETIME:
                                        data.DateTime = dataValue as! String
                                        break
                                    // キー項目がJSON_FIELD_DATA_NOTIFIED_LOCATION
                                    case TaskJsonUtility.JSON_FIELD_DATA_NOTIFIED_LOCATION:
                                        data.NotifiedLocation = dataValue as! Int
                                        break
                                    // キー項目がJSON_FIELD_DATA_IMPORTANCE
                                    case TaskJsonUtility.JSON_FIELD_DATA_IMPORTANCE:
                                        data.Importance = dataValue as! Int
                                        break
                                    // キー項目がJSON_FIELD_DATA_BUTTON_COLOR
                                    case TaskJsonUtility.JSON_FIELD_DATA_BUTTON_COLOR:
                                        data.ButtonColor = dataValue as! Int
                                        break
                                    // キー項目がJSON_FIELD_DATA_TEXT_COLOR
                                    case TaskJsonUtility.JSON_FIELD_DATA_TEXT_COLOR:
                                        data.TextColor = dataValue as! Int
                                        break
                                    // キー項目がJSON_FIELD_DATA_PARRENT_ID
                                    case TaskJsonUtility.JSON_FIELD_DATA_PARRENT_ID:
                                        data.ParrentId = dataValue as! Int
                                    break
                                    // キー項目がJSON_FIELD_DATA_COMPLETE_FLAG
                                    case TaskJsonUtility.JSON_FIELD_DATA_COMPLETE_FLAG:
                                        data.CompleteFlag = dataValue as! Int
                                        break
                                    // キー項目がJSON_FIELD_DATA_CREATE_DATETIME
                                    case TaskJsonUtility.JSON_FIELD_DATA_CREATE_DATETIME:
                                        data.CreateDateTime = dataValue as! String
                                        break
                                    // キー項目がJSON_FIELD_DATA_UPDATE_DATETIME
                                    case TaskJsonUtility.JSON_FIELD_DATA_UPDATE_DATETIME:
                                        data.UpdateDateTime = dataValue as! String
                                        break
                                    default:
                                        break
                                    }
                                }
                                // 配列に構造体を追加
                                ret.Data.append(data)
                            }
                            break
                        default:
                            break
                        }
                    }
                }
            default:
                break
            }
        }
        return ret
    }
    
    ///
    ///　タスク用JSONファイルからTaskInfoHeaderEntityを取得する
    ///　- parameter:taskInfoHeaderEntity:TaskInfoHeaderEntity
    ///　- returns:読み込んだJSONファイルから変換したTaskInfoHeaderEntity
    ///
    public func writeJSONFile(taskInfoHeaderEntity : TaskInfoHeaderEntity) -> Bool {
        var ret : Bool = false

        // TaskInfoHeaderEntityからJSON文字列に変換する
        let jsonString : String = TaskInfoHeaderEntityTOJSONString(taskInfoHeaderEntity)
        
        // データが有効な場合
        if(0 < jsonString.length){
            // 保存フルパスを取得
            let fullPath : String = BaseJsonDataUtility.getJSONSaveDirectory().stringByAppendingPathComponent(TaskJsonUtility.FILE_NAME_TASK_JSON)
            
            do {
                // ディレクトリの作成
                try NSFileManager.defaultManager().createDirectoryAtPath(BaseJsonDataUtility.getJSONSaveDirectory(), withIntermediateDirectories: true, attributes: nil)
                
                // ファイルの保存
                try jsonString.writeToFile(fullPath, atomically: true, encoding: NSUTF8StringEncoding)
                ret = true
            } catch {
                ret = false
            }
        }
        
        // 処理結果を返す
        return ret
    }
    
    ///
    ///　タスク用TaskInfoHeaderEntityからJSON文字列に変換する
    ///　- parameter:taskInfoHeaderEntity:TaskInfoHeaderEntity
    ///　- returns:JSON文字列
    ///
    public func TaskInfoHeaderEntityTOJSONString(taskInfoHeaderEntity : TaskInfoHeaderEntity) -> String {
        
        var jsonBuff : String = StringUtility.EMPTY
        var jsonDataBuff : String = StringUtility.EMPTY
        let comma : String = ","
        let bracketsStart : String = "{"
        let bracketsEnd : String = "}"
        let bracketsChild1 : String = "{"
        let bracketsChild2 : String = "}"
        
        // JSON開始カッコ設定
        jsonBuff.appendContentsOf(bracketsStart)
        // バージョン設定
        jsonBuff.appendContentsOf(formatJsonItem(TaskJsonUtility.JSON_FIELD_HEADER_VERSION, value: taskInfoHeaderEntity.Version, isComma: true))
        
        // 採番ID設定
        jsonBuff.appendContentsOf(formatJsonItem(TaskJsonUtility.JSON_FIELD_HEADER_ASSIGNMENT_ID, value: taskInfoHeaderEntity.AssignmentId, isComma: true))
        
        // データ数分処理する
        for data in taskInfoHeaderEntity.Data {
            // 追加する場合
            if(0 < jsonDataBuff.length){
                // カンマを追加する
                jsonDataBuff.appendContentsOf(comma)
            }

            // 子項目の配列カッコ（{）を設定
            jsonDataBuff.appendContentsOf(bracketsChild1)
            
            // ID設定
            jsonDataBuff.appendContentsOf(formatJsonItem(TaskJsonUtility.JSON_FIELD_DATA_ID, value: data.Id, isComma: true))
            // タイトル設定（文字をエスケープする）
            jsonDataBuff.appendContentsOf(formatJsonItem(TaskJsonUtility.JSON_FIELD_DATA_TITLE, value: escapeJsonString(data.Title), isComma: true))
            // メモ設定（文字をエスケープする）
            jsonDataBuff.appendContentsOf(formatJsonItem(TaskJsonUtility.JSON_FIELD_DATA_MEMO, value: escapeJsonString(data.Memo), isComma: true))
            // 日時設定
            jsonDataBuff.appendContentsOf(formatJsonItem(TaskJsonUtility.JSON_FIELD_DATA_DATETIME, value: data.DateTime, isComma: true))
            // 通知場所設定
            jsonDataBuff.appendContentsOf(formatJsonItem(TaskJsonUtility.JSON_FIELD_DATA_NOTIFIED_LOCATION, value: data.NotifiedLocation, isComma: true))
            // 重要度設定
            jsonDataBuff.appendContentsOf(formatJsonItem(TaskJsonUtility.JSON_FIELD_DATA_IMPORTANCE, value: data.Importance, isComma: true))
            // ボタン色設定
            jsonDataBuff.appendContentsOf(formatJsonItem(TaskJsonUtility.JSON_FIELD_DATA_BUTTON_COLOR, value: data.ButtonColor, isComma: true))
            // 文字色設定
            jsonDataBuff.appendContentsOf(formatJsonItem(TaskJsonUtility.JSON_FIELD_DATA_TEXT_COLOR, value: data.TextColor, isComma: true))
            // 親ID設定
            jsonDataBuff.appendContentsOf(formatJsonItem(TaskJsonUtility.JSON_FIELD_DATA_PARRENT_ID, value: data.ParrentId, isComma: true))
            // 完了フラグ設定
            jsonDataBuff.appendContentsOf(formatJsonItem(TaskJsonUtility.JSON_FIELD_DATA_COMPLETE_FLAG, value: data.CompleteFlag, isComma: true))
            // 作成日時設定
            jsonDataBuff.appendContentsOf(formatJsonItem(TaskJsonUtility.JSON_FIELD_DATA_CREATE_DATETIME, value: data.CreateDateTime, isComma: true))
            // 更新日時設定
            jsonDataBuff.appendContentsOf(formatJsonItem(TaskJsonUtility.JSON_FIELD_DATA_UPDATE_DATETIME, value: data.UpdateDateTime, isComma: false))

            // 子項目の配列カッコ（}）を設定
            jsonDataBuff.appendContentsOf(bracketsChild2)
        }

        // データ配列部設定
        jsonBuff.appendContentsOf(formatJsonArray(TaskJsonUtility.JSON_FIELD_HEADER_DATA, value: jsonDataBuff, isComma: false))

        // JSON終了カッコ設定
        jsonBuff.appendContentsOf(bracketsEnd)

        return jsonBuff
    }
    
    ///
    ///　文字列をJSON文字列に変換する
    ///　- parameter:key:キー
    ///　- parameter:value:値
    ///　- parameter:isComma:true:後ろにカンマをつける false:つけない
    ///　- returns:JSON文字列 "key":"value"
    ///
    func formatJsonItem(key : String, value : String, isComma : Bool) -> String {
        let sep : String = ":"
        let dblQuart : String = "\""
        let comma : String = ","
        
        return dblQuart + key + dblQuart + sep + dblQuart + value + dblQuart + ((isComma) ? comma : StringUtility.EMPTY)
    }

    ///
    ///　数値をJSON文字列に変換する
    ///　- parameter:key:キー
    ///　- parameter:value:値
    ///　- parameter:isComma:true:後ろにカンマをつける false:つけない
    ///　- returns:JSON文字列 "key":value
    ///
    func formatJsonItem(key : String, value : Int, isComma : Bool) -> String {
        let sep : String = ":"
        let dblQuart : String = "\""
        let comma : String = ","
        
        return dblQuart + key + dblQuart + sep + String(value) + ((isComma) ? comma : StringUtility.EMPTY)
    }
    
    ///
    ///　配列をJSON文字列に変換する
    ///　- parameter:key:キー
    ///　- parameter:value:値
    ///　- parameter:isComma:true:後ろにカンマをつける false:つけない
    ///　- returns:JSON文字列 "key":[value]
    ///
    func formatJsonArray(key : String, value : String, isComma : Bool) -> String {
        let sep : String = ":"
        let dblQuart : String = "\""
        let comma : String = ","
        let bracketsArray1 : String = "["
        let bracketsArray2 : String = "]"
        
        return dblQuart + key + dblQuart + sep + bracketsArray1 + String(value) + bracketsArray2 + ((isComma) ? comma : StringUtility.EMPTY)
    }
    
    ///
    ///　タスク用JSONファイルからTaskInfoHeaderEntityを取得する
    ///　- returns:true:正常終了 false:異常終了
    ///
    public func deleteJSONFile() -> Bool {
        var ret : Bool = false
        
        // 保存フルパスを取得
        let fullPath : String = BaseJsonDataUtility.getJSONSaveDirectory().stringByAppendingPathComponent(TaskJsonUtility.FILE_NAME_TASK_JSON)
            
        do {
            // ファイルの削除
            try NSFileManager.defaultManager().removeItemAtPath(fullPath)
            ret = true
        } catch {
            ret = false
        }
        
        // 処理結果を返す
        return ret
    }
}
