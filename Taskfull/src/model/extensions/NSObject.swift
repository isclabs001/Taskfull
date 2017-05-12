//
//  ExtensionNSObject.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/26.
//  Copyright © 2017年 isc. All rights reserved.
//

import Foundation

///
///　NSObjectの拡張クラス
///
extension NSObject {
    ///
    ///　クラス名取得
    ///　- returns:クラス名
    ///
    class var className: String {
        return String(describing: self)
    }
    
    ///
    ///　クラス名取得
    ///　- returns:クラス名
    ///
    var className: String {
        return type(of: self).className
    }
}
