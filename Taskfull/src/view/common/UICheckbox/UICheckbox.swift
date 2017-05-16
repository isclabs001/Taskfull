//
//  UICheckbox.swift
//  Taskfull
//
//  Created by IscIsc on 2017/05/16.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

//
// チェックボックスクラス
//
@IBDesignable
class UICheckbox : UIView
{
    /**
     * 定数
     */
    // UICheckboxの一意名
    static let UICheckboxIdentifier : String = "UICheckbox"
    
    /// タイトルラベル
    @IBOutlet weak var lblTitle: UILabel!
    
    /// チェックボックス
    @IBOutlet weak var btnCheck: UIButton!

    /**
     * プロパティ
     */
    // ラベルタイトル文字列
    @IBInspectable var labelTitle: String = StringUtility.EMPTY {
        didSet{
            self.lblTitle.text = labelTitle
        }
    }
    
    ///
    ///　初期化処理（Storyboard/xibから）
    ///　- parameter aDecoder:NSCoder
    ///
    required init?(coder aDecoder: NSCoder) {
        // 基底の初期化処理
        super.init(coder: aDecoder)
        
        // 初期化処理
        self.initCustumControl()
    }
    
    ///
    ///　初期化処理（コードから）
    ///　- parameter frame:位置・サイズ
    ///
    override init(frame: CGRect) {
        // 基底の初期化処理
        super.init(frame: frame)
        
        // 初期化処理
        self.initCustumControl()
    }

    ///
    ///　初期化処理
    ///
    func initCustumControl() {
        // xib からカスタムViewをロードする
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: UICheckbox.UICheckboxIdentifier, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        // 親に追加
        self.addSubview(view)

        // ボタンクリックイベント
        self.btnCheck.addTarget(self, action: #selector(UICheckbox.onClickCheckbox(sender:)), for: .touchUpInside)
        // ボタンに画像セット
        self.btnCheck.setImage(UIImage(named: "btn_check_on.png"), for: UIControlState.selected)
        self.btnCheck.setImage(UIImage(named: "btn_check_off.png"), for: UIControlState.normal)
    }
    
    ///
    ///　チェックボックスタップイベント処理
    ///　- parameter sender:UIButton
    ///
    internal func onClickCheckbox(sender: UIButton){
        // 状態を反転する
        self.btnCheck.isSelected = !self.btnCheck.isSelected
    }
}
