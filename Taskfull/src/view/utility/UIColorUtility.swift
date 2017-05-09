//
//  UIColorUtility.swift
//  Taskfull
//
//  Created by IscIsc on 2017/03/11.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

///
/// UIClolor共通関数群
///
class UIColorUtility {
    
    ///
    ///　RGBからUIColorに変換する
    ///　- parameter r:赤 0 〜 255
    ///　- parameter g:緑 0 〜 255
    ///　- parameter b:青 0 〜 255
    ///　- parameter alpha:1.0 非透明 〜 0.0 透明
    ///　- returns:UIColor
    ///
    static func hexRgb(_ rgb : Int) -> UIColor
    {
        return UIColorUtility.rgb(((rgb>>16) & 0xFF), g : ((rgb>>8) & 0xFF), b : (rgb & 0xFF))
    }
    
    ///
    ///　RGBからUIColorに変換する
    ///　- parameter r:赤 0 〜 255
    ///　- parameter g:緑 0 〜 255
    ///　- parameter b:青 0 〜 255
    ///　- returns:UIColor
    ///
    static func rgb(_ r : Int, g : Int, b : Int) -> UIColor
    {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0);
    }
    
    ///
    ///　RGBからUIColorに変換する
    ///　- parameter r:赤 0 〜 255
    ///　- parameter g:緑 0 〜 255
    ///　- parameter b:青 0 〜 255
    ///　- parameter alpha:1.0 非透明 〜 0.0 透明
    ///　- returns:UIColor
    ///
    static func rgba(_ r : Int, g : Int, b : Int, alpha : CGFloat) -> UIColor
    {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha);
    }
    
    
    static func getColor(_ size: Int, image: CGImage, pos: CGPoint, pixelDataByteSize: Int) -> UIColor {
        return getColor( size, image: image, pos: pos, pixelDataByteSize: pixelDataByteSize, scale: UIScreen.main.scale)
    }
    
    static func getColor(_ size: Int, image: CGImage, pos: CGPoint, pixelDataByteSize: Int, scale: CGFloat) -> UIColor {
        
        let imageData = image.dataProvider?.data
        let data : UnsafePointer = CFDataGetBytePtr(imageData)
        let address : Int = ((size * Int(pos.y * scale)) + Int(pos.x * scale)) * pixelDataByteSize
        let r = CGFloat(data[address])
        let g = CGFloat(data[address+1])
        let b = CGFloat(data[address+2])
        let a = CGFloat(data[address+3])
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    static func getColorNonAlpha(_ size: Int, image: CGImage, pos: CGPoint, pixelDataByteSize: Int) -> UIColor {
        return getColorNonAlpha( size, image: image, pos: pos, pixelDataByteSize: pixelDataByteSize, scale: UIScreen.main.scale)
    }
    
    static func getColorNonAlpha(_ size: Int, image: CGImage, pos: CGPoint, pixelDataByteSize: Int, scale: CGFloat) -> UIColor {
        
        let imageData = image.dataProvider?.data
        let data : UnsafePointer = CFDataGetBytePtr(imageData)
        let address : Int = ((size * Int(pos.y * scale)) + Int(pos.x * scale)) * pixelDataByteSize
        let r = CGFloat(data[address])
        let g = CGFloat(data[address+1])
        let b = CGFloat(data[address+2])
        let a = CGFloat(255)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    
    static func convImagePos(_ pos: CGPoint, orgImageSize: Int, crntImageSize: Int) -> CGPoint{
        
        // 縮小倍率係数取得
        let zoom = getZoomShrink(orgImageSize, crntImageSize: crntImageSize)

        // 位置を縮小倍率係数で補正する
        return CGPoint(x: pos.x * zoom, y: pos.y * zoom)
    }
    
    static func getZoom(_ orgImageSize: Int, crntImageSize: Int) -> CGFloat{
        //倍率を算出
        return CGFloat(orgImageSize) / CGFloat(crntImageSize)
    }
    
    static func getZoomShrink(_ orgImageSize: Int, crntImageSize: Int) -> CGFloat{
        //縮小倍率を算出
        return CGFloat(crntImageSize) / CGFloat(orgImageSize)
    }

    
    static func getAlphaColor(_ size: Int, image: CGImage, pos: CGPoint, pixelDataByteSize: Int) -> CGFloat {
        
        let imageData = image.dataProvider?.data
        let data : UnsafePointer = CFDataGetBytePtr(imageData)
//        let scale = UIScreen.mainScreen().scale
        let scale : CGFloat = 1.0
        let address : Int = ((size * Int(pos.y * scale)) + Int(pos.x * scale)) * pixelDataByteSize

        return CGFloat(data[address+3])
    }

}
