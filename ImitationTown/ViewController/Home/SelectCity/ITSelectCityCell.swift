//
//  ITSelectCityCell.swift
//  ImitationTown
//
//  Created by ManoBoo on 2017/2/27.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class ITSelectCityCell: ITBaseCell {
    
    private var countryImgView = UIImageView()
    
    private var countryNameLabel = UILabel()
    
    private var cityView = UIView()
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var country: Variable<CountryModel> = Variable(CountryModel())
    var citys: Variable<[RegionModel]> = Variable([])
    
    
    func buildCell() -> Swift.Void {
        self.selectionStyle = .none
        countryImgView.backgroundColor = UIColor.red
        contentView.addSubview(countryImgView)
        countryImgView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(20)
            make.height.equalTo(14)
            make.width.equalTo(20)
        }
        
        contentView.addSubview(countryNameLabel)
        countryNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(countryImgView.snp.right).offset(10)
            make.centerY.equalTo(countryImgView)
            make.height.equalTo(20)
        }
        
        contentView.addSubview(cityView)
        contentView.snp.updateConstraints { (make) in
            make.width.equalToSuperview()
            make.bottom.equalTo(cityView.snp.bottom)
        }
        
        country.asObservable().subscribe { (event) in
            // 
        }.addDisposableTo(disposeBag)
        
        citys.asObservable().subscribe { [unowned self] (event) in
            if let citys = event.element {
                print(citys.count)
                if citys.count > 0 {
                    self.countryNameLabel.text = citys[0].countryName
                    self.buildCitys(citys)
                }
            }
        }.addDisposableTo(disposeBag)
    }
    
    func buildCitys(_ citys: [RegionModel]) -> Swift.Void {
        for view in cityView.subviews {
            view.removeFromSuperview()
        }
        var leftButton = UIButton()
        for (index, city) in citys.enumerated() {
        
            let btn = UIButton()
            btn.setTitle(city.name, for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
            cityView.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.height.equalTo(15.0)
                if index % 4 == 0 {
                    make.left.equalTo(0)
                    if index == 0 {
                        make.top.equalTo(0)
                    }else {
                        make.top.equalTo(leftButton.snp.bottom).offset(35.0)
                    }
                }else {
                    make.left.equalTo(leftButton.snp.left).offset(70.0)
                    make.top.equalTo(leftButton.snp.top)
                }
            })
            leftButton = btn
        }
        
        cityView.snp.remakeConstraints { (make) in
            make.right.equalTo(-40)
            make.left.equalTo(40)
            make.top.equalTo(60)
            
            make.bottom.equalTo(leftButton.snp.bottom).offset(10)
        }
    }
}

