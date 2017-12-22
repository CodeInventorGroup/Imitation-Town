//
//  ITWebViewController.swift
//  ImitationTown
//
//  Created by 贾宸穆 on 2017/3/19.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import RxCocoa
import RxSwift

class ITWebViewController: ITBaseViewController {
    
    private var webView: WKWebView?
    
    var url: String?
    
    @IBOutlet weak var navButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buildUI()
        
        loadRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func buildUI() -> Swift.Void {
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.userContentController = WKUserContentController()
        webView = WKWebView.init(frame: .zero, configuration: webViewConfig)
        view.addSubview(webView!)
        webView?.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        webView?.scrollView.contentInset = UIEdgeInsets.init(top: 44, left: 0, bottom: 0, right: 0)
        view.sendSubview(toBack: webView!)
        
        navButton.rx.controlEvent(.touchUpInside).subscribe {  _ in
            _ = self.navigationController?.popViewController(animated: true)
        }.addDisposableTo(disposeBag)
        if let nav = navigationController as? ITNavigationViewController {
            weak var weakSelf = self
            nav.isOnCustomAnimation = true
            nav.swipeAnimation = { offsetX in
                if offsetX <= SCREEN_WIDTH/2 {
                    let rotationAngle = -offsetX * 2 / SCREEN_WIDTH * CGFloat(Double.pi)
                    weakSelf?.navButton.transform = CGAffineTransform(rotationAngle: rotationAngle)
                }
            }
        }
    }

    //MARK: Action
    
        // loadURLRequest
    func loadRequest() {
        if let url = url {
            let request = URLRequest.init(url: URL.init(string: url)!)
            _ = webView?.load(request)
        }
    }
    
}
