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
public class BaseJsonDataUtility : JSON
{
    ///
    ///　JSONファイルに保存する
    ///　- parameter fileName:ファイル名
    ///　- returns:true:正常 false:異常
    ///
    public func saveJSONFile(fileName : String) -> Bool {
        var ret : Bool = false
        
        // データが有効な場合
        if(false == self.isError && false == self.isNull){
            // 保存フルパスを取得
            let fullPath : String = BaseJsonDataUtility.getJSONSaveDirectory().stringByAppendingPathExtension(fileName)!
            
            // NSArray型の場合
            if(true == self.isArray){
                // ファイルに保存する
                let buf : NSArray = self.data! as! NSArray
                buf.writeToFile(fullPath, atomically: true)
                ret = true

            // NSDictionary型の場合
            } else if(true == self.isDictionary){
                // ファイルに保存する
                let buf : NSDictionary = self.data! as! NSDictionary
                buf.writeToFile(fullPath, atomically: true)
                ret = true
            }
        }
        
        // 処理結果を返す
        return ret
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

    ///
    ///　JSONファイルからBaseJsonDataUtility取得する
    ///　- parameter fileName:ファイル名
    ///　- returns:読み込んだJSONファイルのBaseJsonDataUtility
    ///
    public class func readJSONFile(fileName : String) -> BaseJsonDataUtility {
        
        // JSON保管ディレクトリにあるファイルを読込む
        let jsonData = NSData(contentsOfFile: getJSONSaveDirectory().stringByAppendingPathComponent(fileName))!
        
        // BaseJsonDataUtilityオブジェクトに変換する
        return BaseJsonDataUtility(jsonData)
    }
}