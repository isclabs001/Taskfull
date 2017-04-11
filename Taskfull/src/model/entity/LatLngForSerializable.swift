//
//  LatLngForSerializable.swift
//  SchoolCafeteriaMap
//
//  Created by IscIsc on 2016/07/21.
//  Copyright © 2016年 IscIsc. All rights reserved.
//

import Foundation
import CoreLocation

class LatLngForSerializable
{
    /**
     * 緯度
     */
    var Latitude : Double
    
    /**
     * 経度
     */
    var Longitude : Double
    
    /**
     * コンストラクタ
     */
    init()
    {
        self.Latitude = 0
        self.Longitude = 0
    }
    
    /**
     * コンストラクタ
     * - parameter latitude:緯度
     * - parameter longitude:経度
     */
    init(latitude : Double, longitude : Double)
    {
        self.Latitude = latitude
        self.Longitude = longitude
    }
    
    /**
     * コンストラクタ
     * - parameter latlng:緯度・経度
     */
    init(latlng : CLLocationCoordinate2D?)
    {
        if(nil != latlng)
        {
            self.Latitude = latlng!.latitude
            self.Longitude = latlng!.longitude
        }
        else
        {
            self.Latitude = 0
            self.Longitude = 0
        }
    }
    
    /**
     * LatLng型に変換
     * - returns:LatLng
     */
    func toLatLng() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.Latitude, longitude: self.Longitude)
    }
    
    /**
     * 緯度経度の範囲内のチェック
     * - parameter rang1:範囲緯度経度１
     * - parameter rang2:範囲緯度経度２
     * - returns:true:範囲内 false:範囲外
     */
    func isLatLngInArea(_ rang1 : LatLngForSerializable, rang2 : LatLngForSerializable) ->Bool {
        let work1 : LatLngForSerializable = LatLngForSerializable(
            latitude : (rang1.Latitude <= rang2.Latitude) ? rang1.Latitude:rang2.Latitude,
            longitude: (rang1.Longitude <= rang2.Longitude) ? rang1.Longitude:rang2.Longitude)
        let work2 : LatLngForSerializable = LatLngForSerializable(
            latitude : (rang1.Latitude > rang2.Latitude) ? rang1.Latitude:rang2.Latitude,
            longitude: (rang1.Longitude > rang2.Longitude) ? rang1.Longitude:rang2.Longitude)
        
        // 範囲内の場合
        if((work1.Latitude <= self.Latitude && self.Latitude <= work2.Latitude)
            && (work1.Longitude <= self.Longitude && self.Longitude <= work2.Longitude)){
            // trueを返す
            return true
            
        // 上記以外の場合
        } else {
            // falseを返す
            return false
        }
    }
}
