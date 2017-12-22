//
//  ITMomentStoryDetailViewController.swift
//  ImitationTown
//
//  Created by NEWWORLD on 2017/4/1.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  小组网站:https://www.codeinventor.club
//  简书网址:http://www.jianshu.com/c/d705110de6e0
//  项目网址:https://github.com/CodeInventorGroup/Imitation-Town
//  欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问
//  故事 详情
//

import UIKit
import Kingfisher

class ITMomentStoryDetailViewController: ITBaseViewController {

    var storyData: Any! {
        didSet {
            if storyData is ITSearchStoryModel {
                storyData = storyData as! ITSearchStoryModel
            } else if storyData is ITSearchVenubookModel {
                storyData = storyData as! ITSearchVenubookModel
            } else if storyData is ITSearchUserModel {
                storyData = storyData as! ITSearchUserModel
            }
        }
    }
    
    @IBOutlet weak var navBackButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    private var imageScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nav = navigationController as? ITNavigationViewController {
            nav.isOnCustomAnimation = false
        }
        navBackButton.rx.controlEvent(.touchUpInside).subscribe { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }.addDisposableTo(disposeBag)
        
        buildImageScrollView()
        createImageViewsForScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ITToolBar.share.hidden(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Build View
    
    // 背景滚动图片
    private func buildImageScrollView() {
        
        imageScrollView = UIScrollView.init(frame: CGRect.zero)
        imageScrollView.contentSize = CGSize(width: SCREEN_WIDTH * 5, height: 0)
        imageScrollView.isPagingEnabled = true
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(imageScrollView)
        imageScrollView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.size.equalToSuperview()
        }
        self.view.sendSubview(toBack: imageScrollView)
    }
    
    //  添加背景图片
    private func createImageViewsForScrollView() {
        
        var images: [String] = [String]()
        if storyData is ITSearchStoryModel {
            let pages = (storyData as! ITSearchStoryModel).fabula?.pages
            for page in pages! {
                if let originalUrl = page.images?.first?.original {
                    images.append(originalUrl)
                }
            }
        } else if storyData is ITSearchVenubookModel {
            
        } else if storyData is ITSearchUserModel {
            
        }
        
        var leftMargin: CGFloat = 0
        
        for imageUrl in images {
            let index = images.index(of: imageUrl)!
            leftMargin = CGFloat(index) * SCREEN_WIDTH
            let backgroundImageView = UIImageView.init(frame: CGRect.zero)
            backgroundImageView.contentMode = UIViewContentMode.scaleAspectFill
            backgroundImageView.clipsToBounds = true
            backgroundImageView.kf.setImage(with: ImageResource(downloadURL: URL.itURL(imageUrl)))
            imageScrollView.addSubview(backgroundImageView)
            backgroundImageView.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.left.equalTo(leftMargin)
                make.size.equalToSuperview()
            })
            
        }
    }
    
    // MARK: Actions
    @IBAction func handleGoHomeAction(_ sender: Any) {
        
        // 回到首页
        navigationController?.popToRootViewController(animated: true)
        if navigationController?.childViewControllers[0] is ITHomeViewController {
            return
        }
        ITToolBar.share.currentIndex = .Home
    }
    
    @IBAction func handleRotateAction(_ sender: Any) {
        //  旋转界面
        print("旋转页面")
        
    }
    
    @IBAction func handleShowMoreAction(_ sender: Any) {
        //  更多
        print("查看更多")
    }
    
    
}
