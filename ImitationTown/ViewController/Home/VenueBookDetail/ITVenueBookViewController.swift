//
//  ITVenueBookViewController.swift
//  ImitationTown
//
//  Created by ManoBoo on 2017/3/15.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  注意：数据来源从已存json资源中 随机获取

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import HandyJSON

class ITVenueBookViewController: ITBaseViewController {
    
    @IBOutlet weak var navButton: UIButton!

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    var showTableView: UITableView!
    
    var tableviewManager = CITableViewProtocolManager()
    
    var datasource: Variable<[VenuebookDetailModel]> = Variable([])
    
    var venueModel: ITHomeVenuebookModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let nav = navigationController as? ITNavigationViewController {
            weak var weakSelf = self
            nav.isOnCustomAnimation = true
            nav.swipeAnimation = { offsetX in
                if offsetX <= SCREEN_WIDTH/2 {
                    let rotationAngle = -offsetX * 2 / SCREEN_WIDTH * CGFloat(Double.pi / 2)
                    weakSelf?.navButton.transform = CGAffineTransform(rotationAngle: rotationAngle)
                }
            }
        }
        navButton.rx.tap.subscribe({ [unowned self] (event) in
            _ = self.navigationController?.popViewController(animated: true)
        }).addDisposableTo(disposeBag)
        
        buildTableView()
        
        datasource.asObservable().subscribe { _ in
                DispatchQueue.main.async {
                    self.showTableView.reloadData()
                }
            }.addDisposableTo(disposeBag)
        
        setupData()
        
        addAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navButton.transform = .identity
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: **************** Build UI ****************
    
    func buildTableView() -> Swift.Void {
        showTableView = UITableView(frame: .zero, style: .plain)
        showTableView.register(UINib.init(nibName: "ITVenuebookDetailCell", bundle: nil), forCellReuseIdentifier: "ITVenuebookDetailCell")
        showTableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        showTableView.tableFooterView = nil
        view.addSubview(showTableView)
        view.sendSubview(toBack: showTableView)
        showTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
            make.width.equalToSuperview()
        }
        showTableView.delegate = tableviewManager
        tableviewManager.sourceTableView = showTableView
        
        tableviewManager.ci_cellForRow = { [unowned self] (tableView, indexPath) in
            let model = self.datasource.value[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ITVenuebookDetailCell") as! ITVenuebookDetailCell
            cell.indexPath = indexPath
            cell.model.value = model
            return cell
        }
        tableviewManager.ci_numberOfRowInSection = { _ in self.datasource.value.count }
        tableviewManager.heightForRow = {_,_ in UITableViewAutomaticDimension }
        
        if let headerView = UINib.init(nibName: "ITVenueHeaderView", bundle: nil).instantiate(withOwner: self, options: nil).last as? ITVenueHeaderView {
            headerView.mapClickEvent = {
                print("look venuebook's location")
            }
            if let venue = venueModel?.venuebook {
                headerView.model.value = venue
            }
            showTableView.tableHeaderView = headerView
        }
    }
    
    func addAction() -> Swift.Void {
        moreButton.rx.controlEvent(.touchUpInside).subscribe { _ in
            let cancelAction = UIAlertAction.ciAction(title: "Cancel", style: .cancel, handler: nil)
            let lookDetailAction = UIAlertAction.ciAction(title: "查看Venue详情", style: .default, handler: { [unowned self] (_) in
                if let venueID = self.venueModel?.venuebook?.id {
                    let url = "https://town.augmn.cn/venuebook/\(venueID)"
                    let webVC = ITWebViewController()
                    webVC.url = url
                    self.navigationController?.pushViewController(webVC, animated: true)
                }
            })
            let aboutManoBoo = UIAlertAction.ciAction(title: "关于ManoBoo", style: .default, handler: { (_) in
                print("aboutManoBoo")
                UIApplication.shared.open(URL(string: ManoBooWeiBo)!, options: [:], completionHandler: nil)
            })
            let ManoBooJianShu = UIAlertAction.ciAction(title: "ManoBoo的简书", style: .default, handler: { (_) in
                UIApplication.shared.open(URL(string: ManoBooJianShu_OPENURL)!, options: [:], completionHandler: nil)
            })
            let lookProject = UIAlertAction.ciAction(title: "去我们的Github", style: .default, handler: { (_) in
                print("lookProject")
                UIApplication.shared.open(URL(string: ProjectGithub)!, options: [:], completionHandler: nil)
            })
            let alertVC = UIAlertController.alertViewController(with: "More", message: "查看更多～", preferredStyle: .actionSheet, alertActions: [lookDetailAction, aboutManoBoo, ManoBooJianShu, lookProject, cancelAction])
            self.present(alertVC, animated: true, completion: nil)
        }.addDisposableTo(disposeBag)
        shareButton.rx.controlEvent(.touchUpInside).subscribe { [unowned self] _ in
            self.share(.Default)
        }.addDisposableTo(disposeBag)
    }
    
    //MARK: ************** setup data *******************
    
    func setupData() -> Swift.Void {
        do {
            let resourceArr: [String] = [Home_venue_coffee1_filename,
                               Home_venue_coffee2_filename,
                               Home_venue_building_filename,
                               Home_venue_vintage_file,
                               Home_venue_food_filename,
                               Home_venue_sanlitun_filename]
            // 随机取出一个json资源
            let index = Int(arc4random() % 5)
            
            let dict = try ITJSONResourceManager.getJSONResources(from: resourceArr[index])
            let result = dict!["result"] as! Dictionary<String, Any>
            let rowsData = result["rows"] as! [Dictionary<String, Any>]
            datasource.value = rowsData.flatMap({ (modelData) -> VenuebookDetailModel? in
                if let object = JSONDeserializer<VenuebookDetailModel>.deserializeFrom(dict: modelData as NSDictionary?) {
                    return object
                }else {
                    print("解析失败")
                }
                return VenuebookDetailModel()
            })
            
            
        } catch  {
//            SVProgressHUD.showError(withStatus: "JSON解析错误，请检查json是否合法")
        }
    }

}
