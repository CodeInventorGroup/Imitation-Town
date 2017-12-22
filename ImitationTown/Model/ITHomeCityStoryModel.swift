//
//  ITHomeCityStoryModel.swift
//  ImitationTown
//
//  Created by ManoBoo on 17/2/8.
//  Copyright © 2017年 ManoBoo. All rights reserved.
// 项目地址： https://github.com/CodeInventorGroup/Imitation-Town
// 小组网站： https://www.codeinventor.club
//    简书： http://www.jianshu.com/c/d705110de6e0
// 欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问
//

import UIKit
import HandyJSON

struct ITHomeCityStoryModel: HandyJSON {
    var id: String?
    var regionId: String?
    var fabula: ITHomeCityStroyFabulaModel?
}


struct ITHomeCityStroyFabulaModel: HandyJSON {
    var id: String?
    var createdAt: Int64?
    var updatedAt: Int64?
    var privacy: Int?
    var status: String?
    var venueId: String?
    var createdId: String?
    var timeHappened: Int64?
    var pages: [ITHomeCityStoryPageModel]?
    var creator: ITHomeCityStoryCreatorModel?
    var venue: ITHomeCityStoryVenueModel?
    var likersCount: Int?
    var commentsCount: Int?
    var isInspire: Bool?
    var isLike: Bool?
    var readTimes: Int?
    var fmtReadTimes: String?
}


//*********************************************************************

struct ITHomeCityStoryPageModel: HandyJSON {
    var pageNo: Int?
    var type: Int?
    var imageIds: [Int]?
    var text: [String]?
    var images: [AvatarModel]?
    
    //  暂时不用，不需要校验hash value
//    var hashtags: [Int]?
}

struct ITHomeCityStoryCreatorModel: HandyJSON {
    var id: String?
    var createdAt: Int64?
    var updatedAt: Int64?
    var displayName: String?
    var name: String?
    var pitch: String?
    var avatarId: String?
    var profileBackgroundId: String?
    var isConnoisseur: Bool?
    var ambassadorFlag: Int?
    var avatar: AvatarModel?
}

struct ITHomeCityStoryVenueModel: HandyJSON {
    var id: String?
    var createdAt: Int64?
    var updatedAt: Int64?
    var name: String?
    var alias: String?
    var address: String?
    var longitude: Float64?
    var latitude: Float64?
    var gcjLongitude: Float64?
    var gcjLatitude: Float64?
    var coordinateType: Int?
    var profileBackgroundId: String?
    var cardId: String?
    var pitch: String?
    var phone: String?
    var openTimeDesc: String?
    var averageCost: Int?
    var shortCut: String?
    var status: Int?
    var closeReason: String?
    var creatorId: String?
    var city: String?
    var categories: [String]?
    var tags: [String]?
    var distance: Int?
    var poiSrc: String?
    var poiID: String?
    var cityInfo: ITCityInfoModel?
}


struct ITCityInfoModel: HandyJSON {
    var id: String?
    var code: String?
    var name: String?
    var isAbroad: Bool?
    var priority: Int?
    var longitude: Float64?
    var latitude: Float64?
    var countryCode: String?
    var continentCode: String?
    var timezone: String?
    var rawOffset: Int?
    var geoSrc: String?
}

