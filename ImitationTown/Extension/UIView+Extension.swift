//
//  UIView+Extension.swift
//  ImitationTown
//
//  Created by NEWWORLD on 2017/2/9.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  小组网站:https://www.codeinventor.club
//  简书网址:http://www.jianshu.com/c/d705110de6e0
//  项目网址:https://github.com/CodeInventorGroup/Imitation-Town
//  欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问
//

import UIKit

private var TapControlKey: Void?

extension UIView {
    public typealias TapHandler = ( (Int, UIView) -> () )
    
    func setTapClousure(_ tapClousure: TapHandler) -> Swift.Void {
        objc_setAssociatedObject(self, &TapControlKey, tapClousure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    func tapClousure() -> TapHandler? {
        return objc_getAssociatedObject(self, &TapControlKey) as? TapHandler
    }
    
    
    // 添加点击手势
    func tap(_ clickClousure : @escaping TapHandler) -> Swift.Void {
        // save clickEvent
        setTapClousure(clickClousure)
        isUserInteractionEnabled = true
        
        let control = UIControl()
        control.backgroundColor = UIColor.clear
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(tapControlClickEvent), for: .touchUpInside)
        addSubview(control)
        let layoutDict = ["control": control]
        let layoutConstraintH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[control]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: layoutDict)
        let layoutConstraintV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[control]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: layoutDict)
        addConstraints(layoutConstraintH)
        addConstraints(layoutConstraintV)
    }
    
    func tapControlClickEvent() -> Swift.Void {
        if let clousure = tapClousure() {
            clousure(tag, self)
        }
    }

    /// 分割线
    ///
    /// - Parameter color: 分割线颜色
    class func ci_separatorLine(color: UIColor) -> UIView {
        let separatorLine = UIView(frame: .zero)
        separatorLine.backgroundColor = color
        return separatorLine
    }
}



