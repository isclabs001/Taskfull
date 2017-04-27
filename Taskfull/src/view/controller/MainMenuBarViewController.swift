//
//  MainMenuBarViewController.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/26.
//  Copyright © 2017年 isc. All rights reserved.
//

import UIKit

///
/// MainMenuBarProtocol定義
///
protocol MainMenuBarProtocol : class {
    // changeViewControllerイベント
    func changeViewController(_ categoryType: CommonConst.CategoryType)
}

///
/// メインメニューバークラス
///
class MainMenuBarViewController : BaseViewController, MainMenuBarProtocol, UITableViewDelegate, UITableViewDataSource {
    /**
     * 定数
     */

    /**
     * 変数
     */
    // テーブルメニューバー
    @IBOutlet weak var tvMenuBar: UITableView!

    // メイン画面コントロール
    var mainViewController: UIViewController!
    
    ///
    /// 初期化処理
    ///　- parameter:aDecoder:NSCoder
    ///
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    ///
    /// viewDidLoadイベント処理
    ///
    override func viewDidLoad() {
        super.viewDidLoad()

        // 空白行は表示させない
        let clearView : UIView = UIView(frame : CGRect.zero)
        clearView.backgroundColor = UIColor.clear
        self.tvMenuBar.tableHeaderView = clearView
        self.tvMenuBar.tableFooterView = clearView
        // 背景は灰色にする
        self.tvMenuBar.backgroundColor = UIColor.lightGray
        // スクロールさせない
        self.tvMenuBar.isScrollEnabled = false
        // delegateを自分自身に設定
        self.tvMenuBar.delegate = self
        // dataSourceを自分自身に設定
        self.tvMenuBar.dataSource = self
        // cellクラスをMainMenuBarSubItemCellに設定
        let nib : UINib = UINib.init(nibName: MainMenuBarSubItemCell.className, bundle:nil)
        self.tvMenuBar.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    ///
    /// viewDidAppearイベント処理
    ///　- parameter:animated:true:アニメーションする false:アニメーションしない
    ///
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    ///
    /// viewDidAppearイベント処理
    ///　- parameter:categoryType:カテゴリー形式
    ///
    func changeViewController(_ categoryType: CommonConst.CategoryType) {
        // カテゴリ形式を設定
        TaskInfoUtility.DefaultInstance.SetCategoryType(categoryType: categoryType.rawValue)
        // タスク情報保存
        TaskInfoUtility.DefaultInstance.WriteTaskInfo()
        // 画面を切り替える
        self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
    }
    
    ///
    /// tableView　行の高さ取得処理
    ///　- parameter:tableView:UITableView
    ///　- parameter:indexPath:セルインデックス情報
    ///　- returns:行の高さ取得
    ///
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MainMenuBarSubItemCell.height()
    }
    
    ///
    /// tableView　選択イベント処理
    ///　- parameter:tableView:UITableView
    ///　- parameter:indexPath:選択セルインデックス情報
    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.changeViewController(CommonConst.CategoryType(rawValue: indexPath.row)!)
    }

    ///
    /// tableView　要素数取得処理
    ///　- parameter:tableView:UITableView
    ///　- parameter:section:テーブルの要素数
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommonConst.CategoryType.max.hashValue
    }
    
    ///
    /// tableView　セルの表示処理
    ///　- parameter:tableView:UITableView
    ///　- parameter:indexPath:セルインデックス情報
    ///　- returns:表示するセルのオブジェクト
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // MainMenuBarSubItemCellが取得できた場合
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as Any as? MainMenuBarSubItemCell {
            // セルのデータを設定する
            cell.setData(MainMenuBarSubItemCellData(category: indexPath.row, title: CommonConst.CATEGORY_TYPE_STRING[indexPath.row], values: TaskInfoUtility.DefaultInstance.GetCategoryCount(categoryType: indexPath.row), backgroundColor : CommonConst.CATEGORY_TYPE_BACKGROUND_COLOR[indexPath.row]))
            // 設定したセルオブジェクトを返す
            return cell
        }
        
        // 空のセルオブジェクトを返す
        return MainMenuBarSubItemCell()
    }
    
    ///
    /// tableView　再描画処理
    ///
    open func redraw() {
        self.tvMenuBar.reloadData()
    }
}
