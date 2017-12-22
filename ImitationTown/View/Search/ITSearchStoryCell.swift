//
//  ITSearchStoryCell.swift
//  ImitationTown
//
//  Created by NEWWORLD on 2017/2/23.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  小组网站:https://www.codeinventor.club
//  简书网址:http://www.jianshu.com/c/d705110de6e0
//  项目网址:https://github.com/CodeInventorGroup/Imitation-Town
//  欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问
//

import UIKit
import Kingfisher

class ITSearchStoryCell: ITBaseCell {
    
    @IBOutlet weak var storyBackgroundImageView: UIImageView!
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var storyPagesTextLabel: UILabel!
    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!
        
    var searchStory: ITSearchStoryModel! {
        didSet {
            
            if let url = searchStory.fabula?.pages?.first?.images?.first?.original {
                storyBackgroundImageView.kf.setImage(with: ImageResource(downloadURL: URL.itURL(url), cacheKey: url.characters.count > 0 ? Initconfiguration.resCongifure_url_default + "/\(url)" : ""), placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
            }
            
            if let userIconUrl = searchStory.fabula?.creator?.avatar?.original {
                userIconImageView.kf.setImage(with: ImageResource(downloadURL: URL.itURL(userIconUrl), cacheKey: userIconUrl.characters.count > 0 ? Initconfiguration.resCongifure_url_default + "/\(userIconUrl)" : ""), placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler:nil)
            }
            
            if let createTime = searchStory.fabula?.createdAt {
                let createTimeValue = Int(createTime)
                dateLabel.text = (createTimeValue/1000).toTime(dateFormatter: "yyyy.MM.dd HH:mm")
            }
            
            if let venueName = searchStory.fabula?.venue?.name {
                cityNameLabel.text = venueName
            }
            
            if let pagesText = searchStory.fabula?.pages?.first?.text?.first {
                storyPagesTextLabel.text = pagesText
            }
            
            if let creatorName = searchStory.fabula?.creator?.name {
                creatorNameLabel.text = creatorName
            }
            
            if let readTimes = searchStory.fabula?.fmtReadTimes {
                readLabel.text = readTimes
            }
            
            if let commentsCount = searchStory.fabula?.commentsCount {
                commentLabel.text = "\(commentsCount)"
            }
            
            if let likersCount = searchStory.fabula?.likersCount {
                likeLabel.text = "\(likersCount)"
            }
            
            if let isLike = searchStory.fabula?.isLike {
                likeImageView.image = UIImage(named: isLike == true ? "Search_Like_Fill" : "Search_Like")
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
