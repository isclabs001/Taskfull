//
//  FunctionUtility.swift
//  SchoolCafeteriaMap
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
    static internal let DefaultDate : NSDate = FunctionUtility.yyyyMMddToDate("19000101")
    
    ///
    ///　yyyyMMdd形式の文字列を日付に変換する
    ///　- parameter date:yyyyMMdd形式の文字列
    ///　- returns:変換した日付
    ///
    static func yyyyMMddToDate(date : String) -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return NSDate(timeInterval: 0, sinceDate: dateFormatter.dateFromString(date)!)
    }
 
    ///
    ///　yyyyMMddHHmmss形式の文字列を日付に変換する
    ///　- parameter date:yyyyMMddHHmmss形式の文字列
    ///　- returns:変換した日付
    ///
    static func yyyyMMddHHmmssToDate(date : String) -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return NSDate(timeInterval: 0, sinceDate: dateFormatter.dateFromString(date.stringByReplacingOccurrencesOfString("/", withString: StringUtility.EMPTY).stringByReplacingOccurrencesOfString(":", withString: StringUtility.EMPTY).stringByReplacingOccurrencesOfString(" ", withString: StringUtility.EMPTY))!)
    }
    
    ///
    ///　日付日時を"yyyy年MM月dd日(曜日)HH時mm分"文字列に変換する
    ///　- parameter date:日付日時
    ///　- returns:変換した文字列&曜日
    ///
    static func DateToyyyyMMddHHmm_JP(date : NSDate) -> String
    {
        //曜日インデックス取得
        let cal : NSCalendar = NSCalendar(identifier : NSCalendarIdentifierGregorian)!
        let comp : NSDateComponents = cal.components([NSCalendarUnit.Weekday], fromDate: date)
        let weekday : Int = comp.weekday
        let weekdaySymbolIndex : Int  = weekday - 1
        
        //曜日名取得の為JPにロケール変更
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        //文字列変換&shortWeekdaySymbolsプロパティより曜日名取得
        dateFormatter.dateFormat = "yyyy年MM月dd日(\(dateFormatter.shortWeekdaySymbols[weekdaySymbolIndex]))HH時mm分"
        return dateFormatter.stringFromDate(date)
    }
    
    ///
    ///　日付をfalse:yyyyMMddHHmmss、または、yyyy/MM/dd HH:mm:ssに変換する
    ///　- parameter date:yyyyMMdd形式の文字列
    ///　- parameter separation:true:yyyy/MM/dd HH:mm:ss形式の文字列 false:yyyyMMddHHmmss形式の文字列
    ///　- returns:変換した日付
    ///
    static func DateToyyyyMMddHHmmss(date : NSDate, separation : Bool) -> String
    {
        let dateFormatter = NSDateFormatter()
        if(true == separation) {
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        } else {
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
        }
        return dateFormatter.stringFromDate(date)
    }
    
    ///
    ///　時間の差処理
    ///　- parameter date1:基準日付
    ///　- parameter date2:対象日付
    ///　- returns:時間数差
    ///
    static func DiffHour(date1 : String, date2 : String) -> Int {
        let date1Work : NSDate = yyyyMMddHHmmssToDate(date1)
        let date2Work : NSDate = yyyyMMddHHmmssToDate(date2)
        
        // 秒の差を時間に変換
        return Int(date1Work.timeIntervalSinceDate(date2Work) / 60 / 60)
    }
    
    ///
    ///　日の差処理
    ///　- parameter date1:基準日付
    ///　- parameter date2:対象日付
    ///　- returns:日数差
    ///
    static func DiffDate(date1 : String, date2 : String) -> Int {
        // 秒の差を日に変換
        return Int(DiffHour(date1, date2: date2) / 24)
    }
    
    ///
    ///　NSDictionaryに指定されたキーが存在するかの判断処理
    ///　- parameter response:NSDictionaryオブジェクト
    ///　- parameter key:キー
    ///　- returns:true:存在する false:存在しない
    ///
    static func isContains(dic : NSDictionary, key : String) -> Bool
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
    static func getStriing(dic : NSDictionary, key : String, defaultValue : String) -> String
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
    static func getStriing(dic : NSDictionary, key : String) -> String
    {
        return getStriing(dic, key: key, defaultValue: StringUtility.EMPTY)
    }

    ///
    ///　全角カタカナから全角ひらがなへ変換
    ///　- parameter kana:全角カタカナ
    ///　- returns:全角ひらがな
    ///
    static func zenkakuKatakanaToZenkakuHiragana(kana : String) -> String
    {
        var ret = ""
        
        // Unicodeを取得
        for c in kana.unicodeScalars {
            // 全角カタカナの場合
            if c.value >= 0x30A1 && c.value <= 0x30F6 {
                // 「0x0060」を加算して、全角ひらがなに変換して追加
                ret.append(UnicodeScalar(c.value + 0x0060))
            
            // 上記以外の場合
            } else {
                // そのまま追加
                ret.append(c)
            }
        }
    
        return ret;
    }
}