//
//  InputPlaceHolderTextView.swift
//  Taskfull
//
//  Created by IscIsc on 2017/03/31.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

//
// UIテキストビュークラス
//
public class UIPlaceHolderTextView: UITextView {
    
    //プレースホルダー実装用設定項目
    lazy var placeHolderLabel:UILabel = UILabel()
    var placeHolderColor:UIColor      = UIColor.lightGrayColor()
    var placeHolder:NSString          = ""
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    /* swift2.0 初期化処理:要エラー対策
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    override init() {
        super.init()
    }
    */

    //オブザーバ解除
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIPlaceHolderTextView.textChanged(_:)), name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    func seetText(text:NSString) {
        super.text = text as String
        self.textChanged(nil)
    }
    
    override public func drawRect(rect: CGRect) {
        if(self.placeHolder.length > 0) {
            self.placeHolderLabel.frame           = CGRectMake(8,8,self.bounds.size.width - 16,0)
            self.placeHolderLabel.lineBreakMode   = NSLineBreakMode.ByWordWrapping
            self.placeHolderLabel.numberOfLines   = 0
            self.placeHolderLabel.font            = self.font
            self.placeHolderLabel.backgroundColor = UIColor.clearColor()
            self.placeHolderLabel.textColor       = self.placeHolderColor
            self.placeHolderLabel.alpha           = 0
            self.placeHolderLabel.tag             = 999
            
            self.placeHolderLabel.text = self.placeHolder as String
            self.placeHolderLabel.sizeToFit()
            self.addSubview(placeHolderLabel)
        }
        
        self.sendSubviewToBack(placeHolderLabel)
        
        // swift2.0 エラー対策(utf16Count)
        if(self.text.utf16.count == 0 && self.placeHolder.length > 0){
            self.viewWithTag(999)?.alpha = 1
        }
        
        super.drawRect(rect)
    }
    
    public func textChanged(notification:NSNotification?) -> (Void) {
        if(self.placeHolder.length == 0){
            return
        }
        
        // swift2.0 エラー対策
        //if(countElements(self.text) == 0) {
        if((self.text.characters.count) == 0) {
            self.viewWithTag(999)?.alpha = 1
        }else{
            self.viewWithTag(999)?.alpha = 0
        }
    }
    
}