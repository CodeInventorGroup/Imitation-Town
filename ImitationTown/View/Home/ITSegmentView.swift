//
//  ITSegmentView.swift
//  ImitationTown
//
//  Created by NEWWORLD on 2016/10/18.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//  自定义segmentView

import UIKit
import SnapKit
import RxSwift

class ITSegmentView: UIView {
    
    var titleArray: [String]!
    var fontTitle: UIFont!
    var normalColorTitle: UIColor!
    var selectedColorTitle: UIColor!
    var cornerRadius: CGFloat?
    var selectedBackgroundColor: UIColor!
    var normalBackgroundColor: UIColor!
    var separateLineColor: UIColor!
    var separateLineThickness: CGFloat!
    
    var selectedIndex: Int! {
    
        willSet {
            if let index = selectedIndex {
                let selectedButton = self.viewWithTag(changeIndexForTag(index)) as! UIButton
                selectedButton.isSelected = false
                selectedButton.backgroundColor = self.normalBackgroundColor
            }
        }
        
        didSet {
            if let index = selectedIndex  {
                let selectedButton = self.viewWithTag(changeIndexForTag(index)) as! UIButton
                selectedButton.isSelected = true
                selectedButton.backgroundColor = self.selectedBackgroundColor
            }
        }
    }
    
    var handleSelectedIndexClosure = {(selectedIndex: Int) -> () in
        
    }
    
    //  修复bug(index=0时，self.viewWithTag(index)取到self本身，不能获取正确的子视图)，根据index生成相应的tag值
    private var changeIndexForTag = { (index: Int) -> Int in
        return index + 100
    }
    
    
    private var itemsArray: [UIButton]?
    private let disposeBag = DisposeBag()
    
    //  单个item的高度和宽度
    private var widthButton: CGFloat?
    private var heightButton: CGFloat?
    
    /// SegmentView
    ///
    /// - parameter frame:                      frame,可以为CGRectzero
    /// - parameter titleArray:                 标题数据
    /// - parameter selectedIndex:              初始化选中位置
    /// - parameter handleSelectedIndexClosure: 处理选中某个标题的事件闭包
    ///
    /// - returns: Initialization SegmentView completely
    class func townSegmentView(frame: CGRect, titleArray: [String]!, selectedIndex: Int!, handleSelectedIndexClosure: @escaping (_ selectedIndex: Int) -> ()) -> ITSegmentView {
        let segmentView = ITSegmentView.segmentView(frame: frame,
                                                    fontTitle: UIFont.boldSystemFont(ofSize: kFontSize_13),
                                                    normalColorTitle: kColorGrayLight,
                                                    titleArray: titleArray,
                                                    selectedColorTitle: UIColor.black,
                                                    cornerRadius: kCornerRadius_SegentView,
                                                    normalBackgroundColor: UIColor.white,
                                                    selectedBackgroundColor: kColorBackgroundGray,
                                                    separateLineColor: kColorSeparateLine,
                                                    separateLineThickness: kSeparateLineThickness,
                                                    selectedIndex: selectedIndex,
                                                    handleSelectedIndexClosure: handleSelectedIndexClosure)
        return segmentView
    }

    //MARK: 初始化方法
    class func segmentView(frame: CGRect, fontTitle: UIFont!, normalColorTitle: UIColor!, titleArray: [String]!, selectedColorTitle: UIColor!, cornerRadius: CGFloat?, normalBackgroundColor: UIColor!, selectedBackgroundColor: UIColor!, separateLineColor: UIColor!, separateLineThickness: CGFloat!, selectedIndex: Int!, handleSelectedIndexClosure: @escaping (_ selectedIndex: Int) -> ()) -> ITSegmentView {
        let segmentView = ITSegmentView.init(frame: frame)
        segmentView.titleArray = titleArray
        segmentView.fontTitle = fontTitle
        segmentView.normalColorTitle = normalColorTitle
        segmentView.selectedColorTitle = selectedColorTitle
        segmentView.cornerRadius = cornerRadius
        segmentView.normalBackgroundColor = normalBackgroundColor
        segmentView.selectedBackgroundColor = selectedBackgroundColor
        segmentView.separateLineColor = separateLineColor
        segmentView.separateLineThickness = separateLineThickness
        segmentView.handleSelectedIndexClosure = handleSelectedIndexClosure
        
        segmentView.buildSegmentView()
        segmentView.selectedIndex = selectedIndex
        return segmentView
    }
    
    // MARK: 适合用约束初始化
    func loadSetting(titleArray: [String]!, selectedIndex: Int!, handleSelectedIndexClosure: @escaping (_ selectedIndex: Int) -> ()) {
        self.titleArray = titleArray
        fontTitle = UIFont.boldSystemFont(ofSize: kFontSize_13)
        self.normalColorTitle = kColorGrayLight
        self.selectedColorTitle = UIColor.black
        self.cornerRadius = kCornerRadius_SegentView
        self.normalBackgroundColor = UIColor.white
        self.selectedBackgroundColor = kColorBackgroundGray
        self.separateLineColor = kColorSeparateLine
        self.separateLineThickness = kSeparateLineThickness
        self.handleSelectedIndexClosure = handleSelectedIndexClosure
        self.buildSegmentView()
        self.selectedIndex = selectedIndex
    }

    //MARK:
    func buildSegmentView() {
    
        widthButton = frame.width/CGFloat(titleArray.count)
        heightButton = frame.height

        if let radius = cornerRadius {
            layer.cornerRadius = radius
        }
        layer.borderColor = separateLineColor.cgColor
        layer.borderWidth = separateLineThickness
        clipsToBounds = true
        
        for (index, object) in titleArray.enumerated() {
            buildButtonView(title: object, index: index)
            if index != 0 {
                buildMiddleLineView(index: index)
            }
        }
    }
    
    // 单个item按钮
    private func buildButtonView(title: String?, index: Int!) {
        
        let button : UIButton = UIButton.ci_button(frame: .zero, title: title, titleColor: normalColorTitle, font: fontTitle, backgroundColor: normalBackgroundColor)
        button.setTitle(title, for: .selected)
        button.setTitleColor(selectedColorTitle, for: .selected)
        button.tag = changeIndexForTag(index)
        weak var weakSelf = self
        button.rx.tap.subscribe { (event) in
            if button.tag != self.changeIndexForTag((weakSelf?.selectedIndex)!) {
                weakSelf?.selectedIndex = index
                weakSelf?.handleSelectedIndexClosure(index)
            }
        }.addDisposableTo(weakSelf!.disposeBag)
        addSubview(button)
        
        button.snp.makeConstraints({ (make) in
            
            make.width.equalToSuperview().dividedBy(titleArray.count)
            make.height.equalToSuperview()
            
            make.top.equalTo(0)
            if index == 0 {
                make.left.equalTo(0)
            }else {
                let leftButton = self.viewWithTag(button.tag-1)!
                make.left.equalTo(leftButton.snp.right)
            }
        })
    }
    
    //  中间分割线
    func buildMiddleLineView(index: Int!) {
        let lineView = UIView()
        lineView.backgroundColor = separateLineColor
        addSubview(lineView)
        
        let leftButton = self.viewWithTag(changeIndexForTag(index)-1)!
        lineView.snp.makeConstraints { (make) in
            make.width.equalTo(separateLineThickness)
            make.height.equalToSuperview()
            make.centerY.equalTo(self)
            make.centerX.equalTo(leftButton.snp.right)
        }
    }
}
