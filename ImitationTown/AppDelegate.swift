//
//  AppDelegate.swift
//  ImitationTown
//
//  Created by jiachenmu on 2016/10/17.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//

import UIKit
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        window!.rootViewController = ITLoadingViewController()
        
        AMapServices.shared().apiKey = AMapAPIKey
        AMapServices.shared().enableHTTPS = true
        ITLocationManager.shared.reGeocodeLocation()
        
        // 服务器配置获取
        Initconfiguration.getTownNetworkCongifure()
        // 配置kingfish的cache参数
        Initconfiguration.configureKingfishCache()
        
        // CIImageCache 设置缓存大小限制
        CIImageCache.default.maxMemoryCost = UInt(50 * 1024 * 1024)
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {
    
    class func share() -> AppDelegate {
        let appdelegate = UIApplication.shared.delegate! as! AppDelegate
        return appdelegate
    }
    
    // 启动页切换到首页
    func switchRootViewController() -> Swift.Void {
        if RootViewControllerMode == .pageViewController {
            window!.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }else {
            window!.rootViewController = ITNavigationViewController(rootViewController: ITRootViewController())
        }
        window!.addSubview(ITToolBar.share)
        ITToolBar.share.snp.makeConstraints{ (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        ITToolBar.share.currentIndex = .Home
    }
}

