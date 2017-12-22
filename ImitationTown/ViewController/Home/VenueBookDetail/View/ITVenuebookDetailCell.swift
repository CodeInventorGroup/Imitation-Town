//
//  ITVenuebookDetailCell.swift
//  ImitationTown
//
//  Created by 贾宸穆 on 2017/3/16.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class ITVenuebookDetailCell: ITBaseCell {
    
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var englishTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var blackSep: UIView!
    @IBOutlet weak var explanationLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    var model: Variable<VenuebookDetailModel> = Variable(VenuebookDetailModel())
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        model.asObservable().subscribe { [unowned self] (event) in
            if let m = event.element {
                if let desc = m.venue?.pitch {
                    self.titleLabel.text = desc
                }
                if let name = m.venue?.name {
                    self.titleLabel.text = name
                }
                if let englishTitle = m.venue?.alias {
                    self.englishTitleLabel.text = englishTitle
                }
                if let originalImageURL = m.venue?.profileBackground?.original {
                    self.backImgView.ci.setImage(with: URL.itURL(originalImageURL), placeHolder: .color(m.venue?.profileBackground?.placeHolder), imageOperation: nil, completionHandler: nil)
                }
                if let location = m.venue?.city {
                    self.locationLabel.text = location
                }
                if let explanation = m.explanation {
                    if explanation.characters.count != 0 {
                        self.explanationLabel.isHidden = false
                        self.blackSep.isHidden = false
                        self.explanationLabel.text = explanation
                    }else {
                        self.explanationLabel.isHidden = true
                        self.blackSep.isHidden = true
                    }
                }else {
                    self.explanationLabel.text = ""
                }
            }
        }.addDisposableTo(disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
