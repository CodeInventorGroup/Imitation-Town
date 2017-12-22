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
