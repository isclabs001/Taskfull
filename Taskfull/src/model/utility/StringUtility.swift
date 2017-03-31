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

    
    /**
     * 文字列が空であるかどうかを調べる。
     *
     * - param value:チェックする文字列
     * - returns: {@code value} が {@code null} であるか空文字列の場合は {@code true}、そうでない場合は {@code false}
     */
    static internal func isEmpty(value : String?) -> Bool
    {
        return nil == value || false == isEmpty(value!);
    }
    static internal func isEmpty(value : String) -> Bool
    {
        return 0 == value.characters.count;
    }

    /**
     * 文字列が空でないかどうかを調べる。
     *
     * @param value チェックする文字列
     * @return {@code value} が {@code null} でも空文字列でもない場合は　{@code　true}、そうでない場合は{@code　false}
     */
    static internal func isNotEmpty(value : String?) -> Bool
    {
        return nil != value && true == isNotEmpty(value!);
    }
    static internal func isNotEmpty(value : String) -> Bool
    {
        return value.characters.count > 0;
    }
}