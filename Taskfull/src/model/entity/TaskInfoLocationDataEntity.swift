//
//  TaskInfoLocationDataEntity.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/28.
//  Copyright © 2017年 isc. All rights reserved.
//

import Foundation

/**
 * 位置情報データ部
 */
open class TaskInfoLocationDataEntity {
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
     * 緯度
     */
    var Latitude : Double
    /**
     * 経度
     */
    var Longitude : Double
    
    /**
     * イニシャライズ
     */
    init()
    {
        // 変数初期化
        self.Id = 0
        self.Title = StringUtility.EMPTY
        self.Latitude = 0
        self.Longitude = 0
    }
}
