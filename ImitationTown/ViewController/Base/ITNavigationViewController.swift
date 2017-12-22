//
//  ITNavigationViewController.swift
//  ImitationTown
//
//  Created by ManoBoo on 17/2/15.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  小组网站:https://www.codeinventor.club
//  简书网址:http://www.jianshu.com/c/d705110de6e0
//  项目网址:https://github.com/CodeInventorGroup/Imitation-Town
//  欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问
//

import UIKit

class ITNavigationViewController: UINavigationController, UIGestureRecognizerDelegate {
    
    // 是否开启自定义动画设置
    var isOnCustomAnimation: Bool = false {
        didSet {
            interactivePopGestureRecognizer?.isEnabled = !isOnCustomAnimation
            panGesture.delegate = isOnCustomAnimation ? self : nil
        }
    }
    
    // 记录滑动offsetX
    private var startOffsetX: CGFloat = 0.0
    
    // 自定义滑动手势
    var panGesture = UIPanGestureRecognizer()
    
    // 自定义滑动动画， isOnCustomAnimation == true 才有效
    var swipeAnimation: ( (CGFloat) -> () )?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        panGesture.addTarget(self, action: #selector(handleNavigationTransition(_ :)))
        view.addGestureRecognizer(panGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleNavigationTransition(_ panGesture: UIPanGestureRecognizer) {
        _ = interactivePopGestureRecognizer?.delegate?.perform(#selector(handleNavigationTransition(_:)), with: panGesture)
        let offsetX = panGesture.location(in: self.view).x - startOffsetX
        if offsetX >= 0 {
            if swipeAnimation != nil {
                swipeAnimation!(offsetX)
            }
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.childViewControllers.count == 1 {
            return false
        }
        startOffsetX = gestureRecognizer.location(in: view).x
        return true
    }
    

}
