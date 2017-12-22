//
//  ITHomeCategoryModel.swift
//  ImitationTown
//
//  Created by ManoBoo on 17/2/13.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  小组网站:https://www.codeinventor.club
//  简书网址:http://www.jianshu.com/c/d705110de6e0
//  项目网址:https://github.com/CodeInventorGroup/Imitation-Town
//  欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问
//

import UIKit
import HandyJSON


//MARK: 首页分类icon model
struct ITHomeCategoryModel: HandyJSON {
    var code: String?
    var title: String?
    var icons: ITHomeCategoryICONModel?
    
}

struct ITHomeCategoryICONModel: HandyJSON {
    var blue: String?
    var white: String?
}


//MARK: 分类二级页面model
struct ITHomeCategoryResultModel: HandyJSON {
    var profileBackground: ITCategoryProfileBGModel?
    var cityInfo: ITCityInfoModel?
    var poiSrc: String?
    var shortCut: String?
    var tags: [String]?
    var profileBackgroundId: String?
    var likersCount: Int?
    var latitude: Float64?
    var longitude: Float64?
    var averageCost: Int?
    var name: String?
    var city: String?
    var card: ITCategoryProfileBGModel?
    var createdAt: Int64?
    var alias: String?
    var pitch: String?
    
}

struct ITCategoryProfileBGModel: HandyJSON {
    var color: String?
    var original: String?
    var id: String?
    var createdAt: Int64?
    var thumbnail: String?
    var placeHolder: UIColor? {
        get {
            return configurePlaceHolderColor()
        }
    }
    private func configurePlaceHolderColor() -> UIColor? {
        let colorSet = color?.components(separatedBy: " ")
        if colorSet?.count == 4 {
            guard let colorNum = colorSet?.map({ (colorStr) -> CGFloat in
                return CGFloat(Float(colorStr)!)
            })  else {
                return nil
            }

            if colorNum.count == 4 {
                return UIColor.init(red: colorNum[0], green: colorNum[1], blue: colorNum[2], alpha: colorNum[3])
            }else {
                return nil
            }
        }else {
            return nil
        }
    }
}
