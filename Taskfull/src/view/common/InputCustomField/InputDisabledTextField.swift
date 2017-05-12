//
//  InputDisabledTextField.swift
//  Taskfull
//
//  Created by IscIsc on 2017/03/28.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

//
// 入力不可UIテキストフィールドクラス
//
class InputDisabledTextField : UITextField
{
    ///
    /// メニュー表示イベント
    ///　- parameter:action:Selectorオブジェクト
    ///　- parameter:sender:senderオブジェクト
    ///　- returns メニューを表示させないため、常にfalse
    ///
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // コピー,ペースト,メニュー表示を非表示
        UIMenuController.shared.isMenuVisible = false
        return false
    }
    
    ///
    /// キャレット表示イベント
    ///　- parameter:action:Selectorオブジェクト
    ///　- returns 常にfalse
    ///
    override func caretRect(for position: UITextPosition) -> CGRect {
        // キャレット（入力棒）を非表示
        return CGRect.zero
    }
}
