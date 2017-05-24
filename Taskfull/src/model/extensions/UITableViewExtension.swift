//
//  TableViewExtension.swift
//  Taskfull
//
//  Created by IscIsc on 2017/04/26.
//  Copyright © 2017年 isc. All rights reserved.
//
import UIKit

///
/// UITableView拡張クラス
///
public extension UITableView {
    
    ///
    ///　セルの登録（forCellReuseIdentifier）
    ///　- parameter cellClass:セルのクラス
    ///
    func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    ///
    ///　セルの登録（forCellReuseIdentifier）
    ///　- parameter cellClass:セルのクラス
    ///
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    ///
    ///　セルの登録（forHeaderFooterViewReuseIdentifier）
    ///　- parameter cellClass:セルのクラス
    ///
    func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    ///
    ///　セルの登録（forHeaderFooterViewReuseIdentifier）
    ///　- parameter cellClass:セルのクラス
    ///
    func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
