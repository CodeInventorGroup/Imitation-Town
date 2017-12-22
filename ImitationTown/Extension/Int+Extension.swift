//
//  Int+Extension.swift
//  ImitationTown
//
//  Created by ManoBoo on 17/2/13.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  小组网站:https://www.codeinventor.club
//  简书网址:http://www.jianshu.com/c/d705110de6e0
//  项目网址:https://github.com/CodeInventorGroup/Imitation-Town
//  欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问
//

import Foundation

// 转换时间来源 以 秒 为单位，提前转换即可
// dateFormatter格式为：  "yyyy年MM月dd日 HH:mm:ss"

extension Int {
    // 日期转换
    func toTime(dateFormatter: String) -> String{
        let timeInterval = TimeInterval(self)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        
        
        return formatter.string(from: date)
    }
}

extension Int32 {
    // 日期转换
    func toTime(dateFormatter: String) -> String{
        let timeInterval = TimeInterval(self)
        
        
        let date = Date(timeIntervalSince1970: timeInterval)
        print(date)
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        
        
        return formatter.string(from: date)
    }
}

extension Int64 {
    func toTime(dateFormatter: String) -> String{
        let timeInterval = TimeInterval(self)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        
        
        return formatter.string(from: date)
    }
}
