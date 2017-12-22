//  Created by CodeInventor Group
//  Copyright © 2017年 ManoBoo. All rights reserved.
//  our site:  https://www.codeinventor.club

//  Function:  ITHomeVenuebookCell

import UIKit
import Kingfisher

class ITHomeVenuebookCell: ITBaseCell {

    // 背景图片
    @IBOutlet weak var backgroundImgView: UIImageView!

    //  用户头像
    @IBOutlet weak var userAvatarImgView: UIImageView!
    
    // 地点集名称
    @IBOutlet weak var venuebookNameLabel: UILabel!
    
    @IBOutlet weak var venueNumLabel: UILabel!
    
    @IBOutlet weak var tagView: UIImageView!
    
    deinit {
        print("ITHomeVenuebookCell deinit")
    }
    
    var model: ITHomeVenuebookModel! {
        didSet {
            if let url = model.venuebook?.coverInfo?.first?.original {
                backgroundImgView.kf.setImage(with: ImageResource.init(downloadURL: URL.itURL(url)))
//                backgroundImgView.ci.setImage(with: URL.itURL(url), placeHolder: nil, imageOperation: [.scale(CGSize(width: SCREEN_WIDTH, height: 170))], completionHandler: nil)
            }
            
            if let userAvatarURL = model.venuebook?.creator?.avatar?.original {
                userAvatarImgView.kf.setImage(with: ImageResource.init(downloadURL: URL.init(string: ManoBooAvatar)!))
//                userAvatarImgView.ci.setImage(with: URL.itURL(userAvatarURL), placeHolder: nil, imageOperation: [.corner(0)], completionHandler: nil)
            }
            
            if let venuebookName = model.venuebook?.name {
                venuebookNameLabel.text = venuebookName
            }
            
            if let venueNum = model.venuebook?.venueCount {
                venueNumLabel.isHidden = false
                tagView.isHidden = false
                venueNumLabel.text = "\(venueNum)"
            }else {
                venueNumLabel.isHidden = true
                tagView.isHidden = true
            }
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userAvatarImgView.mask = UIImageView.init(image: UIImage.init(named: "smallAvatarMask"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
