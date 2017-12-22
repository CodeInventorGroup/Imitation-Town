//
//  ITHotSearchView.swift
//  ImitationTown
//
//  Created by NEWWORLD on 2017/2/8.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  小组网站:https://www.codeinventor.club
//  简书网址:http://www.jianshu.com/c/d705110de6e0
//  项目网址:https://github.com/CodeInventorGroup/Imitation-Town
//  欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问
//  热搜视图
//

import UIKit
import RxSwift
import SnapKit

class ITHotSearchView: UIView {
    
    private let disposeBag = DisposeBag()
    
    var hotSearchArray: [String]!  = []
    /// 计算得到热搜视图的高度
    var heightOfHotSearchView: CGFloat = 0.0
    
    var hotSearchImageView: UIImageView!
    
    class func hotSearchView(frame: CGRect, hotSearchArray: [String]!) -> ITHotSearchView {
        let hotSearchView = ITHotSearchView(frame: frame)
        hotSearchView.hotSearchArray = hotSearchArray
        hotSearchView.buildHotSearchView()
        return hotSearchView
    }
    
    /// 热搜视图
    func buildHotSearchView() {
        
        backgroundColor = UIColor.white
        buildHotSearchImageView()
        buildHotSearchListView()
    }
    
    /// 热搜标识图
    private func buildHotSearchImageView() {
        hotSearchImageView = UIImageView(frame: .zero);
        hotSearchImageView.image = UIImage(named: "Search_Hot")
        addSubview(hotSearchImageView)
        hotSearchImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    
    /// 热搜列表视图
    func buildHotSearchListView() {
        
        var right = hotSearchImageView.snp.right
        var top = hotSearchImageView.snp.top
        //记录行数
        var lineNum = 0
        
        let height: CGFloat = kFontSize_11
        //热词显示间距
        let margin: CGFloat = 20
        let leftMargin: CGFloat = 50
        //每行热词的高度，两行热词之间的间距
        let verticalMargin: CGFloat = 50
        //记录当前最后一个热词位置的最右侧maxRight
        var currentMaxRight: CGFloat = 0
        //热词显示的最大区域
        let maxSize: CGSize = CGSize(width: SCREEN_WIDTH, height: height)
        //位置
        var isFirst: Bool = true
        
        hotSearchArray.forEach { (hotSearchTitle) in
            
            let title: String = "#" + hotSearchTitle
            let button = hotSearchTitleButton(title: title)
            addSubview(button)
    
            button.snp.makeConstraints({ (make) in
                
                let width: CGFloat = title.calculateStringWidth(with: maxSize, font: UIFont.boldSystemFont(ofSize: kFontSize_11))
                currentMaxRight += width + margin
                
                if isFirst {
                    make.left.equalTo(leftMargin)
                    make.centerY.equalTo(top).offset(kFontSize_11 / 2.0 + 20)
                    isFirst = false
                }else {
                    if currentMaxRight > SCREEN_WIDTH - leftMargin {
                        lineNum += 1
                        currentMaxRight = width + margin
                        make.left.equalTo(leftMargin)
                        make.top.equalTo(top).offset(verticalMargin)
                    }else {
                        make.left.equalTo(right).offset(margin)
                        make.top.equalTo(top)
                    }
                }
            })
            
            top = button.snp.top
            right = button.snp.right
        }
        
        if lineNum > 0 {
            for i in 0..<lineNum {
                let separatorLine = buildSeparatorLine()
                addSubview(separatorLine)
                separatorLine.snp.makeConstraints { (make) in
                    make.left.equalTo(leftMargin)
                    make.right.equalTo(-10)
                    make.top.equalTo(CGFloat(i + 1) * verticalMargin - kSeparateLineThickness)
                    make.height.equalTo(kSeparateLineThickness)
                }
            }
        }
        
        //  视图总高度
        heightOfHotSearchView = verticalMargin * CGFloat(lineNum + 1)
    }
    
    func hotSearchTitleButton(title: String) -> UIButton {
        let button = UIButton.ci_button(frame: .zero, title: title, titleColor: UIColor.ci_rgb(red: 120, green: 130, blue: 145), font: UIFont.boldSystemFont(ofSize: kFontSize_11), backgroundColor: UIColor.white)
        
        weak var weakSelf = self
        button.rx.tap.subscribe { (event) in
            let text = button.titleLabel!.text!
            let index = text.index(text.startIndex, offsetBy: 1)
            let title = text.substring(from: index)
            print(title)
        }.addDisposableTo(weakSelf!.disposeBag)
        return button
    }
    
    /// 热搜列表分割线
    func buildSeparatorLine() -> UIView {
        let separatorLine = UIView.ci_separatorLine(color: UIColor.ci_rgb(red: 238, green: 238, blue: 238))
        return separatorLine
    }
}
