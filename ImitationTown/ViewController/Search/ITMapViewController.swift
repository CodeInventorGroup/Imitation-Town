//
//  ITMapViewController.swift
//  ImitationTown
//
//  Created by NEWWORLD on 2017/3/17.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  小组网站:https://www.codeinventor.club
//  简书网址:http://www.jianshu.com/c/d705110de6e0
//  项目网址:https://github.com/CodeInventorGroup/Imitation-Town
//  欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问
//

import UIKit
import RxSwift
import RxCocoa

class ITMapViewController: ITBaseViewController, MAMapViewDelegate {

    var addressName: String!
    var pointCoordinate: CLLocationCoordinate2D!
    
    private var mapView: MAMapView!
    private let pointAnnotation = MAPointAnnotation()
    private var mapsAppsView: ITAvailableMapsAppsView?
    private var availableMaps: Array<[String: String]> = [[String: String]]()
    private var userLocationView = ITUserLocationView()
    
    @IBOutlet weak var navBackbutton: UIButton!
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var userLocationButton: UIButton!
    @IBOutlet weak var mapNavigationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addressNameLabel.text = addressName
        
        if let nav = navigationController as? ITNavigationViewController {
            weak var weakSelf = self
            nav.isOnCustomAnimation = true
            nav.swipeAnimation = { offsetX in
                if offsetX <= SCREEN_WIDTH/2 {
                    let rotationAngle = -offsetX * 2 / SCREEN_WIDTH * CGFloat(Double.pi / 2)
                    weakSelf?.navBackbutton.transform = CGAffineTransform(rotationAngle: rotationAngle)
                }
            }
        }
        navBackbutton.rx.controlEvent(.touchUpInside).subscribe { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }.addDisposableTo(disposeBag)
        
        buildMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        ITToolBar.share.hidden(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navBackbutton.transform = CGAffineTransform.identity
        mapView .setCenter(pointCoordinate, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        mapView.addAnnotation(pointAnnotation)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.mapsAppsView?.removeFromSuperview()
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildMapView() {
        mapView = MAMapView(frame: .zero)
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MAUserTrackingMode.follow, animated: true)
        mapView.customizeUserLocationAccuracyCircleRepresentation = true
        mapView.showsScale = false
        mapView.showsCompass = false
        view.addSubview(mapView)
        view.sendSubview(toBack: mapView)
        mapView.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.top.equalToSuperview().offset(NAVIGATION_BAR_HEIGHT)
            make.height.equalTo(SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT)
        }
        
        //  地图标记
        pointAnnotation.coordinate = pointCoordinate
        
        userLocationView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        userLocationView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        userLocationView.iconImage = UIImage(named: "avatar_userprofile")?.handleImage(operations: [CIImageOperation.scale(CGSize(width: 20, height: 20)), CIImageOperation.corner(10)]).0
    }
    
    //MARK: MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        ITLocationManager.shared.coordinate = userLocation.coordinate
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation is MAPointAnnotation || annotation is MAUserLocation {
            let pointReuserIdentifier: String = "kPointReuserIdentifier"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuserIdentifier) as? MAPinAnnotationView
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuserIdentifier)
                annotationView?.canShowCallout = false
                annotationView?.isDraggable = false
                annotationView?.animatesDrop = false
                
                if annotation is MAPointAnnotation {
                    annotationView?.image = UIImage.superimoposeImages(baseImageName: "pin_map_base", surfaceImageName: "venue_map", bestImageName: "pin_map_best")
                }else {
                    annotationView = userLocationView
                }
            }
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        //  选中用户收藏地点，图标发生变化
        if view.annotation is MAPointAnnotation {
            
        }
    }
    
    //MARK: button actions
    
    @IBAction func currentUserLocation(_ sender: Any) {
        //  用户当前位置
        mapView .setCenter(ITLocationManager.shared.coordinate!, animated: true)
        
        userLocationView.rotationIconImage()
    }
    
    @IBAction func handleMapNavigation(_ sender: Any) {
        //  开始导航
        showAvailableMapsAppsView()
    }
    
    //MARK: 获取本机地图可用列表
    private func showAvailableMapsAppsView() {
        if mapsAppsView == nil {
            mapsAppsView = ITAvailableMapsAppsView.availableMapsAppsView(startCoordinate: ITLocationManager.shared.coordinate!, endCoordinate: pointCoordinate, toName: addressName, title: addressName)
            UIApplication.shared.keyWindow?.addSubview(mapsAppsView!)
            mapsAppsView?.snp.makeConstraints({ (make) in
                make.left.right.top.bottom.equalToSuperview()
            })
        }
        mapsAppsView?.showAvailableMapsAppsView()
    }
}
