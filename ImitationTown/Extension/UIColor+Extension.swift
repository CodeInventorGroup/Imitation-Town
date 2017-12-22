//
//  UIColor+Extension.swift
//  ImitationTown
//
//  Created by jiachenmu on 2016/10/20.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//

import UIKit


extension UIColor {
    
    //MARK: RGB Color
   class func ci_rgb(red : Int, green : Int, blue : Int) -> UIColor {
        return UIColor.ci_rgb(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    class func ci_rgb(red : Int, green : Int, blue : Int, alpha : CGFloat) -> UIColor {
        assert(red >= 0 && red <= 255, "red输入无效")
        assert(green >= 0 && green <= 255, "green输入无效")
        assert(blue >= 0 && blue <= 255, "blue输入无效")
        
        return UIColor(red : CGFloat(red) / 255.0, green : CGFloat(green) / 255.0, blue : CGFloat(red) / 255.0, alpha: alpha)
    }
    
    class func ci_sRgb(red: Int, green: Int, blue: Int) -> UIColor {
        return UIColor.ci_sRgb(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    class func ci_sRgb(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        assert(red >= 0 && red <= 255, "red输入无效")
        assert(green >= 0 && green <= 255, "green输入无效")
        assert(blue >= 0 && blue <= 255, "blue输入无效")
        
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
        } else {
            // Fallback on earlier versions
            return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
        }
    }
    
    //MARK: Hex Color
    class func hex(hex : UInt32) -> UIColor {
        return UIColor.hex(hex: hex, alpha: 1.0)
    }
    
    class func hex(hex : UInt32, alpha : CGFloat) -> UIColor {
        return UIColor(red:CGFloat((hex & 0xFF0000) >> 16) / 255.0, green: CGFloat((hex & 0x00FF00) >> 8) / 255.0, blue: CGFloat(hex & 0x0000FF) / 255.0, alpha: alpha)
    }
    
    class func hexString(hex : String) -> UIColor {
        return UIColor.hexString(hex: hex, alpha: 1.0)
    }
    
    class func hexString(hex : String, alpha : CGFloat) -> UIColor {
        var cString : String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.characters.count != 6 {
            //输入错误时 默认返回白色
            return UIColor.white
        }
        
        var rgbValue : UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(red:CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}

extension UIFont {
    class func ITEngFont(size : CGFloat) -> UIFont {
        return  UIFont(name: "DINPro-CondBold", size: size)!
    }
}

extension CGFloat {
    
    var maxCGFloatValue : CGFloat {
        get {
            return CGFloat(Int(self))
        }
    }
}
