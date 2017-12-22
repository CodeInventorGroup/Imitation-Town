//
//  ITBaseModel.swift
//  ImitationTown
//
//  Created by jiachenmu on 2016/10/25.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//  基础Model

import UIKit
import HandyJSON

@objc public protocol CMJsonProtocol {
    
    static func customClassMapping() -> [String : String]?
}



//MARK: 系统自带的class 和 一些配置方法
class BasicFoundation {
    static let BasicSet = NSSet(array: [URL.self,
                                        Date.self,
                                        NSValue.self,
                                        Data.self,
                                        NSError.self,
                                        NSArray.self,
                                        NSDictionary.self,
                                        NSString.self,
                                        NSAttributedString.self])
    
    class func isBasicClass(anyClass c : AnyClass) -> Bool {
        var isBasicClass = false
        
        if c == NSObject.self {
            isBasicClass = true
        }else {
            BasicSet.enumerateObjects({ (basicClass, stop) in
                if c.isSubclass(of: basicClass as! AnyClass) {
                    isBasicClass = true
                    stop.initialize(to: true)
                }
            })
            
        }
        
        return isBasicClass
    }
    
    static let  bundlePath = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
    
    //获取自定义的类名
    class func getClassName(customClass c : String) -> String? {
        var cClass = c
        
        //不是自定义类
        if !cClass.contains(bundlePath) {
            return nil
        }
        
        cClass = cClass.components(separatedBy: "\"")[1]
        if let range = cClass.range(of: bundlePath) {
            cClass = cClass.substring(to: range.upperBound)
            var numStr = ""
            for c : Character in cClass.characters {
                if c <= "9" && c >= "0" {
                    numStr += String(c)
                }
            }
            if let numrange = cClass.range(of: numStr) {
                cClass = cClass.substring(from: numrange.upperBound)
            }
            return bundlePath + "." + cClass
        }
        
        return nil;
    }
}

extension NSObject {
    
    class func object(JSONString str : String) -> AnyObject? {
        //先判断时候可以转换
        if !JSONSerialization.isValidJSONObject(str) {
            assert(true, "不是有效的json源")
        }
        let data : Data! = str.data(using: String.Encoding.utf8)
        let dict = ( try! JSONSerialization.jsonObject(with: data!, options:.allowFragments) ) as! NSDictionary
        return self.self.object(jsonDict: dict)
    }
    
    //字典转模型
    class func object(jsonDict dict : NSDictionary) -> AnyObject? {
        //判断是否系统自带的class
        if BasicFoundation.isBasicClass(anyClass: self) {
            assert(true, "自定义类才可以转模型")
            return nil
        }
        
        let obj : AnyObject = self.init()
        var cls : AnyClass = self.self
        while ( "\(cls)" != "NSObject") {
            var count : UInt32 = 0
            let properties = class_copyPropertyList(cls, &count)
            for i in 0..<count {
                let property = properties?[Int(i)]
                let propertyself = String(cString: property_getAttributes(property))
                let propertyKey = String(cString: property_getName(property))
                if propertyKey == "description" {
                    continue
                }
                
                //取得字典中对应的内容
                let value1:AnyObject? = dict[propertyKey] as AnyObject
                
                guard var value = value1 else {
                    continue
                }
                
                
                
                let valueself = "\(value.classForCoder)"
                if valueself == "NSDictionary" {
                    let subModelStr : String! = BasicFoundation.getClassName(customClass: propertyself)
                    if subModelStr == nil {
                        assert(true, "定义的模型与字典不匹配")
                    }
                    if let subModelClass = NSClassFromString(subModelStr) {
                        value = subModelClass.object(jsonDict: value as! NSDictionary)!
                    }
                }else if valueself == "NSArray" {

                    if self.responds(to: Selector("customClassMapping")) {
                        
                        if var subModelClass_Name = self.classForCoder().customClassMapping()?[propertyKey] {
                            subModelClass_Name = BasicFoundation.bundlePath + "." + subModelClass_Name
                            if let subModelClass = NSClassFromString(subModelClass_Name) {
                                value = subModelClass.object(sourceArray: value as! NSArray)!
                            }
                        }
                    }
                }
                obj.setValue(value, forKey: propertyKey)
            }
            free(properties)
            cls = cls.superclass()!
        }
        return obj
    }
    
    class func object(sourceArray array : NSArray) -> NSArray? {
        if array.count == 0 {
            return nil
        }
        var data = [AnyObject]()
        for item in array {
            let `self` = "\((item as AnyObject).classForCoder)"
            if self == "NSDictionary" {
                if let model = object(jsonDict: item as! NSDictionary) {
                    data.append(model)
                }
            }else if self == "NSArray" {
                if let model = object(sourceArray: item as! NSArray) {
                    data.append(model)
                }
            }else {
                data.append(item as AnyObject)
            }
        }
        if  data.count == 0 {
            return nil
        }else {
            return data as NSArray?
        }
    }
}

extension NSArray {
    func exchange(replaceObject obj : AnyObject, index i : Int) -> NSArray {
        let tempArr = NSMutableArray(array: self)
        tempArr.replaceObject(at: i, with: obj)
        return tempArr as NSArray
    }
}



//MARK: ********************************************************************************************

class ITBaseModel: HandyJSON {
    
    required init() {}
}


struct CoverModel: HandyJSON {

    var value : Int?

}

struct CreatorModel: HandyJSON {

    var id : String?
    var createdAt : Int64?
    var updatedAt : Int64?
    var name : String?
    var pitch : String?
    var avatarId : String?
    var profoleBackgroundId : String?
    var isConnoisseur : Bool?
    var ambassadorFlag : Bool?
    var avatar : AvatarModel?
    var profileBackground : AvatarModel?
}

//ImageModel

struct AvatarModel: HandyJSON {
    var id : String?
    var color : String?
    var createdAt : String?
    var thumbnail : String?
    var original : String?
    
}
