//
//  ForchTouch+Extension.swift
//  ImitationTown
//
//  Created by ManoBoo on 17/2/22.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  关于 traitCollection.forceTouchCapability 检测结果未知的问题,可以查看:
    /*   http://stackoverflow.com/questions/34318283/forcetouchcapability-returning-nil */

import UIKit

@objc protocol CIForceTouchDelegate: NSObjectProtocol {
    
    // 目标控制器
    var ciForceTouchGoalViewController: ( (UIViewControllerPreviewing, CGPoint) -> UIViewController?) {get}
    
    @objc optional var ciForceTouchCommmitClousure: ( (UIViewController) -> () ) {get}
}

extension UIViewController: UIViewControllerPreviewingDelegate{
    
    // 判断是否支持3DTouch，有则添加 
    // 如果使用 self.traitCollection.forceTouchCapability 来检测可能会发现未知结果
    // ForchTouch 检测功能要在该view.superview != nil 才会返回正确值，所以检测应在view被添加之后,否则会注册失败
    @discardableResult func addForceTouch() -> Bool {
        if UIScreen.main.traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: self.view)
            return true
        }
        return false;
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let mySelf = self as? CIForceTouchDelegate {
            return mySelf.ciForceTouchGoalViewController(previewingContext, location)
        }
        return nil
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if let mySelf = self as? CIForceTouchDelegate {
            mySelf.ciForceTouchCommmitClousure?(viewControllerToCommit)
        }
    }
    
}
