//
//  ITMemberViewController.swift
//  ImitationTown
//
//  Created by ManoBoo on 2018/1/22.
//  Copyright © 2018年 CodeInventor Group. All rights reserved.
//

import UIKit

class ITMemberViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ITToolBar.share.hidden(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
