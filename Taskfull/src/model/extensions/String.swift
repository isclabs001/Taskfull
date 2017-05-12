//
//  StringExtension.swift
//  SlideMenuControllerSwift
//
//  Created by IscIsc on 2017/04/26.
//  Copyright © 2017年 isc. All rights reserved.
//

import Foundation

///
/// String拡張クラス
///
extension String {
    ///
    ///　クラス名を取得
    ///　- returns:クラス名
    ///
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    ///
    ///　文字列切り出し処理
    ///　- parameter from:文字列切出し位置
    ///　- returns:切り出した文字列
    ///
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
}
