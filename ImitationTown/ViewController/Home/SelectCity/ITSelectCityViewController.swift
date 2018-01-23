//  ITSelectCityViewController.swift
//  Created by ManoBoo on 2017/2/27.

import UIKit
import SnapKit
import RxSwift
import HandyJSON

class ITSelectCityViewController: ITBaseViewController {
    
    
    var selectCityClousure: ((String) -> ())?

    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var navBackbutton: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var segmentBar: ITSegmentView!
    
    var showTableView: UITableView!
    
    // 大洲分类
    var continentArr: [[CountryModel]] = [[]]
    // 国家分类
    var regionArrSortByContinent: [[[RegionModel]]] = [[]]
    
    var datasource: Variable<[CountryModel]> = Variable([CountryModel()])
    var citySource: Variable<[[RegionModel]]> = Variable([[]])
    
    let tableViewManager = CITableViewProtocolManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        buildUI()
        
        setupData()
        
        CIBlurHUD.default.show("拼命请求中。。。", type: .loading, style: .dark, InOutAnimation: .FadeInOut(0.3), layout: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            CIBlurHUD.default.showError("发生了不为人知的py交易")
            self.handelSegmentIndex(0)
        }
        
        Observable.combineLatest(datasource.asObservable(), citySource.asObservable()) { (_, _) -> AnyObject? in
            return nil
        }.subscribe { [unowned self] (event) in
            if !event.isStopEvent {
                self.showTableView.reloadData()
            }
        }.addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navBackbutton.transform = CGAffineTransform.identity
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ************* Build UI *************
    func buildUI() -> Swift.Void {
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
        
        segmentBar = ITSegmentView()
        view.addSubview(segmentBar)
        segmentBar.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-20)
            make.top.equalTo(navView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.height.equalTo(30)
        }
        segmentBar.loadSetting(titleArray: ["ASIA", "EUROPE", "AMERICA", "MORE"], selectedIndex: 0) {[unowned self] index in
            self.handelSegmentIndex(index)
        }
        
        showTableView = UITableView(frame: .zero, style: .plain)
        showTableView.delegate = tableViewManager
        showTableView.register(ITSelectCityCell.self, forCellReuseIdentifier: "ITSelectCityCell")
        view.addSubview(showTableView)
        showTableView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.left.equalTo(0)
            make.top.equalTo(segmentBar.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
        tableViewManager.sourceTableView = showTableView
        
        tableViewManager.heightForRow = {_,_ in UITableViewAutomaticDimension }
        tableViewManager.ci_numberOfSections = { 1 }
        tableViewManager.ci_numberOfRowInSection = { [unowned self] _ in
            self.datasource.value.count
        }
        tableViewManager.ci_cellForRow = { [unowned self] tableView, indexPath in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ITSelectCityCell") as! ITSelectCityCell
            cell.country.value = self.datasource.value[indexPath.row]
            cell.citys.value = self.citySource.value[indexPath.row]
            return cell
        }
        
    }
    
    //MARK: ************* setup Data *************
    func setupData() -> Swift.Void {
        do {
            let dict = try ITJSONResourceManager.getJSONResources(from: Home_selectCity_filename)
            let result = dict!["result"] as! Dictionary<String, Any>
            let regionsData = result["regions"] as! [Dictionary<String, Any>]
            let countriesData = result["countries"] as! [Dictionary<String, Any>]
            
            let regions = regionsData.flatMap({ (modelData) -> RegionModel? in
                if let object = JSONDeserializer<RegionModel>.deserializeFrom(dict: modelData as NSDictionary?) {
                    return object
                }else {
                    print("解析失败")
                }
                return RegionModel()
            })
            
            let countries = countriesData.flatMap({ (modelData) -> CountryModel? in
                if let object = JSONDeserializer<CountryModel>.deserializeFrom(dict: modelData as NSDictionary?) {
                    return object
                }else {
                    print("解析失败")
                }
                return CountryModel()
            })
            
            // 亚洲国家
            var AsiaArr: [CountryModel] = []
            // 欧洲国家
            var EuropeArr: [CountryModel] = []
            // 美洲国家
            var AmericaArr: [CountryModel] = []
            // 其他地区
            var MoreArr: [CountryModel] = []
            
            _ = countries.flatMap({ (country) -> CountryModel? in
                if let continentCode = country.continentCode {
                    
                    switch continentCode {
                    case "Asia":
                        AsiaArr.append(country)
                        break
                    case "Europe":
                        EuropeArr.append(country)
                        break
                    case "America":
                        AmericaArr.append(country)
                        break
                    default:
                        MoreArr.append(country)
                        break
                    }
                }
                return nil
            })
            
            continentArr.removeAll()
            continentArr.append(contentsOf: [AsiaArr, EuropeArr, AmericaArr, MoreArr])
            regionsSort(with: regions)
            
        } catch (let error) {
            CIBlurHUD.default.showError(error.localizedDescription)
        }
    }
    
    // 将 `Region` 按 `countryCode` 分类处理
    func regionsSort(with regions: [RegionModel]) -> Swift.Void {
        regionArrSortByContinent.removeAll()
        for continent in continentArr {
            var regionsArr = continent.flatMap({ (country) -> [RegionModel]? in
                
                guard let countryCode = country.code else{
                    return nil
                }
                
                return regions.flatMap({ (region) -> RegionModel? in
                    if region.countryCode == countryCode {
                        return region
                    }
                    return nil
                })
            })
            
            // 按城市数量 对 国家进行排列
            regionsArr = regionsArr.sorted(by: { (region1, region2) -> Bool in
                return region1.count > region2.count
            })
            regionArrSortByContinent.append(regionsArr)
        }
        
    }
    
    //MARK: ************* Action *************
    
    @IBAction func navBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectLocation(_ sender: Any) {
        if let selectCityClousure = selectCityClousure, let currentCity = (sender as? UIButton)?.currentTitle {
            selectCityClousure(currentCity)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handelSegmentIndex(_ index: Int) -> Swift.Void {
        datasource.value = continentArr[index]
        citySource.value = regionArrSortByContinent[index]
    }
}
