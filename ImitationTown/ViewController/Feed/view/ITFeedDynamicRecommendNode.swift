//
//  ITFeedDynamicRecommendNode.swift
//  ImitationTown
//  https://www.manoboo.com
//  Created by ManoBoo on 2017/8/2.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  该类是 Feed页面中 view顶端的动态推荐

import UIKit
import SnapKit
import RxSwift

// 用户动态Feed流
struct ITFeedDynamicRecommendModel {
    var user_id: Int?
    var user_name: String?
    var user_avatar: String?
    var dynamicInfo: String?
}


class ITFeedDynamicRecommendView: UIView {
    
    var disposeBag = DisposeBag()
    var nodes = Variable<[ITFeedDynamicRecommendModel]>.init([])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nodes.asObservable()
        .subscribe(onNext: { [unowned self] (models) in
            for (index,m) in models.enumerated() {
                let node = ITFeedDynamicRecommendNode()
                node.model.value = m
                node.isShowSeparator = index != 0
                self.addSubview(node)
                node.snp.makeConstraints({ (make) in
                    make.top.equalTo(index * 44)
                    make.right.left.equalTo(0)
                    make.height.equalTo(44)
                })
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        .addDisposableTo(disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ITFeedDynamicRecommendNode: UIView {
    
    enum ClickType {
        case delete
        case attention
    }
    
    var disposeBag = DisposeBag()
    
    var model: Variable<ITFeedDynamicRecommendModel> = Variable.init(ITFeedDynamicRecommendModel())

    var isShowSeparator = true {
        didSet {
            separator.isHidden = !isShowSeparator
        }
    }

    private var avatarImgView = UIImageView()
    private var userNameLabel = UILabel()
    private var dynamicInfoLabel = UILabel()
    private var deleteBtn = UIButton()
    private var addAttentionBtn = UIButton()
    private var separator = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        buildUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func buildUI() {

        addSubview(avatarImgView)
        avatarImgView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 30.0, height: 30.0))
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        userNameLabel.textColor = UIColor.hex(hex: 0x000000)
        userNameLabel.font = UIFont.systemFont(ofSize: 12.0)
        userNameLabel.preferredMaxLayoutWidth = 60
        addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImgView.snp.right).offset(10)
            make.centerY.equalTo(avatarImgView.snp.centerY)
        }
        
        dynamicInfoLabel.textColor = UIColor.hex(hex: 0x737373)
        dynamicInfoLabel.font = UIFont.systemFont(ofSize: 12.0)
        addSubview(dynamicInfoLabel)
        dynamicInfoLabel.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualTo(175)
            make.height.equalTo(12)
            make.left.equalTo(userNameLabel.snp.right).offset(10)
            make.centerY.equalTo(avatarImgView.snp.centerY)
        }

        separator.backgroundColor = UIColor.hex(hex: 0xE9E9E9)
        addSubview(separator)
        separator.snp.makeConstraints { maker in
            maker.top.equalTo(0)
            maker.right.equalTo(-10)
            maker.left.equalTo(userNameLabel.snp.left)
            maker.height.equalTo(0.5)
        }
        
        // 数据绑定
        model.asObservable().subscribe(onNext: { [weak self] (m) in
            if let avatarUrl = m.user_avatar {
                self?.avatarImgView.ci.setImage(with: URL.init(string: avatarUrl), placeHolder: nil, imageOperation: [.corner(0)], completionHandler: nil)
            }
            if let userName = m.user_name {
                self?.userNameLabel.text = userName
            }
            if let dynamicInfo = m.dynamicInfo {
                self?.dynamicInfoLabel.text = dynamicInfo
            }
            
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
    }
}
