//
//  TaskInfoDataEntity.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/01.
//  Copyright © 2017年 isc. All rights reserved.
//

import Foundation

/**
 * タスク情報データ部
 */
open class TaskInfoDataEntity : Comparable {
    /**
     * 定数定義
     */

    
    /**
     * 変数定義
     */
    /**
     * ID
     */
    var Id : Int
    /**
     * タイトル
     */
    var Title : String
    /**
     * メモ
     */
    var Memo : String
    /**
     * タスク完了予定日時（yyyy/MM/dd HH:mm:ss形式で格納）
     */
    var DateTime : String
    /**
     * 通知地点
     */
    var NotifiedLocation : Int
    /**
     * 重要度
     */
    var Importance : Int
    /**
     * ボタン色
     */
    var ButtonColor : Int
    /**
     * テキスト色
     */
    var TextColor : Int
    /**
     * カテゴリー形式
     */
    var CategoryType : Int
    
    /**
     * システム情報領域
     */
    /**
     * 親ID
     */
    var ParrentId : Int
    /**
     * 完了フラグ（0:未完了 1:完了）
     */
    var CompleteFlag : Int
    /**
     * 作成日時（yyyy/MM/dd HH:mm:ss形式で格納）
     */
    var CreateDateTime : String
    /**
     * 更新日時（yyyy/MM/dd HH:mm:ss形式で格納）
     */
    var UpdateDateTime : String
    
    /**
     * イニシャライズ
     */
    init()
    {
        // 変数初期化
        self.Id = 0
        self.Title = StringUtility.EMPTY
        self.Memo = StringUtility.EMPTY
        self.DateTime = StringUtility.EMPTY
        self.NotifiedLocation = 0
        self.Importance = 0
        self.ButtonColor = 0
        self.TextColor = 0
        self.ParrentId = -1
        self.CompleteFlag = CommonConst.TASK_COMPLETE_FLAG_INVALID
        self.CreateDateTime = StringUtility.EMPTY
        self.UpdateDateTime = StringUtility.EMPTY
        self.CategoryType = CommonConst.CategoryType.task.rawValue
    }
}

///
///　イコール比較関数
/// - parameter cmp1:比較１
/// - parameter cmp2:比較２
/// - returns:true:比較１と比較２が等しい false:それ以外
///
public func ==(cmp1: TaskInfoDataEntity, cmp2: TaskInfoDataEntity) -> Bool {
    // 比較１のIDが比較２のIDと同じ場合
    if cmp1.Id == cmp2.Id {
        // trueを返す
        return true
    }
    // falseを返す
    return false
}

///
///　比較関数
/// - parameter cmp1:比較１
/// - parameter cmp2:比較２
/// - returns:true:比較１が比較２より小さい false:それ以外
///
public func <(cmp1: TaskInfoDataEntity, cmp2: TaskInfoDataEntity) -> Bool {
    // 比較１の作成日付が比較２の作成日付より小さい場合
    if cmp1.DateTime < cmp2.DateTime {
        // trueを返す
        return true
    // 比較１の作成日付が比較２の作成日付より大きい場合
    } else if cmp1.DateTime > cmp2.DateTime {
        // falseを返す
        return false
    }
    
    // 比較１のIDが比較２のIDより小さい場合
    if cmp1.Id < cmp2.Id {
        // trueを返す
        return true
    // 比較１のIDが比較２のIDより大きい場合
    } else if cmp1.Id > cmp2.Id {
        // falseを返す
        return false
    }
    
    // falseを返す
    return false
}
