//
//  ITRootViewController.swift
//  ImitationTown
//
//  Created by jiachenmu on 2016/10/21.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//  Rootviewcontroller 根控制器

import UIKit
import SnapKit

class ITRootViewController: ITBaseViewController, UIScrollViewDelegate {

    //主显示容器
    var showScrollView : UIScrollView!
    
    //ViewControllers
    var viewControllers: [ITBaseViewController]!
    
    var homeViewController : ITHomeViewController!
    
    var feedViewController : ITBaseViewController!
    
    var searchViewController: ITSearchViewController!
    
    var messageViewController: ITMessageViewController!
    
    var mineViewController: ITMineViewController!
    
    var postViewController: ITPostViewController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.frame = mainViewFrame
        automaticallyAdjustsScrollViewInsets = false
        
        initShowScrollView()
        
        configureITToolBar()
        
        initViewControllers()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        ITToolBar.share.changeIndicator(contentOffset: showScrollView.contentOffset)
        ITToolBar.share.hidden(false, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: --- Build UI
    func configureITToolBar() -> Swift.Void {
        
        //由于ITToolBar.share.currentIndex 是依据 scrollViewDidEndDecelerating 来改变的，所以可以在switchItem中写刷新页面的方法
        weak var weakSelf = self
        
        ITToolBar.share.switchItem = {(event : ITToolBarEvent) -> () in
            print(event)
            let offSetX = CGFloat(6 - event.rawValue) * SCREEN_WIDTH
            
            weakSelf!.changeChannel(6-event.rawValue)
            
            weakSelf!.showScrollView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
            switch event {
            case .Add:
                
                break
            case .Mine: break
            case .Feed:
                break
            case .Home:
                
                break
                
            default: break
            }
        }
        
    }
    
    func initShowScrollView() -> Swift.Void {
        showScrollView = UIScrollView()
        showScrollView.delegate = self
        showScrollView.isPagingEnabled = true
        showScrollView.bounces = false
        showScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(showScrollView)
        showScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(50)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
        }
        showScrollView.contentSize = CGSize(width: 6 * SCREEN_WIDTH, height: SCREEN_HEIGHT - 50)
    }
    
    func initViewControllers() -> Swift.Void {
        homeViewController = ITHomeViewController()
        feedViewController = ITFeedViewController()
        searchViewController = ITSearchViewController()
        messageViewController = ITMessageViewController()
        mineViewController = ITMineViewController()
        postViewController = ITPostViewController()
        
        viewControllers = [homeViewController, feedViewController, searchViewController, messageViewController, mineViewController, postViewController].flatMap { [unowned self] (controller) -> ITBaseViewController? in
            controller?.nav = self.navigationController
            let view = controller?.view
            self.showScrollView.addSubview(view!)
            // ForchTouch 检测功能要在该view.superview != nil 才会返回正确值，所以放在view已经被添加之后
            controller?.addForceTouch()
            view?.snp.makeConstraints({ (make) in
                make.width.equalToSuperview()
                make.height.equalToSuperview()
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(CGFloat(6 - controller!.controllerType!.rawValue) * SCREEN_WIDTH)
            })
            
            return controller
        }
    }
    
    //MARK: --- UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ITToolBar.share.changeIndicator(contentOffset: scrollView.contentOffset)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let currentIndex = Int(scrollView.contentOffset.x / SCREEN_WIDTH)

        changeChannel(currentIndex)
        
        let tag = 6 - currentIndex
        ITToolBar.share.currentIndex = ITToolBarEvent(rawValue: tag)!
    }
    
    // 手动执行viewWillAppear && viewWillDisappear
    func changeChannel(_ channelCode: Int) {
        if channelCode < viewControllers.count {
            viewControllers[channelCode].viewWillAppear(true)
            if channelCode > 0 {
                viewControllers[channelCode-1].viewWillDisappear(true)
            }
        }

    }
        
}
