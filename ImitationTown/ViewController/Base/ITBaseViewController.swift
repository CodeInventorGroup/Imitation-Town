//
//  ITBaseViewController.swift
//  ImitationTown
//
//  Created by jiachenmu on 2016/10/18.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import Social

protocol ITBaseViewControllerProtocol {
    
}

extension ITBaseViewControllerProtocol where Self : ITBaseViewController {
    var mainViewFrame : CGRect {
        return CGRect(x: 0.0, y: 50, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 50)
    }
}

enum ShareItem {
    case Default
    case media(String?, UIImage?, URL?)
    case text(String?)
    case image(UIImage?)
    case link(URL?)
}

class ITBaseViewController: UIViewController, ITBaseViewControllerProtocol {
    
    //隐藏状态栏
    override var prefersStatusBarHidden : Bool {
        get {
            return true
        }
    }
    
    var nav: UINavigationController?
    
    var controllerType : ITToolBarEvent?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addForceTouch()
        view.backgroundColor = UIColor.white
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if DebugMode {
            print("\(self.self)__viewWillAppear ")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let nav = nav ?? navigationController,
            nav.viewControllers.count == 1 {
            ITToolBar.share.hidden(false, animated: animated)
        } else {
            ITToolBar.share.hidden(true, animated: animated)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if DebugMode {
            print("\(self.self)__viewWillDisapppear")
        }
        KingfisherManager.shared.cache.clearMemoryCache()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("\(self.self) cache boom!")
    }
    
    //MARK: Deinit
    deinit {
        if DebugMode {
            print("\(self.self) deinit")
        }
    }
    
    //MARK: Action
    func push(to vc: UIViewController, animated: Bool) -> Swift.Void {
        let nav = self.nav ?? self.navigationController
        nav?.pushViewController(vc, animated: animated)
    }
    
    func share(_ item: ShareItem) -> Swift.Void {
        var shareItems: [Any] = []
        switch item {
        case .media(let title, let image, let link):
            guard let imageData = UIImagePNGRepresentation(image!) else {
                print("image not vaild")
                return
            }
            guard let title = title else {
                print("title not vaild")
                return
            }
            guard let link = link else {
                print("link url not vaild")
                return
            }
            shareItems = [title, imageData,link]
            break
        case .image(let image):
            guard let imageData = UIImagePNGRepresentation(image!) else {
                print("image not vaild")
                return
            }
            shareItems = [imageData]
            break
        case .link(let url):
            guard let link = url else {
                print("link url not vaild")
                return
            }
            shareItems = [link]
            break
        case .text(let title):
            guard let title = title else {
                print("title url not vaild")
                return
            }
            shareItems = [title]
            break
        default:
            shareItems = ["ManoBoo 和 NEWWORLD 的iOS开源新作, 欢迎各位朋友指鉴～", UIImagePNGRepresentation(UIImage.init(named: "logo")!)!,URL(string: ProjectGithub)!]
            break
        }
        let shareVC = UIActivityViewController.init(activityItems: shareItems, applicationActivities: nil)
        shareVC.excludedActivityTypes = [.airDrop]
        shareVC.title = "CodeInventor感谢您的分享"
        self.present(shareVC, animated: true, completion: nil)
    }

}


