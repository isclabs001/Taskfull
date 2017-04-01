//
//  TaskInfoHeaderEntity.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/01.
//  Copyright © 2017年 isc. All rights reserved.
//

import Foundation

public class TaskInfoHeaderEntity {
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
    public var Version : String = VERSION
    /**
     * 採番ID（データを追加するたびにインクリメントする）
     */
    public var AssignmentId : Int = 0
    /**
     * TaskInfoDataEntityデータ配列
     */
    public var Data : [TaskInfoDataEntity] = []
}
