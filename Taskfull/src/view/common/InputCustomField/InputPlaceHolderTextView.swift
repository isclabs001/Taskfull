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
open class UIPlaceHolderTextView: UITextView {
    
    //プレースホルダー実装用設定項目
    lazy var placeHolderLabel:UILabel = UILabel()
    var placeHolderColor:UIColor      = UIColor.lightGray
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
        NotificationCenter.default.removeObserver(self)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIPlaceHolderTextView.textChanged(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    func seetText(_ text:NSString) {
        super.text = text as String
        self.textChanged(nil)
    }
    
    override open func draw(_ rect: CGRect) {
        if(self.placeHolder.length > 0) {
            self.placeHolderLabel.frame           = CGRect(x: 8,y: 8,width: self.bounds.size.width - 16,height: 0)
            self.placeHolderLabel.lineBreakMode   = NSLineBreakMode.byWordWrapping
            self.placeHolderLabel.numberOfLines   = 0
            self.placeHolderLabel.font            = self.font
            self.placeHolderLabel.backgroundColor = UIColor.clear
            self.placeHolderLabel.textColor       = self.placeHolderColor
            self.placeHolderLabel.alpha           = 0
            self.placeHolderLabel.tag             = 999
            
            self.placeHolderLabel.text = self.placeHolder as String
            self.placeHolderLabel.sizeToFit()
            self.addSubview(placeHolderLabel)
        }
        
        self.sendSubview(toBack: placeHolderLabel)
        
        // swift2.0 エラー対策(utf16Count)
        if(self.text.utf16.count == 0 && self.placeHolder.length > 0){
            self.viewWithTag(999)?.alpha = 1
        }
        
        super.draw(rect)
    }
    
    open func textChanged(_ notification:Notification?) -> (Void) {
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
