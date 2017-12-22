//
//  UIViewController+Extension.swift
//  ImitationTown
//
//  Created by jiachenmu on 2016/10/18.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//

import UIKit


extension UIViewController {
    
}


extension UIAlertController {
    
    //MARK: 快速构建 UIAlertController  build a `UIAlertController` quickly
    class func alertViewController(with title: String? = nil, message: String? = nil, preferredStyle: UIAlertControllerStyle = .alert, alertActions: [UIAlertAction]? = nil) -> UIAlertController {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: preferredStyle)
        if let alertActions = alertActions {
            for action in alertActions {
                alertVC.addAction(action)
            }
        }
        return alertVC
    }
}

extension UIAlertAction {
    class func ciAction(title: String? = nil, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let action = UIAlertAction.init(title: title, style: style, handler: handler)
        return action
    }
}
