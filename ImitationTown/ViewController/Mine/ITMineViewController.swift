//
//  ITMineViewController.swift
//  ImitationTown
//
//  Created by ManoBoo on 2017/8/7.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//

import UIKit
import RxSwift

class ITMineViewController: ITBaseViewController {
    
    let mineView = ITMineView.init(frame: .zero)

    var quietMode = false {
        didSet {
            mineView.isQuietMode = quietMode
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        controllerType = .Mine
        
        buildlUI()

        setupQuietMode()
    }
    

    func buildlUI() {
        view.addSubview(mineView)
        mineView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        mineView.clickMember = { index in
            let memberVC = ITMemberViewController()
            memberVC.name = index == 0 ? "Mano Boo" : "ZR FLower"
            memberVC.avatar = index == 0 ? "" : ZRFlowerAvatar
            self.push(to: memberVC, animated: true)
        }
    }

    func setupQuietMode() {
        Observable<Int>.interval(10.5, scheduler: MainScheduler.instance).asObservable().subscribe { [weak self] (_) in
            guard let `self` = self else { return }
            self.quietMode = !(self.quietMode)
        }.addDisposableTo(disposeBag)
    }
}
