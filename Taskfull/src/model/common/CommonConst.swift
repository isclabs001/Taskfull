//
//  CommonConst.swift
//  SchoolCafeteriaMap
//
//  Created by IscIsc on 2016/07/13.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import Foundation

class CommonConst
{
    /**
     * 地図俯瞰角度
     */
    static internal let MAP_TILT_NORMAL : Double = 30
    
    /**
     * 地図ズーム　初期値
     */
    static internal let MAP_ZOOM_INIT : Float = 14

    /**
     * メイン画面動作モード形式
     */
    enum ActionType {
        // 参照
        case Reference
        // 編集
        case Edit
    }
    
    /**
     * URL文字列
     */
    static internal let URL_HTTP : String = "http://"
    static internal let URL_HTTPS : String = "https://"
    
    /**
     * 拡張子
     */
    static internal let FILE_EXT_PNG : String = ".png";
    static internal let FILE_EXT_JPG : String = ".jpg";
    
    /**
     * 距離範囲内の閾値(500m)
     */
    static internal let DISTANCE_THRESHOLD : Double = 0.5;
    
    /**
     * 画面タイトル
     */
    static internal let VIW_TITLE_INPUT_TASK : String = "タスク登録";
    
    /**
     * ドキュメント（共有）ディレクトリ
     */
    static internal let DIRECTORY_DOCUMENTS : String = NSHomeDirectory() + "/Library/Documents";
    /**
     * アプリケーションディレクトリ
     */
    static internal let DIRECTORY_APPLICATION_SUPPORT : String = NSHomeDirectory() + "/Library/Application Support";
    /**
     * キャッシュディレクトリ
     */
    static internal let DIRECTORY_CACHES : String = NSHomeDirectory() + "/Library/Caches";
    /**
     * テンポラリーディレクトリ
     */
    static internal let DIRECTORY_TMP : String = NSTemporaryDirectory();

    /**
     * タスク完了フラグ
     */
    /**
     * 未完了
     */
    static internal let TASK_COMPLETE_FLAG_INVALID : Int = 0;
    /**
     * 完了
     */
    static internal let TASK_COMPLETE_FLAG_VALID : Int = 1;
    
    /**
     * タスクボタンサイズ
     */
    /**
     * 最小サイズ
     */
    static internal let TASK_BUTTON_SIZE_MIN : Double = 64;
    /**
     * 最大サイズ
     */
    static internal let TASK_BUTTON_SIZE_MAX : Double = 192;
    
    /**
     * タスクボタン色
     */
    static internal let TASK_BUTTON_COLOR_WHITE : Int       = 0
    static internal let TASK_BUTTON_COLOR_LIGHT_BLUE : Int  = 1
    static internal let TASK_BUTTON_COLOR_GLAY : Int        = 2
    static internal let TASK_BUTTON_COLOR_GREEN : Int       = 3
    static internal let TASK_BUTTON_COLOR_ORANGE : Int      = 4
    static internal let TASK_BUTTON_COLOR_BLUE : Int        = 5
    static internal let TASK_BUTTON_COLOR_YELLOW : Int      = 6
    static internal let TASK_BUTTON_COLOR_PINK : Int        = 7
    static internal let TASK_BUTTON_COLOR_PURPLE : Int      = 8
    static internal let TASK_BUTTON_COLOR_DARK_YELLOW : Int = 9
    static internal let TASK_BUTTON_COLOR_DARK_PINK : Int   = 10
    static internal let TASK_BUTTON_COLOR_DARK_PURPLE : Int = 11
    static internal let TASK_BUTTON_COLOR_RED : Int         = 12
    
    /**
     * タスクボタンリソース配列
     */
    static internal let TASK_BUTTON_COLOR_RESOURCE : Array<String> = [
        // 重要度：低
        "soap001.png",      // 白
        "soap002.png",      // 水色
        "soap003.png",      // 灰色
        // 重要度：中
        "soap004.png",      // 緑
        "soap005.png",      // 橙
        "soap006.png",      // 青
        // 重要度：高
        "soap007.png",      // 黄色
        "soap008.png",      // ピンク
        "soap009.png",      // 紫
        // 重要度：至急
        "soap010.png",      // 濃い黄色
        "soap011.png",      // 濃いピンク
        "soap012.png",      // 濃い紫
        // 重要度：大至急
        "soap013.png",      // 濃い赤
        ]

}