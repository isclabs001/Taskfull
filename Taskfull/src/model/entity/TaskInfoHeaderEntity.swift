//
//  TaskInfoHeaderEntity.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/01.
//  Copyright © 2017年 isc. All rights reserved.
//

import Foundation

/**
 * タスク情報ヘッダー部
 */
open class TaskInfoHeaderEntity {
    /**
     * 定数定義
     */
    /**
     * 現在のファイルバージョン定義
     */
    static internal let VERSION : String = "1.0.0";
    
    /**
     * 変数定義
     */
    /**
     * ファイルバージョン
     */
    var Version : String
    /**
     * 採番ID（データを追加するたびにインクリメントする）
     */
    var AssignmentId : Int
    /**
     * 現在のカテゴリ形式
     */
    var CategoryType : Int
    /**
     * TaskInfoDataEntityデータ配列
     */
    var Data : [TaskInfoDataEntity]
    /**
     * TaskInfoLocationDataEntityデータ配列
     */
    var Location : [TaskInfoLocationDataEntity]
    
    /**
     * イニシャライズ
     */
    init()
    {
        // 変数初期化
        self.Version = TaskInfoHeaderEntity.VERSION
        self.AssignmentId = 0
        self.CategoryType = CommonConst.CategoryType.task.rawValue
        self.Data = []
        self.Location = []
    }
}
