//
//  ITSearchModel.swift
//  ImitationTown
//
//  Created by NEWWORLD on 2016/10/25.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//

import UIKit
import HandyJSON

class ITSearchModel: HandyJSON {
    
    required init() {}
}

class ITSearchUserBaseModel: HandyJSON {
    var id: String?
    var createdAt: String?
    var updatedAt: String?
    var name: String?
    var pitch: String?
    var avatarId: String?
    var profileBackgroundId: String?
    var isConnoisseur: Bool?
    var ambassadorFlag: Int?
    var avatar: AvatarModel?
    var profileBackground: AvatarModel?
    var followerCount: Int?
    var followingCount: Int?
    var fabulasLikedCount: Int?
    var fabulasCreatedCount: Int?
    var venusLikedCount: Int?
    var venusCreatedCount: Int?
    var auditFabulaCount: Int?
    var isInspire: Bool?
    var isFollowing: Bool?
    var isFollower: Bool?
    
    required init() {}
}

/// 故事模型
class ITSearchStoryModel: HandyJSON {
    var id: String?
    var createdAt: String?
    var city: String?
    var fabula: ITHomeCityStroyFabulaModel?
    
    required init() {}
}

/// 地点集模型
class ITSearchVenubookModel: HandyJSON {
    var id : String?
    var createdAt : String?
    var updatedAt : String?
    var venuebookId : String?
    var rank : Int?
    var topFlag : Bool?
    var venuebook : VenuebookModel?
    
    required init() {}
}

/// 人物模型
class ITSearchUserModel: HandyJSON {
    var id: String?
    var createdAt: String?
    var city: String?
    var user: ITSearchUserBaseModel?
    
    required init() {}
}
