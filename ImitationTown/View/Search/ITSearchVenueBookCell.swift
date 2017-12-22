//
//  ITSearchVenueBookCell.swift
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

class ITSearchVenueBookCell: ITBaseCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var venueBookNameLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var backgroundContainerView: UIView!
    
    var venueBook: ITSearchVenubookModel! {
        didSet {
                    
            if let leftUrl = venueBook.venuebook?.coverInfo?.first?.original  {
                leftImageView.kf.setImage(with: ImageResource(downloadURL: URL.itURL(leftUrl)))
            }
            
            if let centerUrl = venueBook.venuebook?.coverInfo?[1].original {
                centerImageView.kf.setImage(with: ImageResource(downloadURL: URL.itURL(centerUrl)))
            }
            
            if let rightUrl = venueBook.venuebook?.coverInfo?[2].original {
                rightImageView.kf.setImage(with: ImageResource(downloadURL: URL.itURL(rightUrl)))
            }
            
            if let userIconUrl = venueBook.venuebook?.creator?.avatar?.original {
                userIconImageView.kf.setImage(with: ImageResource(downloadURL: URL.itURL(userIconUrl)))
            }
            
            if let likesCount = venueBook.venuebook?.likersCount {
                likesCountLabel.text = "\(likesCount)"
            }
            
            if let venueBookName = venueBook.venuebook?.name {
                venueBookNameLabel.text = venueBookName
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
