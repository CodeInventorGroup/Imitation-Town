//
//  UITableView+CIExtension.swift
//  ImitationTown
//
//  Created by CodeInventor on 17/1/10.
//  Copyright © 2017年 ManoBoo. All rights reserved.

import Foundation
import UIKit



class CITableViewProtocolManager: NSObject, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    deinit {
        print("CITableViewProtocolManager -> deinit")
    }
    
    static let shareInstance = CITableViewProtocolManager()
    
    weak var sourceTableView: UITableView? {
        didSet {
            assert(sourceTableView != nil, "CITableViewProtocolMananger's sourceTableView can't be nil")
            sourceTableView!.dataSource = self
            if #available(iOS 10.0, tvOS 10.0, *) {
                sourceTableView!.prefetchDataSource = self
            } 
//            sourceTableView!.delegate = self
        }
    }
    
  
    //MARK: **************** DataSource ********************************************************
    
    // default's numberOfRowInSection is 0
    public var ci_numberOfRowInSection: ((Int) -> Int) = {(section) in return 0} {
        didSet {
            sourceTableView?.reloadData()
        }
    }
    
    // default's sections is 1
    public var ci_numberOfSections: (() -> Int) = {return 1} {
        didSet{
            sourceTableView?.reloadData()
        }
    }
    
    // default's cell
    public var ci_cellForRow: ((UITableView, IndexPath) -> UITableViewCell) = {(tableView: UITableView, indexpath: IndexPath) in return ITBaseCell()} {
        didSet {
            sourceTableView?.reloadData()
        }
    }
    
    
    //MARK: **************** Delegate ********************************************************
    
    
    // display life cycle
    
    public var cellWillDisplay: ((UITableView, UITableViewCell, IndexPath) -> Void) = {(tableView, cell, indexPath) in}
    
    public var cellWillDisplayHeaderView: ((UITableView, UIView, Int) -> Void) = {(tableView, headerView, section) in}
    
    public var cellWillDisplayFooterView: ((UITableView, UIView, Int) -> Void) = {(tableView, footerView, section) in}
    
    public var cellDidEndDisplaying: ((UITableView, UITableViewCell, IndexPath) -> Void) = {(tableView, cell, indexPath) in}
    
    public var cellDidDisplayingHeaderView: ((UITableView, UIView, Int) -> Void) = {(tableView, headerView, section) in}
    
    public var cellDidEndDisplayingFooterView: ((UITableView, UIView, Int) -> Void) = {(tableView, footerView, section) in}
    
    
    // height style
    
    public var heightForRow: ((UITableView, IndexPath) -> CGFloat) = {(tableView, indexPath) in
        return 44
    }
    
    public var heightForHeaderInSection: ((UITableView, Int) -> CGFloat) = {(tableView, section) in
        return CGFloat.leastNormalMagnitude
    }
    
    public var heightForFooterInSection: ((UITableView, Int) -> CGFloat) = {(tableView, section) in
        return CGFloat.leastNormalMagnitude
    }
    
    
    public var estimatedHeightForRow: ((UITableView, IndexPath) -> CGFloat) = {(tableView, section) in
        return 44
    }
    
    
    public var estimatedHeightForHeaderInSection: ((UITableView, Int) -> CGFloat) = {(tableView, section) in
        return 0
    }
    
    
    public var estimatedHeightForFooterInSection: ((UITableView, Int) -> CGFloat) = {(tableView, section) in
        return 0
    }
    
    
    // header && footer for Section
    
    public var viewForHeaderInSection: ((UITableView, Int) -> UIView?) = {(tableView, section) in
        return UIView()
    }
    
    public var viewForFooterInSection: ((UITableView, Int) -> UIView?) = {(tableView, section) in
        return UIView()
    }
    
    // touch event
    
    public var willSelectRow: ((UITableView, IndexPath) -> IndexPath?) = {(tableView, indexPath) in
        return nil
    }
    
    
    public var willDeselectRow: ((UITableView, IndexPath) -> IndexPath?) = {(tableView, indexPath) in
        return nil
    }
    
    public var didSelectRow: ((UITableView, IndexPath) -> Void) = {(tableView, indexPath) in
        print("didSelectRow")
    }
    
    public var didDeselectRow: ((UITableView, IndexPath) -> Void) = {(tableView, indexPath) in
        print("didDeselectRow")
    }
    
    //  prefetchRowsAt
    public var prefetchRowsAt: ((UITableView, [IndexPath]) -> Void) = {(tableView, indexPaths) in
        
    }
    
    // *******************************************************************************************************************
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.ci_numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ci_numberOfRowInSection(section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return ci_cellForRow(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellWillDisplay(tableView, cell, indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        cellWillDisplayHeaderView(tableView, view, section);
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        cellWillDisplayFooterView(tableView, view, section);
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellDidEndDisplaying(tableView, cell, indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooterInSection(tableView, section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeaderInSection(tableView, section)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       return estimatedHeightForRow(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
       return estimatedHeightForFooterInSection(tableView, section)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
       return estimatedHeightForHeaderInSection(tableView, section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeaderInSection(tableView, section)
    }
  
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForFooterInSection(tableView, section)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return willSelectRow(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return willDeselectRow(tableView, indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselectRow(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        prefetchRowsAt(tableView, indexPaths)
    }

    
    // *******************************************************************************************************************
    
}

// 要使用
class ITBaseCell: UITableViewCell {
    open var indexPath: IndexPath = IndexPath(row: 0, section: 0)
}


extension UITableView{
    
    // 解决点击事件不触发的bug
    private func forawrdTapGesture(_ touches: Set<UITouch>, forawrdSelector: Selector) {
        if let view = touches.first?.view {
            if view.isKind(of: NSClassFromString("UITableViewCellContentView")!)  {
                if view.superview is ITBaseCell {
                    let cell = view.superview as! ITBaseCell
                    if let delegate = delegate {
                        if delegate.responds(to: forawrdSelector) {
                            delegate.perform(forawrdSelector, with: self, with: cell.indexPath)
                        }
                    }
                }
            }
        }
    }
    
    // UITableViewDelegate.tableView(_:willSelectRowAt:)
    open override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        self.forawrdTapGesture(touches, forawrdSelector: #selector(UITableViewDelegate.tableView(_:willSelectRowAt:)))
        return true
    }
    
    // UITableViewDelegate.tableView(_:didSelectRowAt:)
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.forawrdTapGesture(touches, forawrdSelector: #selector(UITableViewDelegate.tableView(_:didSelectRowAt:)))
    }
}


