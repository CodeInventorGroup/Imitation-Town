//
//  ITSearchUserCell.swift
//  ImitationTown
//
//  Created by NEWWORLD on 2017/2/28.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  小组网站:https://www.codeinventor.club
//  简书网址:http://www.jianshu.com/c/d705110de6e0
//  项目网址:https://github.com/CodeInventorGroup/Imitation-Town
//  欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问
//

import UIKit
import Kingfisher

class ITSearchUserCell: ITBaseCell {

    @IBOutlet weak var userBackgroundImageView: UIImageView!
    @IBOutlet weak var connoisseurImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var storyCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var searchUser: ITSearchUserModel! {
        
        didSet {
            
            if let isConnoisseur = searchUser.user?.isConnoisseur {
                connoisseurImageView.isHidden = !isConnoisseur
            }
            
            if let url = searchUser.user?.profileBackground?.original {
                userBackgroundImageView.kf.setImage(with: ImageResource(downloadURL: URL.itURL(url)))
            }
            
            if let userName = searchUser.user?.name {
                userNameLabel.text = userName
            }
            
            if let pitch = searchUser.user?.pitch {
                introductionLabel.text = pitch
            }
    
            if let storyCount = searchUser.user?.fabulasCreatedCount {
                storyCountLabel.text = "\(storyCount)"
            }
            
            if let likesCount = searchUser.user?.followerCount {
                likesCountLabel.text = "\(likesCount)"
            }
            
            if let isFollowing = searchUser.user?.isFollowing {
                followButton.setImage(UIImage(named: isFollowing == true ? "Search_Following_Check" : "Search_Follow_Add"), for: UIControlState.normal)
                followButton.setTitle(isFollowing == true ? "FOLLOWING" : "FOLLOW", for: UIControlState.normal)
                followButton.backgroundColor = isFollowing == true ? UIColor.clear : UIColor.ci_rgb(red: 255, green: 0, blue: 0)
                followButton.layer.borderWidth = isFollowing == true ? 0.5 : 0
                followButton.layer.borderColor = isFollowing == true ? UIColor.white.cgColor : UIColor.clear.cgColor
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
