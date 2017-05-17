//
//  ConfigViewController.swift
//  Taskfull
//
//  Created by IscIsc on 2017/05/16.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

///
/// 設定画面
///
class ConfigViewController : BaseViewController
{
    /**
     * 定数
     */
    
    /**
     * 変数
     */
    @IBOutlet weak var chk01: UICheckbox!
    @IBOutlet weak var chk02: UICheckbox!
    @IBOutlet weak var chk03: UICheckbox!
    @IBOutlet weak var chk04: UICheckbox!
    @IBOutlet weak var chk05: UICheckbox!
    @IBOutlet weak var chk06: UICheckbox!
    @IBOutlet weak var chk07: UICheckbox!
    
    // チェックボックス配列
    private var aryCheckbox : Array<UICheckbox> = Array()
    
    ///
    /// 初期化処理
    ///　- parameter:aDecoder:NSCoder
    ///
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    ///
    /// viewDidLoadイベント処理
    ///
    override func viewDidLoad() {
        // 基底のviewDidLoadを呼び出す
        super.viewDidLoad()
        
        // 初期化
        let _ = initializeProc()
    }
    
    
    ///
    /// 初期化処理
    ///　- returns:true:正常終了 false:異常終了
    ///
    override func initializeProc() ->Bool
    {
        // 基底のinitializeProcを呼び出す
        let ret : Bool = super.initializeProc()
        
        //　正常な場合
        if(true == ret)
        {
            // 配列に追加
            self.aryCheckbox.append(self.chk01!)
            self.aryCheckbox.append(self.chk02!)
            self.aryCheckbox.append(self.chk03!)
            self.aryCheckbox.append(self.chk04!)
            self.aryCheckbox.append(self.chk05!)
            self.aryCheckbox.append(self.chk06!)
            self.aryCheckbox.append(self.chk07!)
            
            let title : [String] = [
                "ConfigNoticeTime5MinutesAgo",
                "ConfigNoticeTime10MinutesAgo",
                "ConfigNoticeTime15MinutesAgo",
                "ConfigNoticeTime30MinutesAgo",
                "ConfigNoticeTime1HoursAgo",
                "ConfigNoticeTime3HoursAgo",
                "ConfigNoticeTime6HoursAgo"
            ]
            for i in (0 ..< self.aryCheckbox.count){
                // Tag設定
                self.aryCheckbox[i].btnCheck.tag = i
                // チェックボックスのタイトル設定
                self.aryCheckbox[i].labelTitle = MessageUtility.getMessage(key: title[i])
                // イベント設定
                self.aryCheckbox[i].btnCheck.addTarget(self, action: #selector(ConfigViewController.onClickCheckbox(sender:)), for: .touchUpInside)
            }
            
            // 表示状態設定
            dhispConfig()
        }
        
        return ret
    }
    
    ///
    ///　チェックボックスタップイベント処理
    ///　- parameter sender:UIButton
    ///
    internal func onClickCheckbox(sender: UIButton){
        // 設定保存
        setConfig(index: sender.tag, selected: self.aryCheckbox[sender.tag].btnCheck.isSelected)
    }
    
    ///
    ///　設定表示処理
    ///
    private func dhispConfig() {
        let onoff : [Bool] = [
            (CommonConst.ON == TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().MinuteAgo5) ? true : false,
            (CommonConst.ON == TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().MinuteAgo10) ? true : false,
            (CommonConst.ON == TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().MinuteAgo15) ? true : false,
            (CommonConst.ON == TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().MinuteAgo30) ? true : false,
            (CommonConst.ON == TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().HoursAgo1) ? true : false,
            (CommonConst.ON == TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().HoursAgo3) ? true : false,
            (CommonConst.ON == TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().HoursAgo6) ? true : false
        ]

        // ON/OFF状態設定
        for i in (0 ..< self.aryCheckbox.count){
            self.aryCheckbox[i].btnCheck.isSelected = onoff[i]
        }
    }
    
    ///
    ///　設定保存処理
    ///　- parameter index:インデックス
    ///　- parameter selected:チェック状態
    ///
    private func setConfig(index : Int, selected : Bool) {
        
        // OKボタン押下
        self.isOkBtn = true

        // 選択状態からOn/Offを取得
        let onoff : Int = (selected) ? CommonConst.ON : CommonConst.OFF
        
        // 選択された場合
        switch(index) {
        // 5分前
        case CommonConst.BeforeNotificationTime.MinuteAgo5.rawValue:
            TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().MinuteAgo5 = onoff
            break;
        // 10分前
        case CommonConst.BeforeNotificationTime.MinuteAgo10.rawValue:
            TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().MinuteAgo10 = onoff
            break;
        // 15分前
        case CommonConst.BeforeNotificationTime.MinuteAgo15.rawValue:
            TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().MinuteAgo15 = onoff
            break;
        // 30分前
        case CommonConst.BeforeNotificationTime.MinuteAgo30.rawValue:
            TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().MinuteAgo30 = onoff
            break;
        // 1時間前
        case CommonConst.BeforeNotificationTime.HoursAgo1.rawValue:
            TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().HoursAgo1 = onoff
            break;
        // 3時間前
        case CommonConst.BeforeNotificationTime.HoursAgo3.rawValue:
            TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().HoursAgo3 = onoff
            break;
        // 6時間前
        case CommonConst.BeforeNotificationTime.HoursAgo6.rawValue:
            TaskInfoUtility.DefaultInstance.GetTaskInfoConfig().HoursAgo6 = onoff
            break;
        default:
            break
        }
        
        // 書き込み
        TaskInfoUtility.DefaultInstance.WriteTaskInfo()
        
        // 通知設定処理
        NotificationUtility.DefaultInstance.taskExpirationNotification()
    }
}
