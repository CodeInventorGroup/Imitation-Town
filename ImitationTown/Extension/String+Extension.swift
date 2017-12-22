//
//  String+Extension.swift
//  ImitationTown
//
//  Created by NEWWORLD on 2017/2/9.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  小组网站:https://www.codeinventor.club
//  简书网址:http://www.jianshu.com/c/d705110de6e0
//  项目网址:https://github.com/CodeInventorGroup/Imitation-Town
//  欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问
//

import Foundation
import UIKit

extension String {
    
    
    /// 计算string的长度
    ///
    /// - Parameters:
    ///   - size: string的最大显示范围
    ///   - font: 字体大小
    /// - Returns: string的width
    func calculateStringWidth(with size: CGSize, font: UIFont) -> CGFloat {
        return self.calculateStringSize(with: size, font: font).width
    }
    
    //MARK: 根据size和font计算string的长度
    func calculateStringSize(with size: CGSize, font: UIFont) -> CGSize {
        return self.calculateStringSize(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
    }
    
    /// 计算string的size，通过设置string的attribute和size
    ///
    /// - Parameters:
    ///   - size: string的最大显示范围
    ///   - attributes: string的NSFontAttributeName和NSMutableParagraphStyle
    /// - Returns: string的size
    func calculateStringSize(with size: CGSize, attributes: [String : Any]? = nil) -> CGSize {
        return self.calculateStringSize(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
    }
    
    //MARK: 计算String的size
    func calculateStringSize(with size: CGSize, options: NSStringDrawingOptions = [], attributes: [String : Any]? = nil, context: NSStringDrawingContext?) -> CGSize {
        return self.boundingRect(with: size, options: options, attributes: attributes, context: context).size
    }
}
