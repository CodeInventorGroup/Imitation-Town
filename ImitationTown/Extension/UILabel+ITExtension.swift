//
//  UILabel+ITExtension.swift
//  ImitationTown
//
//  Created by NEWWORLD on 2016/10/24.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//

import UIKit

extension UILabel {
    
    class func ci_label(font: UIFont, textColor: UIColor) -> UILabel {
        return UILabel.ci_label(font: font, textColor: textColor, text: nil)
    }
    
    class func ci_label(font: UIFont, textColor: UIColor, text: String?) -> UILabel {
        return UILabel.ci_label(frame: .zero, font: font, textColor: textColor, text: text, textAligment: NSTextAlignment.left)
    }
    
    //MARK: 初始化方法
    class func ci_label(frame: CGRect, font: UIFont, textColor: UIColor, text: String?, textAligment: NSTextAlignment?) -> UILabel {
        let label = UILabel.init(frame: frame)
        label.font = font
        label.textColor = textColor
        label.text = text
        if let aligment = textAligment {
            label.textAlignment = aligment
        }
        return label
    }
}
