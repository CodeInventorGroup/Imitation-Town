//
//  ITMineView.swift
//  ImitationTown
//
//  Created by ManoBoo on 2018/1/20.
//  Copyright © 2018年 CodeInventor Group. All rights reserved.
//

import UIKit
import Kingfisher

class ITMineView: UIView {
    
    var clickMember: ( (Int) -> Void )? {
        didSet {
            manobooControl.addHandler(for: .touchUpInside) { _ in self.clickMember?(0) }
            zrflowerControl.addHandler(for: .touchUpInside) { _ in self.clickMember?(1) }
        }
    }

    var isQuietMode: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.35, animations: {
                self.manobooView.alpha = self.isQuietMode ? 0.0 : 1.0
                self.zrflowerView.alpha = self.isQuietMode ? 0.0 : 1.0
            })
        }
    }

    fileprivate let backgroundImgView = UIImageView()

    fileprivate let manobooControl = UIControl.init()
    fileprivate let manobooView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .extraLight))
    
    fileprivate let zrflowerControl = UIControl()
    fileprivate let zrflowerView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .extraLight))
    
    fileprivate let titleLabel = UILabel()
    
    fileprivate let thumbImages = [ManoBooAvatar, ZRFlowerAvatar]
    var thumbImageViews = [UIImageView]()

    fileprivate let names = ["ManoBoo", "ZRFlower"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() {
        addSubview(backgroundImgView)
        backgroundImgView.image = UIImage.gifImage(name: "Mine_background")
        backgroundImgView.contentMode = UIViewContentMode.scaleAspectFill
        backgroundImgView.clipsToBounds = true
        backgroundImgView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

        titleLabel.font = UIFont.boldSystemFont(ofSize: 48.0)
        titleLabel.textColor = .white
        titleLabel.text = "关于我们"
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.right.equalTo(20)
            maker.top.equalTo(20)
        }
        manobooView.layer.cornerRadius = 10.0
        manobooView.layer.masksToBounds = true
        
        zrflowerView.layer.cornerRadius = 10.0
        zrflowerView.layer.masksToBounds = true
        
        manobooView.contentView.addSubview(manobooControl)
        manobooControl.snp.makeConstraints { $0.edges.equalToSuperview() }
        addSubview(manobooView)
        manobooView.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.right.equalTo(-20)
            maker.top.equalTo(titleLabel.snp.bottom).offset(50)
            maker.height.equalTo(140)
        }
        
        zrflowerView.contentView.addSubview(zrflowerControl)
        zrflowerControl.snp.makeConstraints { $0.edges.equalToSuperview() }
        addSubview(zrflowerView)
        zrflowerView.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.right.equalTo(-20)
            maker.top.equalTo(manobooView.snp.bottom).offset(40)
            maker.height.equalTo(140)
        }
        
        buildDetail()
    }
    
    func buildDetail() {
        for (index, infoView) in [manobooView, zrflowerView].enumerated() {
            let thumbImgView = UIImageView()
            thumbImgView.layer.cornerRadius = 50
            thumbImgView.layer.masksToBounds = true
            thumbImageViews.append(thumbImgView)
            thumbImgView.kf.setImage(with: ImageResource.init(downloadURL: URL(string: thumbImages[index])!))
            infoView.contentView.addSubview(thumbImgView)
            thumbImgView.snp.makeConstraints({ (maker) in
                maker.left.top.equalTo(20)
                maker.bottom.equalTo(-20)
                maker.width.equalTo(infoView.snp.height).offset(-40)
            })
            
            let nameLabel = UILabel()
            nameLabel.text = names[index]
            nameLabel.textColor = .gray
            nameLabel.textAlignment = .center
            infoView.contentView.addSubview(nameLabel)
            nameLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
            nameLabel.textAlignment = .center
            nameLabel.snp.makeConstraints({ (maker) in
                maker.right.equalTo(0)
                maker.left.equalTo(thumbImgView.snp.right)
                maker.centerY.equalToSuperview()
            })
        }
    }
}

