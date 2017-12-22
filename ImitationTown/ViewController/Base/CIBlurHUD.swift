//  Created by CodeInventor Group
//  Copyright © 2017年 ManoBoo. All rights reserved.
//  our site:  https://www.codeinventor.club

//  Function:  带有Blur效果的提示框

import UIKit
import SnapKit

private let CIBlurBundlePath = Bundle.main.path(forResource: "CIBlurHUD", ofType: "bundle")!

private let CIBlurBundle = Bundle(path: CIBlurBundlePath)!

private let DefaultAnimationDuration = 0.35

class CIBlurHUD: UIView {

    private var tipImageView = UIImageView()
    private var tipLabel = UILabel()
    private var operationButton = UIButton()
    
    private var effectView = UIVisualEffectView()
    
    private var isBlack = true
    
    // 默认的一套KeyWindow中心布局
    public var DefaultCenterLayout: ((ConstraintMaker) -> Void) = { (make) in
        make.center.equalToSuperview()
        make.width.equalToSuperview().offset(-20)
        make.height.equalTo(120)
    }
    
    private var constrains: ((ConstraintMaker) -> Void)!
    private var style: CIBlurStyle = .dark
    private var type: CIBlurHUDType = .info
    private var animationType: CIBlurAnimation = .FadeInOut(DefaultAnimationDuration)
    
    
    public static let `default` = CIBlurHUD.init(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() -> Swift.Void {
        
        self.addSubview(effectView)
        effectView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    
        self.addSubview(tipImageView)
        
        tipLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        tipLabel.numberOfLines = 0
        self.addSubview(tipLabel)
        
        operationButton.addTarget(self, action: #selector(closeSelf), for: .touchUpInside)
        self.addSubview(operationButton)
    }
    
    @objc private func closeSelf() {
        executeAnimation(showOrHide: false, animationType: animationType)
    }
    
    
    private func setupEffect() {
        var effect = UIBlurEffect()
        switch style {
        case .extraLight:
            effect = UIBlurEffect(style: .extraLight)
        case .light:
            effect = UIBlurEffect(style: .light)
        case .regular:
            effect = UIBlurEffect(style: .regular)
        case .prominent:
            effect = UIBlurEffect(style: .prominent)
        default:
            effect = UIBlurEffect(style: .dark)
            isBlack = true
        }
        effectView.effect = effect
    }
    
    private func setupTipImage(_ displayImage: UIImage?) {
        tipImageView.snp.remakeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 35.0, height: 35.0))
        }
        
        operationButton.isHidden = true
        var isLoading = false
        
        if let displayImage = displayImage {
            tipImageView.image = displayImage
            
        }else {
            var image: UIImage?
            var imageName = "Info_white"
            
            switch type {
            case .guide(_):
                imageName = isBlack ? "Guide_white" : "Guide_black"
                operationButton.isHidden = false
                break
            case .success:
                imageName =  isBlack ? "success_white" : "success_black"
            case .error:
                imageName =  isBlack ? "Error_white" : "Error_black"
                break
            case .loading:
                imageName = isBlack ? "loading_white" : "loading_black"
                isLoading = true
                break
            default:
                
                break
            }
        
            if let imagePath = CIBlurBundle.path(forResource: imageName, ofType: "png") {
                image = UIImage.init(contentsOfFile: imagePath)
            }
            tipImageView.image = image
            if isLoading {
                tipImageView.startRotation(duration: 1.0, clockwise: true)
            }
        }
    }
    
    private func setupTipLabel(with text: String?) {
        tipLabel.textColor = isBlack ? UIColor.white : UIColor.black
        tipLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(tipImageView.snp.right).offset(30)
            make.right.equalTo(-48)
            make.centerY.equalToSuperview()
        }
        tipLabel.text = text
        
        if operationButton.isHidden == false {
            operationButton.snp.remakeConstraints({ (make) in
                make.right.equalTo(-20)
                make.size.equalTo(CGSize(width: 14.0, height: 14.0))
                make.centerY.equalToSuperview()
            })
            
            if let closeImagePath = CIBlurBundle.path(forResource: isBlack ? "Close_white" : "Close_black", ofType: "png") {
                operationButton.setImage(UIImage.init(contentsOfFile: closeImagePath), for: .normal)
            }
        }
    }
    
    //MARK: Animation
    
    private func rotaionAnimation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.tipImageView.transform = self.tipImageView.transform.rotated(by: CGFloat.pi)
            }) { (_) in
                self.rotaionAnimation()
            }
        }
    }
    
    private func completeAnimation() {
        var isAutoHide = true
        switch self.type {
        case .guide(let canAutoHide):
            isAutoHide = canAutoHide
            break
        case .loading:
            isAutoHide = false
        default:
            break
        }

        if isAutoHide {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2 * DefaultAnimationDuration, execute: {
                self.executeAnimation(showOrHide: false, animationType: self.animationType)
            })
        }
    }
    
    // showOrHide = true -> Show this HUD;  false -> Hide
    private func executeAnimation(showOrHide: Bool, animationType: CIBlurAnimation) {
    
        
        switch animationType {
        case .FadeInOut(let duration):
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
                self.alpha = showOrHide ? 1.0 : 0.0
            }) { [unowned self] (finished) in
                if finished {
                    if !showOrHide {
                        self.removeFromSuperview()
                    }else {
                        self.completeAnimation()
                    }
                }
            }
            break
        case .Spring(let duration):
            if !showOrHide {
                self.snp.remakeConstraints({ (make) in
                    make.center.equalToSuperview()
                    make.width.equalToSuperview().offset(-100)
                    make.height.equalTo(60)
                })
            }
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                self.alpha = showOrHide ? 1.0 : 0.0
                self.layoutIfNeeded()
                
            }) { (finished) in
                if finished {
                    if !showOrHide {
                        self.removeFromSuperview()
                    }else {
                        self.completeAnimation()
                    }
                }
            }
            break
        default:
            // no animation
            break
        }
    
    }
    
    //MARK: ****************************** style *********************************************
    
        // 提示类型 tip's type
    public enum CIBlurHUDType {
        case guide(Bool)    //  bool值 表示提示框是否可以自动关闭  bool value which mean whether the tip component can be closed automatically
        case success
        case error
        case loading
        case info
    }
        // 模糊效果 tip's blur effect
    public enum CIBlurStyle {
        case extraLight
        case light
        case dark
        
        @available(iOS 10.0, *)
        case regular // Adapts to user interface style
        
        @available(iOS 10.0, *)
        case prominent // Adapts to user interface style
    }
    
    // 进场动画/退场动画 Entrance Animation && Exit Animation
    public enum CIBlurAnimation {
        case FadeInOut(Double)   // 渐入渐出
        case Spring(Double)      // 弹簧效果
        case Nothing
    }

    //MARK: Method
    
        //MARK: -------------- SHOW ----------------
    
    public func show(_ info: String?) {
        show(info, type: .info, style: .dark, InOutAnimation: .FadeInOut(DefaultAnimationDuration), layout: nil)
    }
    
    public func show(_ info: String?, type: CIBlurHUDType = .info, style: CIBlurStyle = .dark, InOutAnimation: CIBlurAnimation = .FadeInOut(DefaultAnimationDuration), layout: ((ConstraintMaker) -> Void)?) -> Swift.Void {
        
        //  停止旋转
        if tipImageView.isRotating() {
            tipImageView.stopRotation()
        }
        
        self.style = style
        self.type = type
        
        setupEffect()
        setupTipImage(nil)
        setupTipLabel(with: info)
        
        KeyWindow.addSubview(self)
        self.constrains = layout ?? DefaultCenterLayout
        self.snp.remakeConstraints(self.constrains)
    
        executeAnimation(showOrHide: true, animationType: InOutAnimation)
        
    }
    
    public func show(_ info: String?, image: UIImage?, type: CIBlurHUDType = .info, style: CIBlurStyle = .dark, InOutAnimation: CIBlurAnimation = .FadeInOut(DefaultAnimationDuration), layout: ((ConstraintMaker) -> Void)?) -> Swift.Void {
        self.style = style
        self.type = type
        
        setupEffect()
        setupTipImage(image)
        setupTipLabel(with: info)
        
        KeyWindow.addSubview(self)
        self.constrains = layout ?? DefaultCenterLayout
        self.snp.remakeConstraints(self.constrains)
        
        executeAnimation(showOrHide: true, animationType: InOutAnimation)
    }
    
    public func showError(_ info: String?) {
        show(info, type: .error, style: .dark, InOutAnimation: .FadeInOut(DefaultAnimationDuration), layout: nil)
    }
    
    //MARK: -------------- HIDE ----------------
    
    public func hide() {
        switch type {
        case .loading:
            tipImageView.stopRotation()
        default:
            break
        }
        self.executeAnimation(showOrHide: false, animationType: self.animationType)
    }
}

// View Rotation
extension UIView {
    
    // duration: 一圈耗时
    // clockwise: 是否顺时针
    func startRotation(duration: TimeInterval, clockwise: Bool) -> Swift.Void {
        let kAnimationKey = "rotation"
        var currentState: CGFloat = 0
        if let presentationLayer = layer.presentation(),let zvalue = presentationLayer.value(forKeyPath: "transform.rotation.z") as? NSNumber {
            currentState = CGFloat(zvalue.floatValue)
        }
        if layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation.init(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = currentState
            animate.byValue = clockwise ? 2.0 * Float.pi : -2.0 * Float.pi
            layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    func isRotating() -> Bool {
        let kAnimationKey = "rotation"
        if layer.animation(forKey: kAnimationKey) != nil {
            return true
        }
        return false
    }
    
    // isAutomaticReset 旋转停止后 是否自动复位， 默认为 `true`
    func stopRotation(_ isAutomaticReset: Bool = true) -> Swift.Void {
        let kAnimationKey = "rotation"
        var currentState: CGFloat = 0
        if let presentationLayer = layer.presentation(),let zvalue = presentationLayer.value(forKeyPath: "transform.rotation.z") as? NSNumber {
            currentState = CGFloat(zvalue.floatValue)
        }
        if layer.animation(forKey: kAnimationKey) != nil {
            layer.removeAnimation(forKey: kAnimationKey)
        }
        
        if isAutomaticReset {
            UIView.animate(withDuration: DefaultAnimationDuration, animations: { 
                self.layer.transform = CATransform3DIdentity
            })
        }else {
            layer.transform = CATransform3DMakeRotation(currentState, 0, 0, 1)
        }
    }
}
