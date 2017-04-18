//
//  ViewTaskItemEntity.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/03.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

/**
 * 表示タスク項目
 */
open class ViewTaskItemEntity {
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
     * 色
     */
    var Color : Int
    
    /**
     * 表示位置・サイズ
     */
    var Location : CGRect
    
    /**
     * ボタンコントロール
     */
    var TaskButton : UITaskImageButton?
    
    /**
     * 表示インデックス
     */
    var Index : Int
    
    /**
     * 表示フラグ
     */
    var IsDisplay : Bool
    
    /**
     * 子フラグ
     */
    var IsChild : Bool
    
    /**
     * イニシャライズ
     */
    init()
    {
        self.Id = 0
        self.Color = 0
        self.Location = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.TaskButton = nil
        self.Index = 0
        self.IsDisplay = true
        self.IsChild = false
    }
}

