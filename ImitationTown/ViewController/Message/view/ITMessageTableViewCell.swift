//
//  ITMessageTableViewCell.swift
//  ImitationTown
//
//  Created by ManoBoo on 04/09/2017.
//  Copyright © 2017 CodeInventor Group. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

/// ITMessageViewController中的消息Cell
class ITMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatarImgView: UIImageView!
    
    @IBOutlet weak var introductionLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    var messageNode: ITMessageFeedModel? {
        didSet {
            print("---------")
            if let model = messageNode {
                if let avatarUrl = URL.init(string: model.user_avatar) {
                    self.userAvatarImgView.kf.setImage(with: ImageResource.init(downloadURL: avatarUrl))
//                    self.userAvatarImgView.ci.setImage(with: avatarUrl, placeHolder: nil, imageOperation: [.corner(0)], completionHandler: nil)
                }
                
                let attributeStr = NSMutableAttributedString.init(string: model.user_name + ": " + model.user_introduce)
                attributeStr.addAttributes([NSForegroundColorAttributeName: UIColor.black], range: NSMakeRange(0, model.user_name.characters.count + 2))
                
                self.introductionLabel.attributedText = attributeStr
                
                self.messageLabel.text = model.message
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userAvatarImgView.mask = UIImageView.init(image: UIImage.init(named: "messageAvatarMask"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
