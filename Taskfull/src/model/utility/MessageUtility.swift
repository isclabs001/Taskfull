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
        let defaultAction: UIAlertAction = UIAlertAction(title: MessageUtility.getMessage(key: "MessageStringButtonOK"), style: UIAlertActionStyle.default, handler:nil)

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
        let defaultAction: UIAlertAction = UIAlertAction(title: MessageUtility.getMessage(key: "MessageStringButtonOK"), style: UIAlertActionStyle.default, handler:funcOkButton)
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: MessageUtility.getMessage(key: "MessageStringButtonCancel"), style: UIAlertActionStyle.cancel, handler:funcCancelButton)
        
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
        let defaultAction: UIAlertAction = UIAlertAction(title: MessageUtility.getMessage(key: "MessageStringButtonOK"), style: UIAlertActionStyle.default, handler:funcOkButton)
        
        // Actionを追加
        alert.addAction(defaultAction)
        
        // Alertを表示
        viewController.present(alert, animated: true, completion: nil)
    }
    
    ///
    /// メッセージ取得
    ///　- parameter key:メッセージリソースキー
    ///　- returns: メッセージ
    ///
    static open func getMessage(key : String) -> String {
        return NSLocalizedString(key, comment: StringUtility.EMPTY)
    }
    
    ///
    /// メッセージ取得
    ///　- parameter key:メッセージリソースキー
    ///　- parameter param:メッセージパラメーター
    ///　- returns: メッセージ
    ///
    static open func getMessage(key : String, param : String) -> String {
        return "".appendingFormat(getMessage(key : key),param)
    }
}
