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
     * タスクボタンリソース配列
     */
    static internal let TASK_BUTTON_RESOURCE : Array<String> = [
        "soap001.png",
        "soap002.png",
        "soap003.png",
        "soap004.png",
        "soap005.png",
        "soap006.png",
        "soap007.png",
        "soap008.png",
        "soap009.png",
        "soap010.png",
        "soap011.png",
        "soap012.png",
        "soap013.png",
        ]

}