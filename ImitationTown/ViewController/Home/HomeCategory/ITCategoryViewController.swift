//
//  ITCategoryViewController.swift
//  ImitationTown
//
//  Created by ManoBoo on 17/2/14.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  小组网站:https://www.codeinventor.club
//  简书网址:http://www.jianshu.com/c/d705110de6e0
//  项目网址:https://github.com/CodeInventorGroup/Imitation-Town
//  欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问
//

import UIKit
import Alamofire
import RxSwift
import HandyJSON
import SVProgressHUD

class ITCategoryViewController: ITBaseViewController {

    @IBOutlet weak var navBackbutton: UIButton!
    
    var showTableView: UITableView!
    
    var datasource: Variable<[ITHomeCategoryResultModel]> = Variable([])
    
    let tableViewManager = CITableViewProtocolManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 开启自定义导航滑动动画 科普一下。 M_PI_2  是 90 度 ，😅
        if let nav = navigationController as? ITNavigationViewController {
            weak var weakSelf = self
            nav.isOnCustomAnimation = true
            nav.swipeAnimation = { offsetX in
                if offsetX <= SCREEN_WIDTH/2 {
                    let rotationAngle = -offsetX * 2 / SCREEN_WIDTH * CGFloat(Double.pi / 2)
                    weakSelf?.navBackbutton.transform = CGAffineTransform(rotationAngle: rotationAngle)
                }
            }
        }
        SVProgressHUD.show(withStatus: "Loading...")
        buildUI()
        setupData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navBackbutton.transform = CGAffineTransform.identity
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Build UI
    
    func buildUI() -> Swift.Void {
        showTableView = UITableView.init(frame: .zero, style: .plain)
        showTableView.delegate = tableViewManager
        showTableView.separatorStyle = .none
        showTableView.register(UINib.init(nibName: "ITCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ITCategoryTableViewCell")
        view.addSubview(showTableView)
        view.sendSubview(toBack: showTableView)
        showTableView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        showTableView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
        tableViewManager.sourceTableView = showTableView
        
        weak var weakSelf = self
        tableViewManager.heightForRow = {_,_ in 194}
        tableViewManager.ci_numberOfSections = { weakSelf!.datasource.value.count }
         tableViewManager.ci_numberOfRowInSection = { _ in 1 }
        tableViewManager.ci_cellForRow = {(tableView, indexPath) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ITCategoryTableViewCell") as! ITCategoryTableViewCell
            cell.indexPath = indexPath
            if let model = weakSelf?.datasource.value[indexPath.section] {
                cell.model.value = model
            }
            return cell
        }
        
        datasource.asObservable().subscribe { (event) in
            weakSelf?.showTableView.reloadData()
        }.addDisposableTo(disposeBag)
    }
    
    //MARK: setup Data
    
    func setupData() -> Swift.Void {
        do {
            let dict = try ITJSONResourceManager.getJSONResources(from: Home_category_coffee_filename)
            let result = dict!["result"] as! Dictionary<String, Any>
            let rowsData = result["rows"] as! [Dictionary<String, Any>]
            datasource.value = rowsData.flatMap({ (modelData) -> ITHomeCategoryResultModel? in
                if let object = JSONDeserializer<ITHomeCategoryResultModel>.deserializeFrom(dict: modelData as NSDictionary?) {
                    return object
                }else {
                    print("解析失败")
                }
                return ITHomeCategoryResultModel()
            })
            SVProgressHUD.dismiss()
            
        } catch  {
            SVProgressHUD.showError(withStatus: "JSON解析错误，请检查json是否合法")
        }
    }
    
    //MARK: Delegate
    
        
    //MARK: Action
    
    @IBAction func backNav(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func selectCategory(_ sender: Any) {
        
    }
    
    @IBAction func lookVenueAtMap(_ sender: Any) {

    }
    @IBAction func venueSort(_ sender: Any) {
        
    }
    
    

}
