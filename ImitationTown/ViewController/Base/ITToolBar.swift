//
//  ITToolBar.swift
//  ImitationTown
//
//  Created by jiachenmu on 2016/10/18.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//  头部工具栏(功能类似于UITabBarController)

import UIKit
import SnapKit
import RxSwift

// explain :  顶部工具栏的点击事件
enum ITToolBarEvent : Int {
    case Add     = 1    //添加
    case Mine    = 2    //个人中心
    case Message = 3    //消息
    case Explore = 4    //探索
    case Feed    = 5    //流
    case Home    = 6    //首页
}

enum ITToolBarAnimation : Int {
    case defaultAnimation = 0     // 默认
    case fadeInout      // 渐入渐出
    case slide          // 上下滑动
}

class ITToolBar: UIView {
    
    //单例
    static let share = ITToolBar(frame: .zero)
    
    //切换item
    var switchItem : ((ITToolBarEvent) -> ())?
    
    //手动切换Item
    var currentIndex : ITToolBarEvent = .Home {
        willSet  {
            let button = self.viewWithTag(currentIndex.rawValue) as! UIButton
            button.isSelected = false;
        }
        didSet {
            let button = self.viewWithTag(currentIndex.rawValue) as! UIButton
            button.isSelected = true;
            switchItem?(currentIndex)
        }
    }
    
    // 上次ITToolBar动画类型
    var animationType: ITToolBarAnimation = .slide
    
    var onlyChangeIndex: ITToolBarEvent = .Home {
        willSet  {
            let button = self.viewWithTag(onlyChangeIndex.rawValue) as! UIButton
            button.isSelected = false;
        }
        didSet {
            let button = self.viewWithTag(onlyChangeIndex.rawValue) as! UIButton
            button.isSelected = true;
        }
    }
    
    private let disposeBag = DisposeBag()
    
    //指示器
    private var indicator : UIImageView!
    
    //严谨实现单例，应该将初始化方法设置为 private
    private override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        initToolBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: 滑动时调整指示器的位置
    func changeIndicator(contentOffset : CGPoint) -> Swift.Void {
        let offsetX = contentOffset.x
        
        let t = offsetX / SCREEN_WIDTH
        let idx = 6 - Int(t)
        
        let scale = (offsetX - t.maxCGFloatValue * SCREEN_WIDTH) / SCREEN_WIDTH
        if offsetX == 0.0 {
            indicator.center.x = getItem(tag: 6).center.x
            return
        }
        
        if idx == 1 {
            indicator.center.x = getItem(tag: 1).center.x + (getItem(tag: 1).center.x - getItem(tag: 2).center.x) * scale
        }else {
            indicator.center.x = getItem(tag: idx).center.x + (getItem(tag: idx-1).center.x - getItem(tag: idx).center.x) * scale
        }
    }

    //MARK: 设置隐藏
//    func hidden(_ isHidden: Bool, animated : Bool) {
//        hidden(isHidden, animated: animated, .DefaultAnimation)
//    }
    
    func hidden(_ isHidden: Bool, animated : Bool) -> Void {
        if animated {
            switch animationType {
                case .fadeInout:
                    UIView.animate(withDuration: DefaultAnimationInterval, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.isHidden = isHidden
                        self.alpha = self.alpha == 0 ? 1 : 0
                    }, completion: nil)
                case .slide:
                    
                    let originY = isHidden ? -50 : 0
                    self.setNeedsLayout()
                    self.snp.updateConstraints({ (make) in
                        make.top.equalTo(originY)
                    })
                    let damping: CGFloat = isHidden ? 0.8 : 0.5
                    UIView.animate(withDuration: DefaultAnimationInterval, delay: 0.0, usingSpringWithDamping: damping, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                        self.superview?.layoutIfNeeded()
                    }, completion: nil)
                default:
                    UIView.animate(withDuration: DefaultAnimationInterval, animations: {
                        self.isHidden = isHidden;
                    })
            }
        }else {
            self.alpha = 1.0
            self.isHidden = isHidden
        }
    }
    
    //MARK: -------------init bar------------
    func initToolBar() -> Swift.Void {
        initBarItems()
        initIndicator()
    }
    
    // init indicator 初始化指示器
    func initIndicator() -> Swift.Void {
        indicator = UIImageView()
        indicator.image = UIImage(named: "ITToolBarindicator")
        addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.width.equalTo(8)
            make.height.equalTo(6)
            make.bottom.equalTo(self).offset(-1)
            make.left.greaterThanOrEqualTo(0)
        }
        indicator.center.x = getItem(tag: 6).center.x
    }
    
    // init BarItems 初始化Items
    func initBarItems() -> Swift.Void {
        let imageDict = [["i-navi-add", "i-navi-add-yellow"],
                         ["i-navi-my", "i-navi-my-yellow"],
                         ["i-navi-message", "i-navi-message-yellow"],
                         ["i-navi-explore", "i-navi-explore-yellow"]]
        //创建右侧4个item
        func createButton(tag : Int) -> UIButton {
            let btn = UIButton()
            btn.tag = tag
            btn.adjustsImageWhenHighlighted = false
            btn.setImage(UIImage(named: imageDict[tag-1][0]), for: .normal)
            btn.setImage(UIImage(named: imageDict[tag-1][1]), for: .selected)
            addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.width.equalTo(37)
                make.height.equalTo(37)
                if tag == 1 {
                    make.right.equalTo(self.snp.right).offset(0)
                }else {
                    let fbtn = self.viewWithTag(tag-1)
                    make.right.equalTo(fbtn!.snp.left).offset(-5)
                }
                make.centerY.equalTo(self.snp.centerY)
            }
            return btn
        }
        
        //创建
        func createHomeAndFeed(tag : Int) -> UIButton {
            let btn = UIButton()
            btn.tag = tag
            btn.setTitle(tag == 6 ? "TOWN" : "FEED", for: .normal)
            btn.titleLabel?.font = UIFont.ITEngFont(size : 18.0)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.setTitleColor(Color_Main, for: .selected)
            addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.height.equalTo(36)
                make.centerY.equalTo(self.snp.centerY)
                make.centerX.equalTo(tag == 6 ? 30 : 85)
            }
            return btn
        }
        
        //类似于将这几个按钮放到数组里面一起处理
        weak var weakSelf = self
        let _ = [createButton(tag: 1),createButton(tag: 2),createButton(tag: 3),createButton(tag: 4), createHomeAndFeed(tag : 5), createHomeAndFeed(tag : 6)].map { (button) -> UIButton in
            //添加点击事件
            button.rx.tap.subscribe({ (event) in
                
                // 防止当前VC多次点击
                if weakSelf!.currentIndex.rawValue != button.tag {
                    weakSelf!.currentIndex = ITToolBarEvent(rawValue: button.tag)!
                }
            }).addDisposableTo(weakSelf!.disposeBag)
            
            return button
        }
    
    }
    
    func getItem(tag : Int) -> UIButton {
        let item = self.viewWithTag(tag)
        return item as! UIButton
    }
    
}


