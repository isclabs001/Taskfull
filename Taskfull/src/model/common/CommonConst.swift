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
     * 画面タイトル
     */
    static internal let VIW_TITLE_MAIN : String = "Taskfull [%@]";
    static internal let VIW_TITLE_INPUT_TASK : String = "タスク登録";
    static internal let VIW_TITLE_EDIT_TASK : String = "タスク編集";
    static internal let VIW_TITLE_CONTENT_TASK : String = "タスク内容";
    
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

    /**
     * 項目名未入力時代入定数
     */
    static internal let INPUT_TASK_NAME_EMPTY_STRING : String = "項目名未入力"
    
    
    /**
     * 入力欄プレースホルダー用定数
     */
    // 項目名プレースホルダー用定数
    static internal let INPUT_TASK_NAME_PLACE_HOLDER : String = "項目名:"
    // メモ欄プレースホルダー用定数
    static internal let INPUT_TASK_MEMO_PLACE_HOLDER : String = "メモ:"
    
    /**
     * 後続タスク追加ボタンタイトル定数
     */
    // 後続ボタン追加タイトル定数
    static internal let AFTER_ADD_TASK_BTN_TITLE : String = "後続タスク追加"
    static internal let AFTER_DISPLAY_TASK_BTN_TITLE : String = "後続タスク表示"
    static internal let AFTER_EDIT_TASK_BTN_TITLE : String = "後続タスク編集"

    /**
     * カラーボタン選択時背景色定数
     */
    static internal let CL_TASK_BTN_BACK_GROUND_COLOR : UIColor = UIColorUtility.rgb(102, g: 153, b: 255)

    /**
     * 背景色定数
     */
    // 青
    static internal let CL_BACKGROUND_GRADIATION_BLUE_1 : UIColor = UIColorUtility.rgb(0, g: 30, b: 183)
    //static internal let CL_BACKGROUND_GRADIATION_BLUE_2 : UIColor = UIColorUtility.rgb(222, g: 255, b: 255)
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
        case shopping
        // 就職
        case finding_employment
        // その他
        case etc
        // 最大
        case max
    }
    static internal let CATEGORY_TYPE_STRING : Array<String> = [
        "課題",
        "買い物",
        "就職",
        "その他"
    ]
    static internal let CATEGORY_TYPE_BACKGROUND_COLOR : Array<UIColor> = [
        UIColorUtility.rgb(255, g: 160, b: 160),
        UIColorUtility.rgb(255, g: 205, b: 120),
        UIColorUtility.rgb(153, g: 255, b: 139),
        UIColorUtility.rgb(136, g: 223, b: 255),
    ]
}
