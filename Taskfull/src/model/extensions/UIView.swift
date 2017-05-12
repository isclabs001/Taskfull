//
//  UIView.swift
//  SlideMenuControllerSwift
//
//  Created by IscIsc on 2017/04/26.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

///
/// UIView拡張クラス
///
extension UIView {
    ///
    ///　ビューにNibを関連させる
    ///　- parameter viewType:ビューの形式
    ///　- returns:T（ジェネリック）型
    ///
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    ///
    ///　自分自身のUIViewにNibを関連させる
    ///　- returns:自分自身
    ///
    class func loadNib() -> Self {
        return loadNib(self)
    }
}
