//
//  BaseJsonDataUtility.swift
//
//  Created by IscIsc on 2016/07/20.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import Foundation

///
/// BaseJsonDataUtilityクラス
///
public class BaseJsonDataUtility
{
    ///
    ///　JSON形式の文字列をJSON構造に変換する
    ///　- parameter data:JSON形式の文字列(NSData)
    ///　- returns:JSON構造のDirectory
    ///
    func NSDataToAnyObject(data:NSData) -> AnyObject? {
        var obj:AnyObject?
        do {
            obj = try NSJSONSerialization.JSONObjectWithData(
                data, options:NSJSONReadingOptions.MutableContainers)
        } catch {
            obj = nil
        }
        
        return obj
    }
    
    ///
    ///　JSON項目の値をArray、または、Directoryに変換する
    ///　- parameter itemObj:JSON項目の値(AnyObject)
    ///　- returns:JSON項目の値
    ///
    func JSONItemToObject(itemObj:AnyObject) -> AnyObject {
        switch itemObj {
        // JSON項目の値がNSArrayの場合
        case let ary as NSArray:
            // 配列で格納する
            var ret = [AnyObject]()
            for v in ary {
                ret.append(JSONItemToObject(v))
            }
            return ret
            
        // JSON項目の値がNSDictionaryの場合
        case let dict as NSDictionary:
            // Dictionaryで格納する
            var ret = [String:AnyObject]()
            for (ko, v) in dict {
                if let k = ko as? String {
                    ret[k] = JSONItemToObject(v)
                }
            }
            return ret
            
        // 上記以外の場合
        default:
            // 変換せずにそのまま返す
            return itemObj
        }
    }
    
    ///
    ///　NSDictionary値からString値を取得する
    ///　- parameter response:NSDictionaryオブジェクト
    ///　- parameter key:キー
    ///　- returns:値
    ///
    func getStringForResponse(response : NSDictionary, key : String) -> String {
        return getStringForResponse(response, key: key, defaultValue: StringUtility.EMPTY);
    }
    
    ///
    ///　NSDictionary値からString値を取得する
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
    ///　NSDictionary値からDate値を取得する
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
    ///　NSDictionary値からint値を取得する
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
    ///　NSDictionary値からdouble値を取得する
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
}

///
/// BaseJsonDataUtilityクラスプロパティ
///
extension BaseJsonDataUtility {
    ///
    ///　JSON保管ディレクトリを取得する
    ///　- returns:JSON保管ディレクトリ
    ///
    public class func getJSONSaveDirectory() -> String {
        return CommonConst.DIRECTORY_APPLICATION_SUPPORT
    }
}