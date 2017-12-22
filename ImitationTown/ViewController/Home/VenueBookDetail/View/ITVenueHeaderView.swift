//
//  ITVenueHeaderView.swift
//  ImitationTown
//
//  Created by ManoBoo on 2017/3/15.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class ITVenueHeaderView: UIView {

    @IBOutlet weak var avatarImgView: UIImageView!
    
    @IBOutlet weak var venueTitleLabel: UILabel!

    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var venueDescLabel: UILabel!
    
    @IBOutlet weak var mapButton: UIView!
    
    @IBOutlet weak var venuePandectView: UIView!
    
    @IBOutlet weak var venueCountLabel: UILabel!
    
    var model: Variable<VenuebookModel> = Variable(VenuebookModel())
    
    var disposeBag = DisposeBag()

    var mapClickEvent: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mapButton.tap { (tag, sender) in
            if let mapClickEvent = self.mapClickEvent {
                mapClickEvent()
            }
        }
        
        model.asObservable().subscribe { [unowned self] (event) in
            if let model = event.element {
                if let title = model.name {
                    self.venueTitleLabel.text = title
                }
                
                if let avatarImageUrl = model.creator?.avatar?.original {
//                    self.avatarImgView.ci.setImage(with: URL.itURL(avatarImageUrl), placeHolder: .image(UIImage(named: "avatar_default")), imageOperation: [.corner(0)], completionHandler: nil)
                    
                    self.avatarImgView.kf.setImage(with: ImageResource.init(downloadURL: URL.init(string: ManoBooAvatar)!))
                }
                
                if let favoriteCount = model.likersCount {
                    self.favoriteButton.setTitle("\(favoriteCount)", for: .normal)
                }
                if let commentCount = model.commentsCount {
                    self.commentButton.setTitle("\(commentCount)", for: .normal)
                }
                if let authorName = model.creator?.name {
                    self.authorNameLabel.text = authorName
                }
                if let desc = model.pitch {
                    self.venueDescLabel.text = desc
                }
                if let venueCount = model.venueCount {
                    self.venueCountLabel.text = "\(venueCount) VENUES"
                }
            }
        }.addDisposableTo(disposeBag)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 重新调整高度
        self.snp.updateConstraints { (make) in
            make.width.equalToSuperview()
            make.bottom.equalTo(venuePandectView.snp.bottom)
        }
    }
    
    
    
    
    
    //MARK: Action
    
}
