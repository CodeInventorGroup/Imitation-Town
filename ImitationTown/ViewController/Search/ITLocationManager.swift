//
//  ITLocationManager.swift
//  ImitationTown
//
//  Created by NEWWORLD on 2017/3/22.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  小组网站:https://www.codeinventor.club
//  简书网址:http://www.jianshu.com/c/d705110de6e0
//  项目网址:https://github.com/CodeInventorGroup/Imitation-Town
//  欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问
//

import UIKit

/// 定位(Singleton)
private let locationManager = ITLocationManager()

class ITLocationManager: NSObject, AMapLocationManagerDelegate {
    
    class var shared: ITLocationManager {
        locationManager.configSingleLocationManager()
        return locationManager
    }
    
    let kDefaultLocationTimeout = 6
    let kDefaultReGeocodeTimeout = 3
    
    var locationCompletionBlock: AMapLocatingCompletionBlock!
    lazy var userLocationManager = AMapLocationManager()
    
    /// 坐标信息
    var coordinate: CLLocationCoordinate2D?
    
    /// 定位信息
    var location: CLLocation? {
        
        didSet {
            if let location = location {
                coordinate = location.coordinate
            }
        }
    }
    
    /// 格式化地址
    var formattedAddress: String?
    /// 国家
    var country: String?
    /// 省/直辖市
    var province: String?
    /// 市
    var city: String?
    /// 区 
    var district: String?
    /// 街道名称
    var street: String?
    /// 门牌号
    var number: String?
    /// 兴趣点名称
    var POIName: String?
    /// 所属兴趣点名称
    var AOIName: String?
    /// 城市编码
    var citycode: String?
    /// 区域编码
    var adcode: String?
    
    /// 逆地理信息
    var regeocode: AMapLocationReGeocode? {
    
        didSet {
            if let regocode = regeocode {
                formattedAddress = regocode.formattedAddress
                country = regocode.country
                province = regocode.province
                city = regocode.city
                district = regocode.district
                street = regocode.street
                number = regocode.number
                POIName = regocode.poiName
                AOIName = regocode.aoiName
                citycode = regocode.citycode
                adcode = regocode.adcode
            }
        }
    }
    
    /// 配置一次定位
    private func configSingleLocationManager() {
        userLocationManager.delegate = self
        userLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        userLocationManager.pausesLocationUpdatesAutomatically = false
        userLocationManager.allowsBackgroundLocationUpdates = true
        userLocationManager.locationTimeout = kDefaultLocationTimeout
        userLocationManager.reGeocodeTimeout = kDefaultReGeocodeTimeout
        
        weak var weakSelf = self
        
        locationCompletionBlock = { (location: CLLocation?, regeocode: AMapLocationReGeocode?, error: Error?) in
            //根据定位信息，添加annotation
            if let location = location {
                weakSelf?.location = location
            }
            if let regeocode = regeocode {
                weakSelf?.regeocode = regeocode
            }
            
            weakSelf?.userLocationManager.stopUpdatingLocation()
        }
    }
    
    /// 逆地理定位
    func reGeocodeLocation() {
        userLocationManager.requestLocation(withReGeocode: true, completionBlock: locationCompletionBlock)
    }
    
    
    /// 获取本地可用地图app列表
    ///
    /// - Parameters:
    ///   - startCoordinate: 导航起点坐标
    ///   - endCoordinate: 导航终点坐标
    ///   - toName: 导航目的地名称
    /// - Returns: app列表数据
    func getAailableMapsApps(startCoordinate: CLLocationCoordinate2D, endCoordinate: CLLocationCoordinate2D, toName: String) -> Array<[String: String]> {
        var availableMaps: [[String: String]] = [[String: String]]()
        
        if UIApplication.shared.canOpenURL(URL(string: "baidumap://map/")!) {
            let urlString = "baidumap://map/direction?origin=latlng:\(startCoordinate.latitude),\(startCoordinate.longitude)|name:我的位置&destination=latlng:\(endCoordinate.latitude),\(endCoordinate.longitude)|name:\(toName)&mode=driving"
            let dic = ["name": "百度地图", "url": urlString]
            availableMaps.append(dic)
        }
        
        if UIApplication.shared.canOpenURL(URL(string: "iosamap://")!) {
            let urlString = "iosamap://path?sourceApplication=云华时代%@&sid=BGVIS1&slat=\(startCoordinate.latitude)&slon=\(startCoordinate.longitude)&sname=当前位置&did=BGVIS2&dlat=\(endCoordinate.latitude)&dlon=\(endCoordinate.longitude)&dname=\(toName)&dev=0&m=0&t=0"
            let dic = ["name": "高德地图", "url": urlString]
            availableMaps.append(dic)
        }
        
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            let urlString = "comgooglemaps://?saddr=&daddr=\(endCoordinate.latitude),\(endCoordinate.longitude)¢er=\(startCoordinate.latitude),\(startCoordinate.longitude)&directionsmode=driving"
            let dic = ["name": "Google Maps", "url": urlString]
            availableMaps.append(dic)
        }
        
        return availableMaps
    }
}
