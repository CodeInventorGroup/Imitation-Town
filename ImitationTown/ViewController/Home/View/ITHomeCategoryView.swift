//
//  ITHomeCategoryView.swift
//  ImitationTown
//
//  Created by ManoBoo on 17/2/13.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  小组网站:https://www.codeinventor.club
//  简书网址:http://www.jianshu.com/c/d705110de6e0
//  项目网址:https://github.com/CodeInventorGroup/Imitation-Town
//  欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问
//

import UIKit
import Kingfisher
import SnapKit
import RxSwift

class ITHomePageIconView: UIView {
    
    let disposeBag = DisposeBag()
    
    var iconView = UIImageView()
    
    var titleLabel = UILabel()
    
    var category: String?
    
    var model: Variable<ITHomeCategoryModel> = Variable(ITHomeCategoryModel())
    
    var clickEvent: ((String?) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 33, height: 33))
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 10.0)
        titleLabel.textColor = kColorGraySecond
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconView.snp.centerX)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(14)
        }
        
        // 添加点击手势
        weak var weakSelf = self
        let tapGessture = UITapGestureRecognizer()
        tapGessture.rx.event.subscribe { (_) in
            if let clickEvent = weakSelf?.clickEvent {
                clickEvent(weakSelf?.model.value.code)
            }
        }.addDisposableTo(disposeBag)
        addGestureRecognizer(tapGessture)
        
        // reset up view
        model.asObservable().subscribe { (event) in
            if let m = event.element {
                if let iconURL = m.icons?.blue {
                        weakSelf?.iconView.kf.setImage(with: ImageResource.init(downloadURL: URL.itURL(iconURL)))
                    }
                    if let categoryTitle = m.title {
                        weakSelf?.titleLabel.text = categoryTitle
                    }
                    weakSelf?.category = m.code
            }
        }.addDisposableTo(disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}


class ITHomeCategoryView: UIScrollView {
    
    let disposeBag = DisposeBag()
    
    var data: Variable<[ITHomeCategoryModel]> = Variable([])

    
    var clickEvent:( (String) -> () )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showsHorizontalScrollIndicator = false
        
        weak var weakSelf = self
        
        // 当 Variable.value 发生变化时，发出信号，  类似于  didSet 的作用
        data.asObservable().subscribe { (event) in
            if let modelArr = event.element {
                _ = weakSelf?.subviews.flatMap({ (subView) -> UIView? in
                    subView.removeFromSuperview()
                    return subView
                })
                weakSelf?.buildContentView(with: modelArr)
            }
        }.addDisposableTo(disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    
    func buildContentView(with modelArr: [ITHomeCategoryModel]) -> Swift.Void{
        
        let count = modelArr.count
        let xIndex: Int = count % 2 == 0 ? count/2 :count/2+1
        self.contentSize = CGSize(width: xIndex * 69, height: 200)
        
        var leftView = ITHomePageIconView()
        
        weak var weakSelf = self
        
        for (index, model) in modelArr.enumerated() {
            let iconView = ITHomePageIconView(frame: .zero)
            iconView.model.value = model
            iconView.clickEvent = { (categoryCode) in
                if let code = categoryCode {
                    if let clickEvent = weakSelf?.clickEvent {
                        clickEvent(code)
                    }
                }
            }
            self.addSubview(iconView)
            iconView.snp.makeConstraints({ (make) in
                make.size.equalTo(CGSize(width: 69, height: 100))
                make.top.equalTo( index < xIndex ? 0 : 100)
                make.left.equalTo( (index == 0 || index == xIndex) ? 0 : leftView.snp.right)
            })
            leftView = iconView
        }
    }
}
