//
//  StringExtensions.swift
//  Taskfull
//
//  Created by IscIsc on 2017/03/31.
//  Copyright © 2017年 isc. All rights reserved.
//

import Foundation

/**
 * String拡張クラス
 */
extension String {
    
    /// String -> NSString に変換する
    func to_ns() -> NSString {
        return (self as NSString)
    }
    
    func substringFromIndex(_ index: Int) -> String {
        return to_ns().substring(from: index)
    }
    
    func substringToIndex(_ index: Int) -> String {
        return to_ns().substring(to: index)
    }
    
    func substringWithRange(_ range: NSRange) -> String {
        return to_ns().substring(with: range)
    }
    
    var lastPathComponent: String {
        return to_ns().lastPathComponent
    }
    
    var pathExtension: String {
        return to_ns().pathExtension
    }
    
    var stringByDeletingLastPathComponent: String {
        return to_ns().deletingLastPathComponent
    }
    
    var stringByDeletingPathExtension: String {
        return to_ns().deletingPathExtension
    }
    
    var pathComponents: [String] {
        return to_ns().pathComponents
    }
    
    var length: Int {
        return self.characters.count
    }
    
    func stringByAppendingPathComponent(_ path: String) -> String {
        return to_ns().appendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(_ ext: String) -> String? {
        return to_ns().appendingPathExtension(ext)
    }
    
}
