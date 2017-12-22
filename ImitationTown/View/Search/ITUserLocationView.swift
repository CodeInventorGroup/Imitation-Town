//
//  ITUserLocationView.swift
//  ImitationTown
//
//  Created by NEWWORLD on 2017/3/30.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  用户定位 位置图示
//

import UIKit

class ITUserLocationView: MAPinAnnotationView {
    
    private var imageView = UIImageView()
    private var isRotating: Bool = false
    
    var iconImage: UIImage! {
    
        didSet {
            imageView = UIImageView(image: iconImage)
            imageView.layer.cornerRadius = self.frame.size.width/2
            imageView.layer.masksToBounds = true
            imageView.frame = self.bounds
            self.addSubview(imageView)
        }
    }
    
    //  旋转用户图标动画
    func rotationIconImage() {
        
        //  限制暴力点击 用户位置按钮
        if isRotating == true {
            return
        }
        isRotating = true
        
        let duration: TimeInterval = 1
        let keyAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        keyAnimation.values = [0, 2 * Double.pi+20/180 * Double.pi, 2 * Double.pi-20/180 * Double.pi, 2 * Double.pi]
        keyAnimation.duration = duration
        self.imageView.layer.add(keyAnimation, forKey: "keyAnimation")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            self.isRotating = false
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let spreadLayer = CALayer()
        let duration: CFTimeInterval = 3
        
        spreadLayer.bounds = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        spreadLayer.cornerRadius = rect.size.width/2
        spreadLayer.position = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
        spreadLayer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        
        let defaultCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = duration
        animationGroup.repeatCount = MAXFLOAT
        animationGroup.isRemovedOnCompletion = false
        animationGroup.timingFunction = defaultCurve
        
        //  尺寸动画
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 2.5
        scaleAnimation.duration = duration
        
        //  透明度动画
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = duration
        opacityAnimation.values = [0.5, 0.5, 0.3, 0.1]
        opacityAnimation.keyTimes = [0, 0.5, 0.7, 1]
        opacityAnimation.isRemovedOnCompletion = false
        
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        spreadLayer.add(animationGroup, forKey: "spead")
        
        self.layer.addSublayer(spreadLayer)
        self.layer.insertSublayer(spreadLayer, below: imageView.layer)
    }
}
