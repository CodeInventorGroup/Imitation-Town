//
//  ITMemberViewController.swift
//  ImitationTown
//
//  Created by ManoBoo on 2018/1/22.
//  Copyright © 2018年 CodeInventor Group. All rights reserved.
//

import UIKit
import Kingfisher
import ImageIO
import MobileCoreServices

class ITMemberViewController: UIViewController {

    var name = ""
    var avatar = ""

    @IBOutlet weak var avatarImgView: AnimatedImageView!

    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        buildUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    //MARK: Build UI
    func buildUI() {
        if name == "Mano Boo" {
            avatarImgView.image = UIImage.gifImage(name: "AnimatedAvatar")
        } else {
            if let avatarUrl = URL.init(string: avatar) {
                avatarImgView.kf.setImage(with: ImageResource.init(downloadURL: avatarUrl))
            }
        }
    }

    //MARK: Action
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
