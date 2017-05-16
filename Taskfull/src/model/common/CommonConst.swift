//
//  CommonConst.swift
//  SchoolCafeteriaMap
//
//  Created by IscIsc on 2016/07/13.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import Foundation
import UIKit

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
    enum ActionType: Int {
        // 参照
        case reference = 0
        // 登録
        case add
        // 編集
        case edit
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
     * ON/OFF
     */
    /**
     * OFF
     */
    static internal let OFF : Int = 0;
    /**
     * ON
     */
    static internal let ON : Int = 1;
    
    /**
     * タスクボタンサイズ
     */
    /**
     * 最小サイズ
     */
    static internal let TASK_BUTTON_SIZE_MIN : Double = 80;
    /**
     * 最大サイズ
     */
    static internal let TASK_BUTTON_SIZE_MAX : Double = 160;
    
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

    /**
     * タスク重要度定数
     */
    // 重要度：低
    static internal let TASK_IMPORTANCE_VALID_LOW: Int = 0;
    // 重要度：中
    static internal let TASK_COMPLETE_FLAG_VALID_MEDIUM : Int = 1;
    // 重要度：高
    static internal let TASK_COMPLETE_FLAG_VALID_HIGH : Int = 2;
    // 重要度：至急
    static internal let TASK_COMPLETE_FLAG_VALID_URGENT : Int = 3;
    // 重要度：大至急
    static internal let TASK_COMPLETE_FLAG_VALID_ASAP : Int = 4;
    
    /**
     * 文字列入力制限数定数
     */
    // 項目名入力制限数
    static internal let INPUT_TASK_NAME_STRING_LIMIT: Int = 20;
    // メモ入力制限数
    static internal let INPUT_TASK_MEMO_STRING_LIMIT: Int = 200;
    // 通知地点名入力制限数
    static internal let INPUT_TASK_NOTIFICATION_POINT_LIST_STRING_LIMIT: Int = 10;
    
    /**
     * カラーボタン選択時背景色定数
     */
    static internal let CL_TASK_BTN_BACK_GROUND_COLOR : UIColor = UIColorUtility.rgb(102, g: 153, b: 255)

    /**
     * 背景色定数
     */
    // 青
    static internal let CL_BACKGROUND_GRADIATION_BLUE_1 : UIColor = UIColorUtility.rgb(0, g: 30, b: 183)
    static internal let CL_BACKGROUND_GRADIATION_BLUE_2 : UIColor = UIColorUtility.rgb(222, g: 222, b: 255)
    // オレンジ
    static internal let CL_BACKGROUND_GRADIATION_ORANGE_1 : UIColor = UIColorUtility.rgb(255, g: 128, b: 0)
    static internal let CL_BACKGROUND_GRADIATION_ORANGE_2 : UIColor = UIColorUtility.rgb(255, g: 218, b: 128)


    /**
 　　　* カテゴリー
 　　*/
    enum CategoryType: Int {
        // 課題
        case task = 0
        // 買い物
        case shopping = 1
        // 就職
        case finding_employment = 2
        // その他
        case etc = 3
        // 最大
        case max
    }
    static internal let CATEGORY_TYPE_STRING : Array<String> = [
        MessageUtility.getMessage(key: "CategoryTypeTask"),
        MessageUtility.getMessage(key: "CategoryTypeShopping"),
        MessageUtility.getMessage(key: "CategoryTypeEmployment"),
        MessageUtility.getMessage(key: "CategoryTypeOther")
    ]
    static internal let CATEGORY_TYPE_BACKGROUND_COLOR : Array<UIColor> = [
        UIColorUtility.rgb(255, g: 160, b: 160),
        UIColorUtility.rgb(255, g: 205, b: 120),
        UIColorUtility.rgb(153, g: 255, b: 139),
        UIColorUtility.rgb(136, g: 223, b: 255),
    ]
    
    /**
     * メインメニュー
    */
    enum MainMenuType: Int {
        // なし
        case none = -1
        // タスク追加
        case taskAdd = 0
        // GPS通知設定
        case configGps
        // 設定
        case config
        // 最大
        case max = 3
    }
    static internal let MAIN_MENU_TYPE_STRING : Array<String> = [
        MessageUtility.getMessage(key: "MainMenuTypeTaskAdd"),
        MessageUtility.getMessage(key: "MainMenuTypeGPSNotification"),
        MessageUtility.getMessage(key: "MainMenuTypeConfig"),
    ]
    static internal let MAIN_MENU_TYPE_BACKGROUND_COLOR : Array<UIColor> = [
        UIColorUtility.rgb(232, g: 207, b: 255),
        UIColorUtility.rgb(153, g: 217, b: 234),
        UIColorUtility.rgb(255, g: 205, b: 120),
    ]
    
    
    /**
     * ジオフェンス通知範囲(半径)
     */
    static internal let NOTIFICATION_GEOFENCE_RADIUS_RANGE: Double = 100;
    
    
    /**
     * 通知地点登録上限数
     */
    static internal let INPUT_NOTIFICATION_POINT_LIST_LIMIT: Int = 10;
    
    
    /**
     * 通知地点初期値
     */
    static internal let INPUT_NOTIFICATION_POINT_LIST_INITIAL_VALUE: Int = 0;
    
    
    /**
     * 通知地点PickerView表示列数
     */
    static internal let INPUT_NOTIFICATION_POINT_LIST_PICKER_COLUMN_COUNT: Int = 1;
    
    
    /**
     * 通知地点設定上限数
     */
    static internal let INPUT_NOTIFICATION_TASK_POINT_LIST_SET_COUNT_LIMIT: Int = 20;
    
    
    
}
