//  Created by CodeInventor Group
//  Copyright © 2017年 ManoBoo. All rights reserved.
//  our site:  https://www.codeinventor.club

//  Function:  首页


import UIKit
import Alamofire
import HandyJSON
import RxCocoa
import RxSwift
import SVProgressHUD

class ITHomeViewController: ITBaseViewController, CIForceTouchDelegate {
    
    @IBOutlet weak var locationBtn: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var nearbyBtn: UIButton!
    
    var segmentBar : ITSegmentView!
    
    var showTableView: UITableView!
    
    var categoryView: ITHomeCategoryView!
    
    // 确定好目标控制器之后 可以再做一些操作
    var ciForceTouchCommmitClousure: ((UIViewController) -> ()) {
        get {
            return {(commitViewController) in
                self.push(to: commitViewController, animated: true)
            }
        }
    }
    
    // ForceTouch 目标控制器
    var ciForceTouchGoalViewController: ((UIViewControllerPreviewing, CGPoint) -> UIViewController?) {
        get {
            return { [unowned self] (previewingContext, location) in
                if let indexPath = self.showTableView.indexPathForRow(at: location) {
                    if let cell = self.showTableView.cellForRow(at: indexPath) {
                        let vc = ITCategoryViewController()
                        // 设置预显示VC 最大size
                        vc.preferredContentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 100)
                        // 设置ForceTouch最初尺寸
                        previewingContext.sourceRect = cell.contentView.bounds
                        return vc
                    }
                }
                return nil
            }
        }
    }
    
    // 地点集
    var venuebookModelArr: [ITHomeVenuebookModel]!
    
    // 城市故事
    var cityStoryModelArr: [ITHomeCityStoryModel]!
    
    var currentDatasource: Variable<[Any]> =  Variable([])
    
    let tableViewManager = CITableViewProtocolManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.hex(hex: 0xFAFAFA)
        controllerType = .Home
        
        categoryView = ITHomeCategoryView(frame: .zero)
        
        segmentBar = ITSegmentView(frame: .zero)
        
        adjustSearchView()
        
        buildTableView()
        
        buildCategoryPageView()
        
        setupData()
        
        handleCurrentIndex(0)
        
    
        
        // 此部分作用： 监听currentDatasource.value 的变化，发生变化，则刷新tableView
        weak var weakSelf = self
        currentDatasource.asObservable().subscribe { (_) in
            weakSelf?.showTableView.reloadData()
            }.addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        ITToolBar.share.hidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        ITToolBar.share.hidden(true, animated: animated)
        AppDelegate.share().window?.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -----------build UI--------------
    func adjustSearchView() -> Swift.Void {
        searchBar.showsScopeBar = false
        searchBar.barTintColor = UIColor.hex(hex: 0xFBE15A)
        searchBar.backgroundColor = UIColor.hex(hex: 0xFBE15A)
        searchBar.backgroundImage = UIImage()
        let searchTextField = searchBar.value(forKey: "searchField") as! UITextField
        searchTextField.backgroundColor = UIColor.hex(hex: 0xFBE15A)
        if var leftFrame = searchTextField.leftView?.frame {
            leftFrame.origin.x -= 8
            searchTextField.leftView?.frame = leftFrame
        }
        
    }
    
    func buildTableView() -> Swift.Void {
        showTableView = UITableView(frame: CGRect.zero, style: .plain)
        // delegate 可以设置为 ViewController 也可以设置为 tableViewManager
        showTableView.delegate = tableViewManager
        showTableView.register(UINib.init(nibName: "ITHomeVenuebookCell", bundle: nil), forCellReuseIdentifier: "ITHomeVenuebookCell")
        showTableView.register(UINib.init(nibName: "ITHomeCityStoryCell", bundle: nil), forCellReuseIdentifier: "ITHomeCityStoryCell")
        view.addSubview(showTableView)
        showTableView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.top.equalTo(searchBar.snp.bottom).offset(10)
            maker.bottom.equalToSuperview()
        }
        
        // tableview dataSource
        tableViewManager.sourceTableView = showTableView
        tableViewManager.ci_numberOfSections = {1}
        
        weak var weakSelf = self
        
        tableViewManager.ci_numberOfRowInSection = { _ in
            return weakSelf!.currentDatasource.value.count
        }
        tableViewManager.heightForRow = {(tableView, indexPath) in
            if weakSelf!.currentDatasource.value.first is ITHomeVenuebookModel {
                return 170
            }
            return 365
        }
        tableViewManager.ci_cellForRow = {(tableView, indexPath) in
            
            
            let model = weakSelf!.currentDatasource.value[indexPath.row]
            if model is ITHomeVenuebookModel {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ITHomeVenuebookCell") as! ITHomeVenuebookCell
                cell.indexPath = indexPath
                cell.model = model as! ITHomeVenuebookModel
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ITHomeCityStoryCell") as! ITHomeCityStoryCell
                cell.indexPath = indexPath
                cell.model = model as? ITHomeCityStoryModel
                return cell
            }
            
        }
        
        tableViewManager.didSelectRow = { [unowned self](tableView, indexPath) in
            let model = self.currentDatasource.value[indexPath.row]
            if let model = model as? ITHomeVenuebookModel {
                let venueDetailVC = ITVenueBookViewController()
                venueDetailVC.venueModel = model
                self.push(to: venueDetailVC, animated: true)
            }
        }
        
    }
    
    func buildCategoryPageView() -> Swift.Void {
        
        do {
            let dict = try ITJSONResourceManager.getJSONResources(from: Home_iconPage_filename)
            
            // 开始解析json
            let result = dict!["result"] as! Dictionary<String, Any>
            let rowsData = result["categories"] as! [Dictionary<String, Any>]
            
            
            let categoryArr =  rowsData.flatMap({ (modelData) -> ITHomeCategoryModel? in
                if let object = JSONDeserializer<ITHomeCategoryModel>.deserializeFrom(dict: modelData as NSDictionary?) {
                    
                    return object
                }else {
                    SVProgressHUD.showError(withStatus: "解析失败～")
                }
                return ITHomeCategoryModel()
            })
            
            categoryView.data.value = categoryArr
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 250))
            headerView.addSubview(categoryView)
            headerView.addSubview(segmentBar)
            showTableView.tableHeaderView = headerView
            
            categoryView.snp.makeConstraints({ (make) in
                make.width.equalToSuperview()
                make.height.equalTo(200)
                make.left.equalToSuperview()
                make.top.equalToSuperview()
            })
            weak var weakSelf = self
            categoryView.clickEvent = {(categoryCode) in
                weakSelf!.goToCategoryVC(categoryCode)
            }
            
            
            // setup ITSegmentView
            let titleArray: [String] = ["MOMENT", "VENUEBOOK"]
            segmentBar.snp.makeConstraints { (make) in
                make.top.equalTo(categoryView.snp.bottom).offset(10)
                make.width.equalToSuperview().offset(-20)
                make.left.equalToSuperview().offset(10)
                make.height.equalTo(30)
            }
            segmentBar.loadSetting(titleArray: titleArray, selectedIndex: 0) {
                (currentIndex) in
                weakSelf?.handleCurrentIndex(currentIndex)
            }
            showTableView.tableHeaderView = headerView
            
        } catch {
            SVProgressHUD.showError(withStatus: "分类解析失败，请查看文件名称是否对应～")
        }
        
    }
    
    //MARK: -------------Setup Data--------
    func setupData() -> Swift.Void {
        
        // 城市故事
        do {
            let dict = try ITJSONResourceManager.getJSONResources(from: Home_freshFabulas_filename)
            
            // 开始解析json
            let result = dict!["result"] as! Dictionary<String, Any>
            let rowsData = result["rows"] as! [Dictionary<String, Any>]
            
            
            cityStoryModelArr =  rowsData.flatMap({ (modelData) -> ITHomeCityStoryModel? in
                if let object = JSONDeserializer<ITHomeCityStoryModel>.deserializeFrom(dict: modelData as NSDictionary?) {
                    
                    return object
                }else {
                    print("解析失败")
                }
                return ITHomeCityStoryModel()
            })
        } catch  ITJSONResourceManagerError.notFindJSONFile {
            print("some error occured, 兄台，找不到该文件呐～")
        } catch ITJSONResourceManagerError.jsonAnalysisFailed {
            print("some error occured, json格式不对吧～")
        } catch {
            print("朕并不知道发生了什么～")
        }
        
        // 地点集
        do {
            let dict = try ITJSONResourceManager.getJSONResources(from: Home_venuebook_filename)
            
            // 开始解析json
            let result = dict!["result"] as! Dictionary<String, Any>
            let rowsData = result["rows"] as! [Dictionary<String, Any>]
            
            venuebookModelArr =  rowsData.flatMap({ (modelData) -> ITHomeVenuebookModel? in
                if let object = JSONDeserializer<ITHomeVenuebookModel>.deserializeFrom(dict: modelData as NSDictionary?) {
                    return object
                }else {
                    print("解析失败")
                }
                return ITHomeVenuebookModel()
            })
        } catch  ITJSONResourceManagerError.notFindJSONFile {
            print("some error occured, 兄台，找不到该文件呐～")
        } catch ITJSONResourceManagerError.jsonAnalysisFailed {
            print("some error occured, json格式不对吧～")
        } catch {
            print("朕并不知道发生了什么～")
        }
    }
    
    //MARK: --------------Action-----------
    
    //****MARK: 城市故事 <=> 地点集
    func handleCurrentIndex(_ index: Int) -> Swift.Void {
        currentDatasource.value = index == 0 ? cityStoryModelArr : venuebookModelArr
    }
    
    func goToCategoryVC(_ categoryCode: String) {
        if categoryCode != "coffee" {
            SVProgressHUD.setMinimumDismissTimeInterval(0.2)
            SVProgressHUD.showError(withStatus: "除 coffee 分类之外，其它并未抓取数据")
        }
        push(to: ITCategoryViewController(), animated: true)
    }
    
    @IBAction func changeLocalCity(_ sender: Any) {
        print("选择城市")
        let selectCityVC =  ITSelectCityViewController()
        self.push(to: selectCityVC, animated: true)
    }
    
}
