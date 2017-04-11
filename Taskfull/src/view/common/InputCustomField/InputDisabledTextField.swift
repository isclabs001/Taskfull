//
//  InputDisabledTextField.swift
//  Taskfull
//
//  Created by IscIsc on 2017/03/28.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

//
// UIテキストフィールドクラス
//
class InputDisabledTextField : UITextField
{
    
    //コピー,ペースト,メニュー表示を非表示
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.isMenuVisible = false
        return false
    }
    
    //キャレット（入力棒）を非表示
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
}
