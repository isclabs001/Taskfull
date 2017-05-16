//
//  TaskInfoConfigEntity.swift
//  Taskfull
//
//  Created by IscIsc on 2017/05/16.
//  Copyright © 2017年 isc. All rights reserved.
//
import Foundation

/**
 * 設定データ部
 */
open class TaskInfoConfigEntity {
    /**
     * 定数定義
     */
    
    
    /**
     * 変数定義
     */
    /**
     * 5分前
     */
    var MinuteAgo5 : Int
    /**
     * 10分前
     */
    var MinuteAgo10 : Int
    /**
     * 15分前
     */
    var MinuteAgo15 : Int
    /**
     * 30分前
     */
    var MinuteAgo30 : Int
    /**
     * 1時間前
     */
    var HoursAgo1 : Int
    /**
     * 3時間前
     */
    var HoursAgo3 : Int
    /**
     * 6時間前
     */
    var HoursAgo6 : Int
    
    /**
     * イニシャライズ
     */
    init()
    {
        // 変数初期化(10分前はデフォルトON)
        self.MinuteAgo5 = CommonConst.OFF
        self.MinuteAgo10 = CommonConst.ON
        self.MinuteAgo15 = CommonConst.OFF
        self.MinuteAgo30 = CommonConst.OFF
        self.HoursAgo1 = CommonConst.OFF
        self.HoursAgo3 = CommonConst.OFF
        self.HoursAgo6 = CommonConst.OFF
    }
    
    /**
     * クリア
     */
    open func clear()
    {
        // 変数初期化(10分前はデフォルトON)
        self.MinuteAgo5 = CommonConst.OFF
        self.MinuteAgo10 = CommonConst.ON
        self.MinuteAgo15 = CommonConst.OFF
        self.MinuteAgo30 = CommonConst.OFF
        self.HoursAgo1 = CommonConst.OFF
        self.HoursAgo3 = CommonConst.OFF
        self.HoursAgo6 = CommonConst.OFF
    }
}
