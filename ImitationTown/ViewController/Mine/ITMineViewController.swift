//
//  ITMineViewController.swift
//  ImitationTown
//
//  Created by ManoBoo on 2017/8/7.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//

import UIKit

class ITMineViewController: ITBaseViewController {
    
    let scrollView = UIScrollView.init(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        controllerType = .Mine
        
        buildlUI()
    }
    
    
    func buildlUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.width.equalToSuperview()
        }
    }
    
    func buildPersonalInfo() {
        
    }
}
