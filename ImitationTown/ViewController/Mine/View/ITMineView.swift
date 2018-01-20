//
//  ITMineView.swift
//  ImitationTown
//
//  Created by ManoBoo on 2018/1/20.
//  Copyright © 2018年 CodeInventor Group. All rights reserved.
//

import UIKit

class ITMineView: UIView {
    
    var thumbImage: String?
    
    var name: String?
    
    var links: [String: String]?
    
    let avatarImageView = UIImageView()
    let contentView = ITMineBlurView.init(effect: UIBlurEffect.init(style: .light))

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() {
        addSubview(contentView)
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(34)
            maker.height.equalTo(34)
        }
    }
}

class ITMineBlurView: UIVisualEffectView {
    
    var gapCornerRadius: CGFloat = 34.0
    var cornerRadius: CGFloat = 3.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath.init()
        path.addArc(withCenter: CGPoint.init(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: 0.0, endAngle: CGFloat.pi / 2, clockwise: true)
        path.move(to: CGPoint.init(x: cornerRadius, y: 0))
        
        var leftGapPoint = rect.width
        path.addLine(to: CGPoint.init(x: <#T##CGFloat#>, y: 0))
    }
}
