//
//  BaseJsonDataUtility.swift
//  SchoolCafeteriaMap
//
//  Created by IscIsc on 2016/07/20.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import Foundation

class BaseJsonDataUtility
{
    ///
    ///　レスポンス値からString値を取得する
    ///　- parameter response:NSDictionaryオブジェクト
    ///　- parameter key:キー
    ///　- returns:値
    ///
    func getStringForResponse(response : NSDictionary, key : String) -> String {
        return getStringForResponse(response, key: key, defaultValue: StringUtility.EMPTY);
    }
    
    ///
    ///　レスポンス値からString値を取得する
    ///　- parameter response:NSDictionaryオブジェクト
    ///　- parameter key:キー
    ///　- parameter defaultValue デフォルト値
    ///　- returns:値
    ///
    func getStringForResponse(response : NSDictionary, key : String, defaultValue : String) -> String
    {
        return FunctionUtility.getStriing(response, key: key, defaultValue: defaultValue)
    }
    
    ///
    ///　レスポンス値からDate値を取得する
    ///　- parameter response:NSDictionaryオブジェクト
    ///　- parameter key:キー
    ///　- returns:値
    ///
    func getDateForResponse(response : NSDictionary, key : String) -> NSDate
    {
        var ret : NSDate = FunctionUtility.DefaultDate;
    
        // キーに対する文字列取得
        let strValue : String = FunctionUtility.getStriing(response, key: key)

        // 値が空文字ではない場合
        if strValue != StringUtility.EMPTY
        {
            // 日付型に変換する
            ret = FunctionUtility.yyyyMMddToDate(strValue)
        }
        return ret
    }
   
    ///
    ///　レスポンス値からint値を取得する
    ///　- parameter response:NSDictionaryオブジェクト
    ///　- parameter key:キー
    ///　- parameter defaultValue:デフォルト値
    ///　- returns:値
    ///
    func getIntForResponse(response : NSDictionary, key : String, defaultValue : Int) -> Int
    {
        var ret : Int = defaultValue;
    
        // キーに対する文字列取得
        let strValue : String = FunctionUtility.getStriing(response, key: key)
        
        // 値が空文字ではない場合
        if strValue != StringUtility.EMPTY
        {
            // 値を取得する
            if let intValue = Int(strValue) as Int!
            {
                ret = intValue
            }
        }
        return ret
    }
    
    ///
    ///　レスポンス値からdouble値を取得する
    ///　- parameter response:NSDictionaryオブジェクト
    ///　- parameter key:キー
    ///　- parameter defaultValue:デフォルト値
    ///　- returns:値
    ///
    func getDoubleForResponse(response : NSDictionary, key : String, defaultValue : Double) -> Double
    {
        var ret : Double = defaultValue;

        // キーに対する文字列取得
        let strValue : String = FunctionUtility.getStriing(response, key: key)
        
        // 値が空文字ではない場合
        if strValue != StringUtility.EMPTY
        {
            // 値を取得する
            if let dblValue = Double(strValue) as Double!
            {
                ret = dblValue
            }
        }
        return ret
    }
    
//    ///
//    ///　バージョン番号取得
//    ///　- parameter data:データ
//    ///　- returns:バージョン番号
//    ///
//    func getVesion(data : NSDictionary) -> String
//    {
//        return getStringForResponse(data, key : CommonConst.JSON_FIELD_VERSION)
//    }
//    
//    ///
//    ///　URL01取得
//    ///　- parameter data:データ
//    ///　- returns:URL01
//    ///
//    func getUrl01(data : NSDictionary) -> String
//    {
//        return getStringForResponse(data, key: CommonConst.JSON_FIELD_URL01)
//    }
//    
//    ///
//    ///　URL02取得
//    ///　- parameter data:データ
//    ///　- returns:URL02
//    ///
//    func getUrl02(data : NSDictionary) -> String
//    {
//        return getStringForResponse(data, key: CommonConst.JSON_FIELD_URL02)
//    }
}