//
//  ITSearchViewController.swift
//  ImitationTown
//
//  Created by NEWWORLD on 2016/10/18.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//

import UIKit
import RxSwift
import HandyJSON
import SVProgressHUD
import Kingfisher

class ITSearchViewController: ITBaseViewController, UIScrollViewDelegate {

    var hotSearchView: ITHotSearchView!
    var segmentView: ITSegmentView!

    var currentData: Variable<[Any]> = Variable([])
    // 故事
    var storyData: [ITSearchStoryModel]!
    // 地点集
    var venubookData: [ITSearchVenubookModel]!
    // 人物
    var userData: [ITSearchUserModel]!
    
    var currentTableView: UITableView!
    
    let tableViewManager = CITableViewProtocolManager()
    //  当前选中位置
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ci_rgb(red: 251, green: 251, blue: 251)
        controllerType = .Explore
        
        buildHotSearchListView()
        buildSearchView()
        buildTableView()
        buildTableHeaderView()
        loadData()
        handleCurrentIndex(0)
        
        // 此部分作用： 监听currentDatasource.value 的变化，发生变化，则刷新tableView
        weak var weakSelf = self
        currentData.asObservable().subscribe { (_) in
            weakSelf?.currentTableView.reloadData()
            }.addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ITToolBar.share.hidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func buildHotSearchListView() {
        
        do {
            let dict = try ITJSONResourceManager.getJSONResources(from: Search_HothashTag_filename)
            let hotSearchArray = dict!["result"] as! [String]
            hotSearchView = ITHotSearchView.hotSearchView(frame: .zero, hotSearchArray:hotSearchArray)
        } catch {
            SVProgressHUD.showError(withStatus: "分类解析失败，请查看文件名称是否对应～")
        }
    }
    
    func loadData() {
        // 故事
        do {
            let jsonString = try ITJSONResourceManager.getRowsJSONStringFromFilePath(jsonFilePath: Search_Fabulas_filename)
            if let object = JSONDeserializer<ITSearchStoryModel>.deserializeModelArrayFrom(json: jsonString) as! [ITSearchStoryModel]! {
                storyData = object
            }else {
                print("解析失败~")
            }
        } catch {
            print("解析失败~")
        }
        
        // 地点集
        do {
            let jsonString = try ITJSONResourceManager.getRowsJSONStringFromFilePath(jsonFilePath: Search_Venuebook_filename)
            if let object = JSONDeserializer<ITSearchVenubookModel>.deserializeModelArrayFrom(json: jsonString) as! [ITSearchVenubookModel]! {
                venubookData = object
            }else {
                print("解析失败~")
            }
        } catch  {
            print("解析失败~")
        }
        
        // 人物
        do {
            let jsonString = try ITJSONResourceManager.getRowsJSONStringFromFilePath(jsonFilePath: Search_Users_filename)
            if let object = JSONDeserializer<ITSearchUserModel>.deserializeModelArrayFrom(json: jsonString) as! [ITSearchUserModel]! {
                userData = object
            }else {
                print("解析失败~")
            }
        } catch  {
            print("解析失败~")
        }
    }
    
    private func buildSearchView() {
        let titleArray: [String] = ["故事", "地点集", "人物"]
        weak var weakSelf = self
        segmentView = ITSegmentView.townSegmentView(frame: .zero, titleArray: titleArray, selectedIndex: 0) { (currentIndex) in
            weakSelf?.handleCurrentIndex(currentIndex)
        }
    }
    
    func buildTableHeaderView() {
        
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: hotSearchView.heightOfHotSearchView + 30 + 10))
        tableHeaderView.addSubview(hotSearchView)
        hotSearchView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(hotSearchView.heightOfHotSearchView)
        }
        
        tableHeaderView.addSubview(segmentView)
        segmentView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(hotSearchView.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        currentTableView.tableHeaderView = tableHeaderView
    }
    
    func buildTableView() {
        currentTableView = UITableView(frame: .zero, style: .plain)
        currentTableView.backgroundColor = UIColor.ci_rgb(red: 251, green: 251, blue: 251)
        currentTableView.delegate = tableViewManager
        currentTableView.register(UINib.init(nibName: "ITSearchStoryCell", bundle: nil), forCellReuseIdentifier: "ITSearchStoryCell")
        currentTableView.register(UINib.init(nibName: "ITSearchVenueBookCell", bundle: nil), forCellReuseIdentifier: "ITSearchVenueBookCell")
        currentTableView.register(UINib.init(nibName: "ITSearchUserCell", bundle: nil), forCellReuseIdentifier: "ITSearchUserCell")
        view.addSubview(currentTableView)
        currentTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.right.bottom.equalToSuperview()
        }
        
        weak var weakSelf = self
        //TableView DataSource
        tableViewManager.sourceTableView = currentTableView
        tableViewManager.ci_numberOfSections = {1}
        tableViewManager.ci_numberOfRowInSection = { ( _ ) in
            return weakSelf!.currentData.value.count
        }
        
        tableViewManager.heightForRow = {(tableView, indexPath) in
            if weakSelf?.currentData.value.first is ITSearchVenubookModel {
                return 162
            }
            return 320
        }
        
        tableViewManager.ci_cellForRow = {(tableview, indexPath) in
            let data = weakSelf!.currentData.value[indexPath.row]
            if data is ITSearchStoryModel {
                let cell = tableview.dequeueReusableCell(withIdentifier: "ITSearchStoryCell") as! ITSearchStoryCell
                cell.indexPath = indexPath
                cell.searchStory = data as! ITSearchStoryModel
                return cell
            } else if data is ITSearchVenubookModel {
                let cell = tableview.dequeueReusableCell(withIdentifier: "ITSearchVenueBookCell") as! ITSearchVenueBookCell
                cell.indexPath = indexPath
                cell.venueBook = data as? ITSearchVenubookModel
                return cell
            }
            let cell = tableview.dequeueReusableCell(withIdentifier: "ITSearchUserCell") as! ITSearchUserCell
            cell.indexPath = indexPath
            cell.searchUser = data as? ITSearchUserModel
            return cell
        }
        
        tableViewManager.didSelectRow = {(tableView, indexPath) in
            print("current indexpath is \(indexPath)")
            
            if weakSelf?.currentIndex == 0 {
                let momentStoryDetailController = ITMomentStoryDetailViewController()
                momentStoryDetailController.storyData = weakSelf?.currentData.value[indexPath.row]
                weakSelf?.push(to: momentStoryDetailController, animated: true)
            }else {
                let mapViewController = ITMapViewController()
                mapViewController.addressName = "BeiJing"
                mapViewController.pointCoordinate = CLLocationCoordinate2DMake(39.9442988693, 116.4815218486)
                weakSelf?.push(to: mapViewController, animated: true)
            }
        }
    }
    
    //  处理选中segment某个标题时的事件
    func handleCurrentIndex(_ selectedIndex: Int) {
        currentIndex = selectedIndex
        switch selectedIndex {
        case 1:
            currentData.value = venubookData
        case 2:
            currentData.value = userData
        default:
            currentData.value = storyData
        }
    }
}
