//
//  TaskJsonUtility.swift
//  Taskfull
//
//  Created by IscIsc on 2017/03/31.
//  Copyright © 2017年 isc. All rights reserved.
//

import Foundation


///
/// TaskJsonUtilityクラス
///
public class TaskJsonUtility : BaseJsonDataUtility
{
    private let template:[String:AnyObject] = [
        "array": [JSON.null, false, 0, "", [], [:]],
        "object":[
            "null":   JSON.null,
            "bool":   true,
            "int":    42,
            "int64":  NSNumber(longLong: 2305843009213693951), // for 32-bit environment
            "double": 3.141592653589793,
            "string": "a α\t弾\nð",
            "array":  [],
            "object": [:]
        ],
        "url":"http://blog.livedoor.com/dankogai/"
    ]
}