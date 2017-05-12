//
//  MessageUtiliti.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/20.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

///
/// 共通メッセージクラス
///
class MessageUtility
{
    /**
     * 定数定義
     */
    /// ボタン
    open static let MESSAGE_BUTTON_STRING_OK : String = "OK"
    open static let MESSAGE_BUTTON_STRING_CANCEL : String = "キャンセル"

    // タイトル
    open static let MESSAGE_TITLE_STRING_CONFIRM_TASK_COMPLETE : String = "タスク完了確認"
    open static let MESSAGE_TITLE_STRING_CONFIRM_TASK_DELETE : String = "削除確認"
    open static let MESSAGE_TITLE_STRING_CONFIRM_TASK_DATE_INPUT : String = "入力確認"
    
    // メッセージ
    open static let MESSAGE_MESSAGE_STRING_CONFIRM_TASK_COMPLETE : String = "タスク「%@」を完了してもよろしいですか？"
    open static let MESSAGE_MESSAGE_STRING_CONFIRM_TASK_DELETE : String = "編集中のタスク及び後続タスクを削除します。よろしいですか？"
    open static let MESSAGE_MESSAGE_STRING_TASK_COUNT_LIMIT : String = "%@文字以内で入力して下さい"
    open static let MESSAGE_MESSAGE_STRING_CONFIRM_TASK_DATE_INPUT : String = "通知時刻を入力して下さい"
    open static let MESSAGE_MESSAGE_STRING_CONFIRM_NOTIFICATION_POINT_LIST_NAME : String = "通知地点名を入力してください"
    open static let MESSAGE_MESSAGE_STRING_CONFIRM_NOTIFICATION_POINT_LIST_SAME_NAME : String = "既に同じ名前が使用されています"
    open static let MESSAGE_MESSAGE_STRING_CONFIRM_NOTIFICATION_POINT_LIST_DELETE_ERROR : String = "「%@」が設定されている未完了タスクが存在しています"
    open static let MESSAGE_MESSAGE_STRING_CONFIRM_NOTIFICATION_POINT_LIST_CREATE_LIMIT : String = "通知地点作成上限です"
    
    /**
     * 変数定義
     */
    
    ///
    /// メッセージ表示（OKボタン）
    ///　- parameter viewController:UIViewController
    ///　- parameter title:メッセージタイトル
    ///　- parameter message:メッセージ内容
    ///　- parameter funcOkButton:OKボタン押下時の関数（func 関数名(action: UIAlertAction) 形式で宣言）
    ///　- parameter funcCancelButton:キャンセルボタン押下時の関数（func 関数名(action: UIAlertAction) 形式で宣言）
    ///
    static open func dispAlertOK(viewController : UIViewController, title : String, message : String) {
        
        // UIAlertControllerクラスのインスタンスを生成
        let alert: UIAlertController = UIAlertController(title: title, message: message,  preferredStyle:  UIAlertControllerStyle.alert)
        
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: MESSAGE_BUTTON_STRING_OK, style: UIAlertActionStyle.default, handler:nil)

        // Actionを追加
        alert.addAction(defaultAction)
        
        // Alertを表示
        viewController.present(alert, animated: true, completion: nil)
    }
    
    ///
    /// メッセージ表示（OK、Cancelボタン）
    ///　- parameter viewController:UIViewController
    ///　- parameter title:メッセージタイトル
    ///　- parameter message:メッセージ内容
    ///　- parameter funcOkButton:OKボタン押下時の関数（func 関数名(action: UIAlertAction) 形式で宣言）
    ///　- parameter funcCancelButton:キャンセルボタン押下時の関数（func 関数名(action: UIAlertAction) 形式で宣言）
    ///
    static open func dispAlertOKCancel(viewController : UIViewController, title : String, message : String, funcOkButton : ((UIAlertAction) -> Swift.Void)?, funcCancelButton : ((UIAlertAction) -> Swift.Void)?) {
        
        // UIAlertControllerクラスのインスタンスを生成
        let alert: UIAlertController = UIAlertController(title: title, message: message,  preferredStyle:  UIAlertControllerStyle.alert)
        
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: MESSAGE_BUTTON_STRING_OK, style: UIAlertActionStyle.default, handler:funcOkButton)
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: MESSAGE_BUTTON_STRING_CANCEL, style: UIAlertActionStyle.cancel, handler:funcCancelButton)
        
        // Actionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // Alertを表示
        viewController.present(alert, animated: true, completion: nil)
    }
    
    ///
    /// メッセージ表示（OKボタン[アクション]）
    ///　- parameter viewController:UIViewController
    ///　- parameter title:メッセージタイトル
    ///　- parameter message:メッセージ内容
    ///　- parameter funcOkButton:OKボタン押下時の関数（func 関数名(action: UIAlertAction) 形式で宣言）
    ///
    static open func dispAlertOKAction(viewController : UIViewController, title : String, message : String, funcOkButton : ((UIAlertAction) -> Swift.Void)?) {
        
        // UIAlertControllerクラスのインスタンスを生成
        let alert: UIAlertController = UIAlertController(title: title, message: message,  preferredStyle:  UIAlertControllerStyle.alert)
        
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: MESSAGE_BUTTON_STRING_OK, style: UIAlertActionStyle.default, handler:funcOkButton)
        
        // Actionを追加
        alert.addAction(defaultAction)
        
        // Alertを表示
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
