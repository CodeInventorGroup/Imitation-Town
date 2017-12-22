//
//  ITHomeVenuebookModel.swift
//  ImitationTown
//
//  Created by jiachenmu on 2016/10/25.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//  首页 Venuebook数据

import UIKit
import HandyJSON

struct ITHomeVenuebookModel: HandyJSON {
    var id : String?
    var createdAt : Int?
    var updatedAt : Int?
    var regionId : String?
    var venuebookId : String?
    var rank : Int?
    var topFlag : Bool?
    var venuebook : VenuebookModel?
}

// 地点集
struct VenuebookModel: HandyJSON {
    var id : String?
    var createdAt : Int?
    var updatedAt : Int?
    var name : String?
    var pitch : String?
    var creatorId : String?
    var isPrivate : Bool?
    var cover : [CoverModel]?
    var likersCount : Int?
    var commentsCount : Int?
    var venueCount : Int?
    var isLiked : Bool?
    var isInspire : Bool?
    var creator : CreatorModel?
    var coverInfo : [AvatarModel]?
}


struct VenuebookDetailModel: HandyJSON {
    var venuebookId: String?
    var id: String?
    var explanation: String?
    var createdAt: Int32?
    var updatedAt: Int32?
    var venueId: String?
    var rank: Int?
    var venue: ITHomeCategoryResultModel?
}

//MARK:  SelectCity
struct RegionModel: HandyJSON {
    var name: String?
    var continentCode: String?
    var countryName: String?
    var priority: Int?
    var latitude: Float32?
    var longitude: Float32?
    var rawOffset: Int?
    var id: String?
    var code: String?
    var timezone: String?
    var countryCode: String?
    var isAbroad: Bool?
}

struct CountryModel: HandyJSON {
    var name: String?
    var continentCode: String?
    var code: String?
    var priority: Int?
}
