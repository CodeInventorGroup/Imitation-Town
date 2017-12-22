//  Created by CodeInventor Group
//  Copyright © 2017年 ManoBoo. All rights reserved.
//  our site:  https://www.codeinventor.club

//  Function:  城市故事Cell

import UIKit
import Kingfisher

class ITHomeCityStoryCell: ITBaseCell {

    
    @IBOutlet weak var venueImgView: UIImageView!
    
    @IBOutlet weak var authorImgView: UIImageView!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var imageTagLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var createTimeLabel: UILabel!
    
    @IBOutlet weak var commentCountButton: UIButton!
    
    @IBOutlet weak var likeCountButton: UIButton!
    
    deinit {
        print("ITHomeCityStoryCell deinit")
    }
    
    var model: ITHomeCityStoryModel? {
        didSet {
            if let backgroundImageURL = model?.fabula?.pages?.first?.images?.first?.original {
//                venueImgView.ci.setImage(with: URL.itURL(backgroundImageURL))
                venueImgView.kf.setImage(with: URL.itURL(backgroundImageURL))
            }
            
            if let authorImageURL = model?.fabula?.creator?.avatar?.original {
//                authorImgView.ci.setImage(with: URL.itURL(authorImageURL), placeHolder: nil, imageOperation: [.corner(0)], completionHandler: nil)
                authorImgView.kf.setImage(with: ImageResource.init(downloadURL: URL.init(string: ManoBooAvatar)!))

            }
            
            if let imageTag = model?.fabula?.pages?.first?.text?.first {
                imageTagLabel.isHidden = false
                if let images = model?.fabula?.pages?.first?.images {
                    if images.count > 1 {
                        imageTagLabel.text = "\(images.count) pics " + imageTag
                    }
                }
                imageTagLabel.text = imageTag
            }else {
                imageTagLabel.isHidden = true
            }
            
            if let creatorName = model?.fabula?.creator?.name {
                authorNameLabel.text = creatorName
            }
            
            if let addressName = model?.fabula?.venue?.address {
                addressLabel.text = (model?.fabula?.venue?.cityInfo?.name) ?? "" + "•" + addressName
            }
            
            if let createTime = model?.fabula?.createdAt {
                // 服务器返回的时间 是 毫秒级的
                createTimeLabel.text = (createTime/1000).toTime(dateFormatter: "yyyy.MM.dd HH:mm")
            }
            
            if let commentCount = model?.fabula?.commentsCount {
                commentCountButton.setTitle("\(commentCount)", for: .normal)
            }
            
            if let likeCount = model?.fabula?.likersCount {
                likeCountButton.setTitle("\(likeCount)", for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.authorImgView.mask = UIImageView.init(image: UIImage.init(named: "smallAvatarMask"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
