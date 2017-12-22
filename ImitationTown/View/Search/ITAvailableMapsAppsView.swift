//
//  ITAvailableMapsAppsView.swift
//  ImitationTown
//
//  Created by NEWWORLD on 2017/3/24.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  小组网站:https://www.codeinventor.club
//  简书网址:http://www.jianshu.com/c/d705110de6e0
//  项目网址:https://github.com/CodeInventorGroup/Imitation-Town
//  欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问
//

import UIKit
import RxSwift
import MapKit

class ITAvailableMapsAppsView: UIView {
    
    private let kLeftMargin: Float = 50
    private let kSingleMapsAppsHeight: Float = 50
    private var mapsAppsContainerViewHeight: Float = 0.0
    
    private let disposeBag = DisposeBag()
    
    private var mapsAppsContainerView: UIView!
    private var backgroundView: UIView!
    private var availableMapsApps: [[String: String]] = Array<[String: String]>()
    
    var clickEvent:((String) -> ())?
    
    class func availableMapsAppsView(startCoordinate: CLLocationCoordinate2D, endCoordinate: CLLocationCoordinate2D, toName: String, title: String) -> ITAvailableMapsAppsView {
        
        let mapsAppsView = ITAvailableMapsAppsView(frame: .zero)
        mapsAppsView.availableMapsApps = ITLocationManager.shared.getAailableMapsApps(startCoordinate: startCoordinate
            , endCoordinate: endCoordinate, toName: toName)
        mapsAppsView.buildAvailableMapsAppsView(startCoordinate: startCoordinate, endCoordinate: endCoordinate, toName: toName, title: title)
        mapsAppsView.isHidden = true
        return mapsAppsView
    }
    
    /// 搭建可用地图apps列表视图
    private func buildAvailableMapsAppsView(startCoordinate: CLLocationCoordinate2D, endCoordinate: CLLocationCoordinate2D, toName: String, title: String) {
        
        backgroundView = UIView(frame: .zero)
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.8
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        weak var weakSelf = self
        self.tap { ( _ , _ ) in
            weakSelf?.hideAvailableMapsAppsView()
        }
        
        mapsAppsContainerViewHeight = kSingleMapsAppsHeight * (Float)(availableMapsApps.count + 2)
        
        mapsAppsContainerView = UIView(frame: .zero)
        mapsAppsContainerView.backgroundColor = UIColor.white
        mapsAppsContainerView.layer.cornerRadius = 3
        mapsAppsContainerView.layer.masksToBounds = true
        addSubview(mapsAppsContainerView)
        mapsAppsContainerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(SCREEN_HEIGHT)
            make.height.equalTo(mapsAppsContainerViewHeight)
        }
        
        //  标题
        let titleLabel = UILabel.ci_label(font: CI_Font_11, textColor: kColorGrayLight, text: "导航 \(title)")
        mapsAppsContainerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(kLeftMargin)
            make.top.equalToSuperview()
            make.height.equalTo(kSingleMapsAppsHeight)
        }
        
        for item in 0...availableMapsApps.count {
            
            let mapsAppsButton = UIButton.ci_button(frame: .zero, title: item == 0 ? "苹果地图" : self.availableMapsApps[item-1]["name"], titleColor: UIColor.black, font: CI_Font_13, backgroundColor: UIColor.white)
            mapsAppsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            mapsAppsButton.titleEdgeInsets = UIEdgeInsetsMake(0, CGFloat(kLeftMargin), 0, 0)
            mapsAppsButton.rx.tap.subscribe({ ( _ ) in
                if item == 0 {
                    let endPlaceMark = MKPlacemark(coordinate: endCoordinate)
                    let endItem = MKMapItem(placemark: endPlaceMark)
                    endItem.name = toName
                    
                    endItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: NSNumber.init(value: true)])
                }else {
                    let mapDic = weakSelf?.availableMapsApps[item-1]
                    var urlString = mapDic?["url"]
                    urlString = urlString?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                    let url: URL = URL(string: urlString!)!
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                weakSelf?.hideAvailableMapsAppsView()
            }).addDisposableTo(disposeBag)
            mapsAppsContainerView.addSubview(mapsAppsButton)
            mapsAppsButton.snp.makeConstraints({ (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(Float(item + 1) * kSingleMapsAppsHeight)
                make.height.equalTo(kSingleMapsAppsHeight)
            })
            
            let lineView = UIView(frame: .zero)
            lineView.backgroundColor = kColorSeparateLine
            mapsAppsContainerView.addSubview(lineView)
            lineView.snp.makeConstraints({ (make) in
                make.left.equalTo(kLeftMargin)
                make.right.equalToSuperview()
                make.top.equalTo(kSingleMapsAppsHeight * Float(item + 1))
                make.height.equalTo(kSeparateLineThickness)
            })
        }
    }
    
    /// 展示可用地图apps列表
    func showAvailableMapsAppsView() {
        if self.isHidden {
            UIView.animate(withDuration: 0.3, animations: {
                self.isHidden = false
                UIView.animate(withDuration: 0.25, animations: {
                    self.mapsAppsContainerView.snp.updateConstraints { (make) in
                        make.top.equalTo(Float(SCREEN_HEIGHT) - self.mapsAppsContainerViewHeight - 5 - 1)
                    }
                    self.layoutIfNeeded()
                }, completion: { (result) in
                    if result == true {
                        self.mapsAppsContainerView.snp.updateConstraints { (make) in
                            make.top.equalTo(Float(SCREEN_HEIGHT) - self.mapsAppsContainerViewHeight - 5)
                        }
                        self.layoutIfNeeded()
                    }
                })
            })
        }
    }
    
    /// 隐藏可用地图apps列表
    func hideAvailableMapsAppsView() {
        if !self.isHidden {
            UIView.animate(withDuration: 1, animations: {
                self.mapsAppsContainerView.snp.updateConstraints { (make) in
                    make.top.equalTo(SCREEN_HEIGHT)
                }
                self.layoutIfNeeded()
                self.isHidden = true
            })
        }
    }
}
