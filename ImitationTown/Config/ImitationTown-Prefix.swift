//  ImitationTown-Prefix.swift
//  Copyright © 2016年 ManoBoo. All rights reserved.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  小组网站:https://www.codeinventor.club
//  简书网址:http://www.jianshu.com/c/d705110de6e0
//  项目网址:https://github.com/CodeInventorGroup/Imitation-Town
//  欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问

/*
    注意：该开源项目中的接口仅作为展示，请勿使用
*/

import Foundation
import UIKit

//MARK: Dependencies
import RxCocoa
import RxSwift
import Kingfisher
import SnapKit
import Alamofire
import SVProgressHUD

//MARK: ********************** 我们的信息 ************************
let OurClub       = "https://www.codeinventor.club"
let OurJianShu    = "http://www.jianshu.com/c/d705110de6e0"
let ProjectGithub = "https://github.com/CodeInventorGroup/Imitation-Town"
let ManoBooWeiBo = "http://weibo.com/u/3484140182"  // 木木281
let ManoBooAvatar = "http://upload.jianshu.io/users/upload_avatars/1299512/f7e282fd-2c4b-4589-a622-d96405356d9e.jpg"
let ManoBooJianShu_OPENURL = "jianshu://u3484140182"
let ZRFlowerAvatar = "http://upload-images.jianshu.io/upload_images/1635397-cd1803e6363a6004.jpg"

//MARK: ********************** 调试模式 && 方案采用 **********************

// DebugeMode = true => 打印ViewController 生命周期信息
let DebugMode = false

// RootViewController采用的方案
enum RootViewControllerCase: String {
    case pageViewController = "UIPageViewController"
    case scrollView         = "UIScrollView"
}
let RootViewControllerMode: RootViewControllerCase = .scrollView

let DefaultAnimationInterval: TimeInterval = 0.35

//MARK: ********************** Screen_Size **********************
let KeyWindow : UIWindow = AppDelegate.share().window!
let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.width
let SCREEN_HEIGHT:CGFloat = UIScreen.main.bounds.height
let NAVIGATION_BAR_HEIGHT: CGFloat = 44

//MARK: Color configure
let Color_Main : UIColor = UIColor.hex(hex: 0xFFD700)
//  浅灰色
let kColorGrayLight = UIColor.hexString(hex: "#999999")
//  灰色二级字体
let kColorGraySecond = UIColor.hex(hex: 0xCFCFCF)
//  背景色
let kColorBackgroundGray = UIColor.hexString(hex: "#fafafa")
//  分割线颜色
let kColorSeparateLine = UIColor.hexString(hex: "#eeeeee")

//MARK: Font configure
let kFontSize_13: CGFloat = 13.0
let kFontSize_11: CGFloat = 11.0

let CI_Font_11 = UIFont.systemFont(ofSize: kFontSize_11)
let CI_Font_13 = UIFont.systemFont(ofSize: kFontSize_13)



//MARK: SeparateLineThickness
let kSeparateLineThickness: CGFloat = 0.5

//MARK: CornerRadius
let kCornerRadius_SegentView: CGFloat = 2.0

//MARK: API
let AMapAPIKey = "3dfa1df8de1b9331122e6abdc72cd58e"


// 这是一个悲伤的故事，Augumn这家公司估计是挂了，Amazon上的图片资源均不能访问，官网都挂了，所以为了视觉效果，目前只能写假数据了，sorry😇
extension URL {
    static func itURL(_ url: String?) -> URL{
        // so sad
//        if let urlString = url {
//            return urlString.characters.count > 0 ? URL(string:  Initconfiguration.resCongifure_url_default + "/\(urlString)")! : URL(string: "")!
//        }
//        return URL(string: "")!
        
        // 一张CDN上的照片
        return URL.init(string: "http://upload-images.jianshu.io/upload_images/1299512-71e6137058cbf21d.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240")!
    }
}

// { 目前并未获知 Town api调用具体传递的Token方式 所以以前接口Api暂时无法使用}
// login post 请求 目前可以登录成功，可以拿到accessToken, resfreshToken
let login_URL       = "https://tapi.augmn.cn/api/v4/auth/login"
let accessToken_URL = "https://tapi.augmn.cn/api/v4/auth/accessToken"  //POST
let mineInfo_URL    = "https://tapi.augmn.cn/api/v4/user/me"
    //MARK: ---首页数据
let iconURL       = "https://tapi.augmn.cn/api/v4/region/3/homepage"
let venuebook_URL = "https://tapi.augmn.cn/api/v4/region/3/venuebook?limit=10"
let moment_URL    = "https://tapi.augmn.cn/api/v4/region/3/freshFabulas?limit=10&sorters=createdAt_desc"


//MARK: func - 初始化配置
struct Initconfiguration {
    
    // 资源目录的前缀 包括 图片等的url前缀路径
    static var resConfigure_api = "https://s3.cn-north-1.amazonaws.com.cn/res.augmn.cn/environment/kazzar.json"
    
    // 两个图片服务器都可使用， resConfigure_url_Town 是 Town官方服务器， resconfigure_url_Amazon 是 Town部署在Amazon云上的服务器
    static var resConfigure_url_Town = "http://res.augmn.cn"
    static var resconfigure_url_Amazon = "http://s3.cn-north-1.amazonaws.com.cn/res.augmn.cn"
    
    static var resCongifure_url_default = resconfigure_url_Amazon   // 设置默认资源url为Amazon 因为有CDN加速 所以加载速度较快
    
    //func - 获取资源目录配置
    static func getTownNetworkCongifure() {
        Alamofire.request(resConfigure_api, method: .get, parameters: nil).responseJSON {
            response in
            guard let JSON = response.result.value else { return }
            
            let json = try? JSONSerialization.data(withJSONObject: JSON, options: [])
            let jsonDict = try? JSONSerialization.jsonObject(with: json!, options: .allowFragments) as! [String: Any]
            
            
            if let CNConfigureDict = jsonDict?["CN"] as? Dictionary<String, Any> {
                if let environmentArr = CNConfigureDict["environmentUrl"] {
                    if let environmentUrl = environmentArr as? [String] {
                        if (environmentUrl.first != nil) {
                            resConfigure_api = environmentUrl.first!
                        }
                    }
                }
                
                if let resource_cdnEndpoint = CNConfigureDict["resource-cdnEndpoint"] {
                    resconfigure_url_Amazon = resource_cdnEndpoint as! String
                }
                
                if let resource_endpoint = CNConfigureDict["resource-endpoint"] {
                    resConfigure_url_Town = resource_endpoint as! String
                }
            }else {
                SVProgressHUD.showError(withStatus: "配置获取失败")
            }
        }
    }
    
    static func configureKingfishCache() -> Swift.Void {
        //获取缓存
        let kingfisherCache = KingfisherManager.shared.cache
        //设置最大磁盘缓存为50Mb，默认为无限制
        kingfisherCache.maxDiskCacheSize = UInt(50 * 1024 * 1024)
        kingfisherCache.maxMemoryCost = UInt(20 * 1024 * 1024)
        
        //设置最大缓存时间为1天，默认为1周
        kingfisherCache.maxCachePeriodInSecond = TimeInterval(60 * 60 * 24)
        //计算缓存占用的磁盘大小
        kingfisherCache.calculateDiskCacheSize { (size) in
            print(size/1024/1024)
        }
    }
}


