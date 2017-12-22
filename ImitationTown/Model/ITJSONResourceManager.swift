//  ITJSONResourceManager.swift
//  ImitationTown

//  Created by CodeInventor Group, 
//  Copyright © 2017年 ManoBoo. All rights reserved.
//  Our site:  https://www.codeinventor.club

//  Function:  JSON资源的获取与解析

import UIKit


public let SourceBundlePath = Bundle.main.path(forResource: "JSONResources", ofType: "bundle")!

public let SourceBundle = Bundle(path: SourceBundlePath)!

// JSONResources's filename
public let Home_venuebook_filename       = "Home_venuebook"
public let Home_iconPage_filename        = "Home_iconPage"
public let Home_freshFabulas_filename    = "Home_freshFabulas"
public let Home_category_coffee_filename = "Home_category_coffee"
public let Home_selectCity_filename      = "Home_selectCity"

public let Home_venue_coffee1_filename  = "Home_venue_coffee1"
public let Home_venue_coffee2_filename  = "Home_venue_coffee2"
public let Home_venue_building_filename = "Home_venue_ building"
public let Home_venue_food_filename     = "Home_venue_food"
public let Home_venue_sanlitun_filename  = "Home_venue_sanlitun"
public let Home_venue_vintage_file      = "Home_venue_vintage"

public let Feed_dashboard = "Feed"

public let Search_HothashTag_filename = "Search_HothashTag"
public let Search_Fabulas_filename = "Search_Fabulas"
public let Search_Venuebook_filename = "Search_Venuebook"
public let Search_Users_filename = "Search_Users"

enum ITJSONResourceManagerError: String, Error {
    case notFindJSONFile = "未找到json资源文件"
    case jsonAnalysisFailed = "json -> Dictionary 失败"
    case dictionaryConvertToJsonFailed = "Dictionary -> Json 失败"
}

class ITJSONResourceManager: NSObject {
    
    static func getJSONResources(from location: String) throws -> Dictionary<String, Any>? {
        guard let jsonFilePath = SourceBundle.path(forResource: location, ofType: "json") else {
            throw ITJSONResourceManagerError.notFindJSONFile
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: jsonFilePath))
        /// json整体转换为字典
        guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any> else {
            throw ITJSONResourceManagerError.jsonAnalysisFailed
        }
        return dict
    }
    
    static func getJSONStringWithJsonObject(from object: Any) throws -> String? {
        /// 字典转换为json
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            throw ITJSONResourceManagerError.dictionaryConvertToJsonFailed
        }
        let jsonString: String = String(data: data, encoding: String.Encoding.utf8)!
        return jsonString
    }
    
    static func getRowsJSONStringFromFilePath(jsonFilePath: String) throws -> String? {
        /// 从文件中获取rows的json数据
        guard let dict = try getJSONResources(from: jsonFilePath) else {
            throw ITJSONResourceManagerError.jsonAnalysisFailed
        }
        
        let result = dict["result"] as! Dictionary<String, Any>
        let rows = result["rows"] as! [Dictionary<String, Any>]
        
        guard let jsonString = try getJSONStringWithJsonObject(from: rows) else {
            throw ITJSONResourceManagerError.dictionaryConvertToJsonFailed
        }
        return jsonString
    }
}
