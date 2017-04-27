//
//  MainMenuBarViewController.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/26.
//  Copyright © 2017年 isc. All rights reserved.
//


import UIKit

protocol MainMenuBarProtocol : class {
    func changeViewController(_ menu: CommonConst.CategoryType)
}

class MainMenuBarViewController : UIViewController, MainMenuBarProtocol, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tvMenuBar: UITableView!
    var mainViewController: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func changeViewController(_ categoryType: CommonConst.CategoryType) {
        switch categoryType {
        case .task:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
            break
            
        default:
            break
        }
    }
    
    // 行の高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MainMenuBarSubItemCell.height()
    }
    
    // 選択イベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.changeViewController(CommonConst.CategoryType(rawValue: indexPath.row)!)
    }

    // 要素数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommonConst.CategoryType.max.hashValue
    }
    
    // セルの追加
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as Any as? MainMenuBarSubItemCell {
            // 後で設定する
            cell.setData(MainMenuBarSubItemCellData(category: indexPath.row, title: CommonConst.CATEGORY_TYPE_STRING[indexPath.row], values: 0, backgroundColor : CommonConst.CATEGORY_TYPE_BACKGROUND_COLOR[indexPath.row]))
            return cell
        }
        return UITableViewCell()
    }
}
