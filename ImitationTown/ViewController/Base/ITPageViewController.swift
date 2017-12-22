//
//  ITPageViewController.swift
//  ImitationTown
//
//  Created by ManoBoo on 17/2/28.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//

import UIKit
import RxSwift

class ITPageViewController: ITBaseViewController, UIPageViewControllerDelegate,UIPageViewControllerDataSource, UIScrollViewDelegate {
    
    var pageViewController: UIPageViewController!
    
    var currentIndex: Int = 0
    
    var isAnimationCompleted = false
    
    //ViewControllers
    var viewControllers: [ITBaseViewController]!
    
    var homeViewController : ITHomeViewController!
    
    var feedViewController : ITFeedViewController!
    
    var searchViewController: ITSearchViewController!
    
    var messageViewController: ITMessageViewController!
    
    var mineViewController: ITMineViewController!
    
    var postStoryViewController: ITPostViewController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initViewControllers()
        
        setupPageViewController()
        
        configureITToolBar()
        
        ITToolBar.share.changeIndicator(contentOffset: .zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: init ViewControllers
    func initViewControllers() -> Swift.Void {
        homeViewController = ITHomeViewController()
        feedViewController = ITFeedViewController()
        searchViewController = ITSearchViewController()
        messageViewController = ITMessageViewController()
        mineViewController = ITMineViewController()
        postStoryViewController = ITPostViewController()
        
        viewControllers = [homeViewController,
                           feedViewController,
                           searchViewController,
                           messageViewController,
                           mineViewController,
                           postStoryViewController]
    }
    
    //MARK: setup PageViewController
    func setupPageViewController() -> Swift.Void {
        pageViewController = childViewControllers.first as! UIPageViewController
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([homeViewController], direction: .forward, animated: true, completion: nil)
        pageViewController.configureDelegate()
        
        /*
 
        for v in pageViewController.view.subviews {
            if v is UIScrollView {
                let scrollView = v as! UIScrollView
                scrollView.rx.observe(CGPoint.self, "contentOffset").subscribe({ [unowned self] (event) in
                  
                    if let offset = event.element??.x {
                        print("offSet: \(offset)")
                        if offset < SCREEN_WIDTH {
                            let currentOffset = CGFloat(self.currentIndex) * SCREEN_WIDTH - offset
                            ITToolBar.share.changeIndicator(contentOffset: CGPoint(x: currentOffset, y: 0))
                        }else if offset > SCREEN_WIDTH {
                            // 向右
                            print("currentIndex: \(self.currentIndex)")
                            
                            let currentOffset = CGFloat(self.currentIndex) * SCREEN_WIDTH + offset - SCREEN_WIDTH
                            ITToolBar.share.changeIndicator(contentOffset: CGPoint(x: currentOffset, y: 0))
                        }
                    }
                    
                }).addDisposableTo(disposeBag)
                break
            }
        }
        */
    }
    
    // UIPageViewControllerDelegate && UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.index(of: viewController as! ITBaseViewController) {
            if index > 0 {
                return viewControllers[index-1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.index(of: viewController as! ITBaseViewController) {
            if index < viewControllers.count-1 {
            
                return viewControllers[index+1]
            }
        }
        return nil
    }
    

    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed || finished{
            if !completed {
                currentIndex = viewControllers.index(of: previousViewControllers.first as! ITBaseViewController) ?? 0
            }else {
                calculateCurrentIndex(finished)
            }
        }
        
    }
    
    func calculateCurrentIndex(_ isFinished: Bool) {
        if let currrentVC = pageViewController.viewControllers?.first {
            currentIndex = viewControllers.index(of: currrentVC as! ITBaseViewController) ?? 0
            if isFinished {
                let tag = 6 - currentIndex
                ITToolBar.share.onlyChangeIndex = ITToolBarEvent(rawValue: tag)!
                ITToolBar.share.changeIndicator(contentOffset: CGPoint(x: CGFloat(currentIndex) * SCREEN_WIDTH, y: 0))
                isAnimationCompleted = true
            }
        }
    }
    
    //MARK: congifure ITToolBar
    func configureITToolBar() -> Swift.Void {
        ITToolBar.share.switchItem = { [unowned self] (event : ITToolBarEvent) -> () in
            print(event)
            let selectIndex: Int = 6 - event.rawValue
            // 设置pageViewController 滚动方向
            //print("currentIndex: \(self.currentIndex) selectIndex: \(selectIndex)")
            let direction: UIPageViewControllerNavigationDirection = selectIndex > self.currentIndex ? .forward : .reverse
            self.pageViewController.setViewControllers([self.viewControllers[selectIndex]], direction: direction, animated: true, completion: { [unowned self] (isCompleted) in
                if isCompleted {
                    self.calculateCurrentIndex(true)
                }
            })
        
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
    
    
    //MARK: rewrite scroll's animation
    
}

extension UIPageViewController: UIScrollViewDelegate {
    
    func configureDelegate()  -> Swift.Void {
        for v in view.subviews {
            if v is UIScrollView {
                let scrollView = v as! UIScrollView
                scrollView.delegate = self
                break
            }
        }
    }
}











