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
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        UIMenuController.sharedMenuController().menuVisible = false
        return false
    }
    
    //キャレット（入力棒）を非表示
    override func caretRectForPosition(position: UITextPosition) -> CGRect {
        return CGRectZero
    }
}
