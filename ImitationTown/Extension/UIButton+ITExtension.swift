//
//  UIButton+ITExtension.swift
//  ImitationTown
//
//  Created by NEWWORLD on 2016/10/24.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//

import UIKit

extension UIButton {

    class func ci_button(frame: CGRect, title: String?, titleColor: UIColor?, font: UIFont, backgroundColor: UIColor?) -> UIButton {
        let button = UIButton.init(frame: frame)
        button .setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = font
        button.backgroundColor = backgroundColor
        return button
    }
}


private var controlHandlerKey: Int8 = 0

extension UIControl {
    public func addHandler(for controlEvents: UIControlEvents, handler: @escaping (UIControl) -> Void) {
        if let oldTarget = objc_getAssociatedObject(self, &controlHandlerKey) as? CIComponentKitTarget<UIControl> {
            self.removeTarget(oldTarget, action: #selector(oldTarget.sendNext), for: controlEvents)
        }
        
        let target = CIComponentKitTarget<UIControl>(handler)
        objc_setAssociatedObject(self, &controlHandlerKey, target, .OBJC_ASSOCIATION_RETAIN)
        self.addTarget(target, action: #selector(target.sendNext), for: controlEvents)
    }
}

internal final class CIComponentKitTarget<Value>: NSObject {
    private let action: (Value) -> Void
    
    internal init(_ action: @escaping (Value) -> Void) {
        self.action = action
    }
    
    @objc
    internal func sendNext(_ receiver: Any?) {
        if let receiver = receiver as? Value {
            action(receiver)
        }
    }
}
