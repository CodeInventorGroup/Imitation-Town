//
//  ITMessageViewController.swift
//  ImitationTown
//  欢迎去https://www.manoboo.com看看最新的文章
//  Created by ManoBoo on 2017/8/7.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  www.codeinventor.club CodeInventor小组的文章会发表到这里

import UIKit
import SnapKit
import RxSwift

/** 该Message控制器中没有数据，所以按照想象做了,MessageController可能会使用一个长链接，就用一个定时器模拟长链接吧😀😀😀
 *
 */
struct ITMessageFeedModel {
    var user_id: String?
    var user_avatar = ManoBooAvatar
    var user_name = "manoboo"
    var user_introduce = "ManoBoo是一个iOS开源爱好者"
    var message: String? = "如果您觉得该项目不错的话，可以到Github上给个Star咯★★★★★★★★★★★★★"
    
    static func randomMessage() -> String {
        let index = Int(arc4random_uniform(UInt32(messageResources.count-1)))
        return messageResources[index]
    }
    
    static func randomFeed() -> ITMessageFeedModel {
        let factor = (arc4random_uniform(3) > 1)
        return ITMessageFeedModel.init(user_id: factor ? "manoboo" : "zrflower",
                                       user_avatar: factor ? ManoBooAvatar : ZRFlowerAvatar,
                                       user_name: factor ? "manoboo" : "zrflower",
                                       user_introduce: factor ? "ManoBoo是一个iOS开源爱好者" : "ZRFlower是涛涛",
                                       message: randomMessage())
    }
}

let messageResources = ["欢迎查看我们的项目, <Imitation Town>, 本项目用到了 RxSwift的一些知识",
                        "项目已经托管到Github和Coding.net上,有任何问题可以简书私信 ManoBoo 或者 NEWWORLD",
                        "我们是一个热爱开源的小组, 可以关注我们的新框架,CIKit,啦啦啦啦,😄😄😄😄😄😄😄😄😄😄😄",
                        "我们的CIComponentKit框架正在完成中~,欢迎关注",
                        "李杜诗篇万口传,\n至今已觉不新鲜.\n江山代有才人出,\n各领风骚数百年.\n 五花马,千金裘.\n呼儿将出换美酒,与尔同销万古愁",
                        "Hello,我是ManoBoo,这是我们的新项目,因为工作原因,项目持续时间太长,没想到Town的开发方Augumn公司 GG了,这是个悲伤的故事",
                        "我记得那美妙的一瞬，\n在我的面前出现了你，\n有如昙花一现的幻影，\n有如纯洁之美的精灵。\n在无望的忧愁的折磨中，\n在喧闹的虚幻的困扰中，\n我的耳边长久地\n响着你温柔的声音，\n我还在睡梦中见到你可爱的面容。",
                        ""]

class ITMessageViewController: ITBaseViewController {
    
    let effectView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .light))
    
    let tableView = UITableView.init(frame: .zero, style: .plain)
    
    var index: Int = 0
    var messageFeeds = Variable<[ITMessageFeedModel]>.init([ITMessageFeedModel.randomFeed()])
  
    // 刷新的间隔
    var refresh_interval: TimeInterval = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerType = .Message
        effectView.backgroundColor = UIColor.hex(hex: 0x5CC9F5, alpha: 0.7)
        view.addSubview(effectView)
        effectView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        setupUI()
        
        getMessageFeed()
        
        bindMessageData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() -> Swift.Void {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.backgroundColor = UIColor.hex(hex: 0xF7F6F6)
        tableView.register(UINib.init(nibName: "ITMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "ITMessageTableViewCell")
        tableView.separatorStyle = .none
        effectView.contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    func getMessageFeed() -> Swift.Void {
        // 用定时器模拟 长链接
        Observable<Int>.interval(refresh_interval, scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] (index) in
//            print(index)
            self?.index = index
            
            self?.messageFeeds.value.append(ITMessageFeedModel.randomFeed())
            }, onError: { (error) in
                CIBlurHUD.default.showError(error.localizedDescription)
        }, onCompleted: {
          
        }, onDisposed: nil).addDisposableTo(disposeBag)
    }
    
    func bindMessageData() -> Swift.Void {
        messageFeeds.asObservable().throttle(1.0, scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] (message) in
            DispatchQueue.main.async {
                if (self.index != 0) {
//                    self.tableView.beginUpdates()
//                    self.tableView.insertRows(at: [IndexPath.init(row: self.index, section: 0)], with: .none)
//                    self.tableView.endUpdates()
                    self.tableView.reloadData()
//                    self.tableView.scrollToRow(at: IndexPath.init(row: self.index-1, section: 0), at: .bottom, animated: true)
                }
            }
        }, onError: { (err) in
            CIBlurHUD.default.showError(err.localizedDescription)
        }, onCompleted: { 
            print("ITMessageViewController get feed in time...")
        }, onDisposed: nil).addDisposableTo(disposeBag)
    }

}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension ITMessageViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return index + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ITMessageTableViewCell") as! ITMessageTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ITMessageTableViewCell {
            cell.messageNode = self.messageFeeds.value[indexPath.row]
        }
    }
}

