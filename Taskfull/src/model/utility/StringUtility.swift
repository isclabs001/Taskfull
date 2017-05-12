//
//  StringUtility.swift
//  SchoolCafeteriaMap
//
//  Created by IscIsc on 2016/07/20.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import Foundation

///
///　文字列共通関数群
///
class StringUtility
{
    /**
     * 空文字
     */
    static internal let EMPTY : String = ""
    /**
     * 半角空白
     */
    static internal let HALF_SPACE : String = " ";
    /**
     * 全角空白
     */
    static internal let FULL_SPACE : String = "　";
    /**
     * 改行
     */
    static internal let CRLF : String = "\r\n";
    /**
     * 改行
     */
    static internal let LF : String = "\n";
    /**
     * BR
     */
    static internal let BR : String = "<br>";
    /**
     * スラッシュ文字
     */
    static internal let SLASH : String = "/";
    /**
     * アンパサンド文字
     */
    static internal let AMP : String = "&";

    
    ///
    ///　文字列が空であるかどうかを調べる。
    ///　- parameter value:チェックする文字列
    ///　- returns:空文字列の場合:true、空文字列ではない場合:false
    ///
    static internal func isEmpty(_ value : String?) -> Bool
    {
        return nil == value || false == isEmpty(value!);
    }
    static internal func isEmpty(_ value : String) -> Bool
    {
        return 0 == value.characters.count;
    }

    ///
    ///　文字列が空でないかを調べる。
    ///　- parameter value:チェックする文字列
    ///　- returns:空文字列ではない場合:true、空文字列の場合:false
    ///
    static internal func isNotEmpty(_ value : String?) -> Bool
    {
        return nil != value && true == isNotEmpty(value!);
    }
    static internal func isNotEmpty(_ value : String) -> Bool
    {
        return value.characters.count > 0;
    }
}
