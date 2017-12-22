//
//  ITCategoryTableViewCell.swift
//  ImitationTown
//
//  Created by ManoBoo on 17/2/23.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import SnapKit

class ITCategoryTableViewCell: ITBaseCell {
    // 地点Label
    @IBOutlet weak var locationLabel: UILabel!

    // 英文标题label
    @IBOutlet weak var englishLabel: UILabel!
    
    // title
    @IBOutlet weak var titleLabel: UILabel!
    
    // desciption
    @IBOutlet weak var descLabel: UILabel!
    
    // backImageView
    @IBOutlet weak var backImgView: UIImageView!
    
    var disposeBag = DisposeBag()
    
    let model: Variable<ITHomeCategoryResultModel> = Variable(ITHomeCategoryResultModel())

    override func awakeFromNib() {
        resetUI()
    }
    
    
    func resetUI() -> Swift.Void {
        model.asObservable().subscribe { [unowned self] (event) in
            if let m = event.element {
                if let backImgUrl = m.profileBackground?.original {
//                    self.backImgView.ci.setImage(with: URL.itURL(backImgUrl), placeHolder: .color(m.profileBackground?.placeHolder), imageOperation: nil, completionHandler: nil)
                    self.backImgView.kf.setImage(with: ImageResource.init(downloadURL: URL.itURL(backImgUrl)))
                }
                if let cityName = m.cityInfo?.name {
                    self.locationLabel.text = cityName
                }
                if let title = m.name {
                    self.titleLabel.text = title
                }
                if let desc = m.pitch {
                    self.descLabel.text = desc
                }
                if let englishName = m.alias {
                    self.englishLabel.text = englishName.uppercased()
                }
                
            }
        }.addDisposableTo(disposeBag)
    }
}
