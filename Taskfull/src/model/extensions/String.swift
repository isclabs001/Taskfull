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
    
    ///
    /// String -> NSString に変換する
    /// - returns: 変換したNSString
    ///
    func to_ns() -> NSString {
        // StringをNSStringに変換する
        return (self as NSString)
    }
    
    ///
    /// 指定したインデックス開始位置から文字列を切り出す
    /// - param index:文字列を切り出す開始インデックス
    /// - returns: 開始位置から切り出した文字列
    ///
    func substringFromIndex(_ index: Int) -> String {
        /// 開始インデックス以降の文字列を返す
        return to_ns().substring(from: index)
    }
    
    ///
    /// 先頭から指定したインデックス終了位置までの文字列を切り出す
    /// - param index:文字列を切り出す終了インデックス
    /// - returns: 先頭から終了位置まで切り出した文字列
    ///
    func substringToIndex(_ index: Int) -> String {
        /// 先頭から終了インデックスまでの文字列を返す
        return to_ns().substring(to: index)
    }
    
    ///
    /// 指定した範囲の文字列を切り出す
    /// - param range:文字列を切り出す範囲
    /// - returns: 指定した範囲で切り出した文字列
    ///
    func substringWithRange(_ range: NSRange) -> String {
        // 指定した範囲で切り出した文字列を返す
        return to_ns().substring(with: range)
    }
    
    ///
    /// フルパスからファイル名取得
    /// - returns: フルパスのファイル名
    ///
    var lastPathComponent: String {
        return to_ns().lastPathComponent
    }
    
    ///
    /// フルパスから拡張子取得
    /// - returns: フルパスの拡張子
    ///
    var pathExtension: String {
        return to_ns().pathExtension
    }
    
    ///
    /// フルパスからファイル名を除いたディレクトリ取得
    /// - returns: フルパスのディレクトリ
    ///
    var stringByDeletingLastPathComponent: String {
        return to_ns().deletingLastPathComponent
    }
    
    ///
    /// フルパスから拡張子を除いた値を取得
    /// - returns: フルパスから拡張子を除いた値
    ///
    var stringByDeletingPathExtension: String {
        return to_ns().deletingPathExtension
    }
    
    ///
    /// フルパスからパス値（/）で分割して配列にした値を取得
    /// - returns: フルパスからパス値（/）で分割した配列値
    ///
    var pathComponents: [String] {
        return to_ns().pathComponents
    }
    
    ///
    /// 文字数を取得
    /// - returns: 文字数
    ///
    var length: Int {
        return self.characters.count
    }
    
    ///
    /// パスを結合する
    /// - param path:結合するパス
    /// - returns: 結合したパス
    ///
    func stringByAppendingPathComponent(_ path: String) -> String {
        return to_ns().appendingPathComponent(path)
    }
    
    ///
    /// 拡張子を結合する
    /// - param ext:結合する拡張子
    /// - returns: 結合したパス
    ///
    func stringByAppendingPathExtension(_ ext: String) -> String? {
        return to_ns().appendingPathExtension(ext)
    }
}
