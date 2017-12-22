//
//  ITLoadingViewController.swift
//  ImitationTown
//
//  Created by jiachenmu on 2016/10/18.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//  启动页面  图片渐变动画

import UIKit
import RxSwift

class ITLoadingViewController: ITBaseViewController {

    var imgViewArray : Array<UIImageView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        //init imgViewArray
        imgViewArray = [CMImageView(tag: 4),CMImageView(tag: 3),CMImageView(tag: 2),CMImageView(tag: 1)].map({ (imgView) -> UIImageView in
            imgView.alpha = 0.0
            view.addSubview(imgView)
            return imgView
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimation()
    }
    
    deinit {
        imgViewArray?.removeAll()
    }
    
//MARK: Method
    
    //init ImageView
    func CMImageView(tag : Int) -> UIImageView {
        let imgView = UIImageView.init(frame: view.bounds)
        imgView.tag = tag
        imgView.image = UIImage(named: "intro\(tag)")
        return imgView;
    }

//MARK: Start Animation
    func startAnimation() -> Swift.Void {
        imageViewAnimation(index: 1)
    }

    func imageViewAnimation(index : Int) -> Void {
        weak var weakSelf = self
        var index = index
        if index > imgViewArray!.count {
            //动画执行完毕
            AppDelegate.share().switchRootViewController()
            return
        }
        let imgView = view.viewWithTag(index)
        let alphaValue1 : CGFloat = 1.0
        let alphaValue2 : CGFloat = 0.0
        UIView.animate(withDuration: 1.0, animations: {
            imgView?.alpha = alphaValue1
            }) { (finished) in
                if finished {
                    index += 1
                    weakSelf?.imageViewAnimation(index: index)
                    UIView.animate(withDuration: 1.0, animations: {
                            imgView?.alpha = alphaValue2
                    })
                }
        }
    }

}

class CMView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
