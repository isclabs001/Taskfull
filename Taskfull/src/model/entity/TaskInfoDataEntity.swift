//
//  TaskInfoDataEntity.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/01.
//  Copyright © 2017年 isc. All rights reserved.
//

import Foundation

public class TaskInfoDataEntity : Comparable {
    /**
     * 定数定義
     */

    
    /**
     * 変数定義
     */
    /**
     * ファイルバージョン
     */
    public var Id : Int = 0
    /**
     *
     */
    public var Title : String = StringUtility.EMPTY
    /**
     *
     */
    public var Memo : String = StringUtility.EMPTY
    /**
     * タスク完了予定日時（yyyy/MM/dd HH:mm:ss形式で格納）
     */
    public var DateTime : String = StringUtility.EMPTY
    /**
     * 通知場所
     */
    public var NotifiedLocation : Int = 0
    /**
     * 重要度
     */
    public var Importance : Int = 0
    /**
     * 色
     */
    public var Color : Int = 0
    
    /**
     * システム情報領域
     */
    /**
     * 親ID
     */
    public var ParrentId : Int = -1
    /**
     * 完了フラグ（0:未完了 1:完了）
     */
    public var CompleteFlag : Int = CommonConst.TASK_COMPLETE_FLAG_INVALID
    /**
     * 作成日時（yyyy/MM/dd HH:mm:ss形式で格納）
     */
    public var CreateDateTime : String = StringUtility.EMPTY
    /**
     * 更新日時（yyyy/MM/dd HH:mm:ss形式で格納）
     */
    public var UpdateDateTime : String = StringUtility.EMPTY
}

public func ==(cmp1: TaskInfoDataEntity, cmp2: TaskInfoDataEntity) -> Bool {
    if cmp1.Id == cmp2.Id {
        return true
    }
    return false
}

public func <(cmp1: TaskInfoDataEntity, cmp2: TaskInfoDataEntity) -> Bool {
    //
    if cmp1.DateTime < cmp2.DateTime {
        return true
    } else if cmp1.DateTime > cmp2.DateTime {
        return false
    }
    
    if cmp1.Id < cmp2.Id {
        return true
    } else if cmp1.Id > cmp2.Id {
        return false
    }
    
    return false
}