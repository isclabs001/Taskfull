//
//  FunctionUtility.swift
//  Taskfull
//
//  Created by IscIsc on 2016/07/21.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import Foundation

///
/// 共通関数群
///
class FunctionUtility
{
    static internal let DefaultDate : Date = FunctionUtility.yyyyMMddToDate("19000101")
    
    ///
    ///　yyyyMMdd形式の文字列を日付に変換する
    ///　- parameter date:yyyyMMdd形式の文字列
    ///　- returns:変換した日付
    ///
    static func yyyyMMddToDate(_ date : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return Date(timeInterval: 0, since: dateFormatter.date(from: date)!)
    }
 
    ///
    ///　yyyyMMddHHmmss形式の文字列を日付に変換する
    ///　- parameter date:yyyyMMddHHmmss形式の文字列
    ///　- returns:変換した日付
    ///
    static func yyyyMMddHHmmssToDate(_ date : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return Date(timeInterval: 0, since: dateFormatter.date(from: date.replacingOccurrences(of: "/", with: StringUtility.EMPTY).replacingOccurrences(of: ":", with: StringUtility.EMPTY).replacingOccurrences(of: " ", with: StringUtility.EMPTY))!)
    }
    
    ///
    ///　日付日時を"yyyy年MM月dd日(曜日) HH時mm分"文字列に変換する
    ///　- parameter date:日付日時
    ///　- returns:変換した文字列&曜日
    ///
    static func DateToyyyyMMddHHmm_JP(_ date : Date) -> String
    {
        let dateFormatter = DateFormatter()
        // 日本語の場合(言語ではなく地域設定)
        if(CommonConst.LOCALE_LANGUAGE_JAPANESE == Locale.preferredLanguages.first){
            //曜日名取得の為JPにロケール変更
            dateFormatter.locale = Locale(identifier: CommonConst.LOCALE_LANGUAGE_JAPANESE)
            //文字列変換&shortWeekdaySymbolsプロパティより曜日名取得
            dateFormatter.dateFormat = "yyyy年MM月dd日(E) HH時mm分"

        // 上記以外の場合
        } else {
            // 曜日名取得の為USにロケール変更
            dateFormatter.locale = Locale(identifier: CommonConst.LOCALE_LANGUAGE_ENGLISH)
            
            // 文字列変換&shortWeekdaySymbolsプロパティより曜日名取得
            // "MM/dd/yyyy(曜日) HH:mm"とする
            dateFormatter.dateFormat = "MM/dd/yyyy(E) HH:mm"
        }
        return dateFormatter.string(from: date)
    }
    
    ///
    ///　日付日時を"M月d日(曜日) HH時mm分"文字列に変換する
    ///　- parameter date:日付日時
    ///　- returns:変換した文字列&曜日("M月d日(曜日) HH時mm分")
    ///
    static func DateToMdHHmm_JP(_ date : Date) -> String
    {
        let dateFormatter = DateFormatter()
        // 日本語の場合
        if(CommonConst.LOCALE_LANGUAGE_JAPANESE == Locale.preferredLanguages.first){
            // 曜日名取得の為JPにロケール変更
            dateFormatter.locale = Locale(identifier: CommonConst.LOCALE_LANGUAGE_JAPANESE)
        
            // 文字列変換&shortWeekdaySymbolsプロパティより曜日名取得
            // "M月d日(曜日) HH時mm分"とする
            dateFormatter.dateFormat = "M月d日(E) HH時mm分"

        // 上記以外の場合
        } else {
            // 曜日名取得の為USにロケール変更
            dateFormatter.locale = Locale(identifier: CommonConst.LOCALE_LANGUAGE_ENGLISH)
            
            // 文字列変換&shortWeekdaySymbolsプロパティより曜日名取得
            // "M/d(曜日) HH:mm"とする
            dateFormatter.dateFormat = "M/d(E) HH:mm"
        }
        
        return dateFormatter.string(from: date)
    }
    
    ///
    ///　日付をfalse:yyyyMMddHHmmss、または、yyyy/MM/dd HH:mm:ssに変換する
    ///　- parameter date:yyyyMMdd形式の文字列
    ///　- parameter separation:true:yyyy/MM/dd HH:mm:ss形式の文字列 false:yyyyMMddHHmmss形式の文字列
    ///　- returns:変換した日付
    ///
    static func DateToyyyyMMddHHmmss(_ date : Date, separation : Bool) -> String
    {
        let dateFormatter = DateFormatter()
        if(true == separation) {
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        } else {
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
        }
        return dateFormatter.string(from: date)
    }
    
    ///
    ///　日付をfalse:yyyyMMddHHmm、または、yyyy/MM/dd HH:mmに変換する
    ///　- parameter date:yyyyMMdd形式の文字列
    ///　- parameter separation:true:yyyy/MM/dd HH:mm形式の文字列 false:yyyyMMddHHmm形式の文字列
    ///　- returns:変換した日付
    ///
    static func DateToyyyyMMddHHmm(_ date : Date, separation : Bool) -> String
    {
        let dateFormatter = DateFormatter()
        if(true == separation) {
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        } else {
            dateFormatter.dateFormat = "yyyyMMddHHmm"
        }
        return dateFormatter.string(from: date)
    }
    
    ///
    ///　時間の差処理
    ///　- parameter date1:基準日付
    ///　- parameter date2:対象日付
    ///　- returns:時間数差
    ///
    static func DiffHour(_ date1 : Date, date2 : Date) -> Int {
        return Int(date1.timeIntervalSince(date2) / 60 / 60)
    }
    
    ///
    ///　秒の差処理
    ///　- parameter date1:基準日付
    ///　- parameter date2:対象日付
    ///　- returns:時間数差
    ///
    static func DiffSec(_ date1 : Date, date2 : Date) -> Int {
        return Int(date1.timeIntervalSince(date2))
    }
    
    ///
    ///　時間の差処理
    ///　- parameter date1:基準日付
    ///　- parameter date2:対象日付
    ///　- returns:時間数差
    ///
    static func DiffHour(_ date1 : String, date2 : String) -> Int {
        // 時間の差処理
        return DiffHour(yyyyMMddHHmmssToDate(date1), date2: yyyyMMddHHmmssToDate(date2))
    }
    
    ///
    ///　日の差処理
    ///　- parameter date1:基準日付
    ///　- parameter date2:対象日付
    ///　- returns:日数差
    ///
    static func DiffDate(_ date1 : Date, date2 : Date) -> Int {
        // 秒の差を日に変換
        return Int(DiffHour(date1, date2: date2) / 24)
    }
    
    ///
    ///　日の差処理
    ///　- parameter date1:基準日付
    ///　- parameter date2:対象日付
    ///　- returns:日数差
    ///
    static func DiffDate(_ date1 : String, date2 : String) -> Int {
        // 秒の差を日に変換
        return Int(DiffHour(yyyyMMddHHmmssToDate(date1), date2: yyyyMMddHHmmssToDate(date2)) / 24)
    }
    
    ///
    ///　本日以降かどうかの判断
    ///　- parameter date1:基準日付
    ///　- parameter date2:対象日付
    ///　- returns:true:本日以降である false:本日以降ではない
    ///
    static func isToday(_ date1 : String, date2 : String) -> Bool {
        // 引数が有効な場合
        if(10 <= date1.length && 10 <= date2.length) {
            // yyyy/MM/ddを取得
            let workDate1 : String = date1.substringToIndex(10)
            // yyyy/MM/ddを取得
            let workDate2 : String = date2.substringToIndex(10)
        
            // 本日以降の場合
            if(workDate1 >= workDate2){
                // true
                return true
            // 上記以外の場合
            } else {
                // false
                return false
            }
            
        // 上記以外の場合
        } else {
            // false
            return false
        }
    }
    
    ///
    ///　NSDictionaryに指定されたキーが存在するかの判断処理
    ///　- parameter response:NSDictionaryオブジェクト
    ///　- parameter key:キー
    ///　- returns:true:存在する false:存在しない
    ///
    static func isContains(_ dic : NSDictionary, key : String) -> Bool
    {
        var ret = false
        
        // キーが存在する場合
        if (dic[key] as? NSString) != nil
        {
            // trueを返す
            ret = true
        }
        
        return ret
    }
    
    ///
    ///　NSDictionaryに指定されたキーの値（String）を取得
    ///　- parameter response:NSDictionaryオブジェクト
    ///　- parameter key:キー
    ///　- parameter defaultValue:デフォルト値
    ///　- returns:値
    ///
    static func getStriing(_ dic : NSDictionary, key : String, defaultValue : String) -> String
    {
        var ret : String = defaultValue
        
        // キーが存在する場合
        if let value = dic[key] as? NSString
        {
            // 値を取得
            let strValue : String = String(value)
            // 値が空文字ではない場合
            if strValue != StringUtility.EMPTY
            {
                // 値を取得する
                ret = strValue
            }
        }
        
        return ret
    }
    
    ///
    ///　NSDictionaryに指定されたキーの値（String）を取得
    ///　- parameter response:NSDictionaryオブジェクト
    ///　- parameter key:キー
    ///　- returns:値
    ///
    static func getStriing(_ dic : NSDictionary, key : String) -> String
    {
        return getStriing(dic, key: key, defaultValue: StringUtility.EMPTY)
    }

    ///
    ///　全角カタカナから全角ひらがなへ変換
    ///　- parameter kana:全角カタカナ
    ///　- returns:全角ひらがな
    ///
    static func zenkakuKatakanaToZenkakuHiragana(_ kana : String) -> String
    {
        var ret = ""
        
        // Unicodeを取得
        for c in kana.unicodeScalars {
            // 全角カタカナの場合
            if c.value >= 0x30A1 && c.value <= 0x30F6 {
                // 「0x0060」を加算して、全角ひらがなに変換して追加
                ret.append(String(describing: UnicodeScalar(c.value + 0x0060)))
            
            // 上記以外の場合
            } else {
                // そのまま追加
                ret.append(String(c))
            }
        }
    
        return ret;
    }
}
