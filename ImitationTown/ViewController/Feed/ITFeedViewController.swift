//
//  ITFeedViewController.swift
//  ImitationTown
//
//  Created by jiachenmu on 2016/10/21.
//  Copyright © 2016年 ManoBoo. All rights reserved.
//  流

import UIKit
import RxSwift
import HandyJSON

class ITFeedViewController: ITBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let varable: Variable<String> = Variable("firstValue")

    
    
    let effectView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .regular))
    
    let headerView = ITFeedDynamicRecommendView()
    
    var feedView = UITableView()
    
    var feeds: Variable<[ITHomeCityStoryModel]> = Variable<[ITHomeCityStoryModel]>.init([])

    override func viewDidLoad() {
        super.viewDidLoad()

        controllerType = .Feed
        
        effectView.backgroundColor = UIColor.hex(hex: 0xE9E9E9)
        view.addSubview(effectView)
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        initFeedTableView()
        initHeaderView()
        loadLocalData()
    }
    
    func initHeaderView() -> Swift.Void {
        let recommend1 = ITFeedDynamicRecommendModel.init(user_id: 111, user_name: "ManoBoo", user_avatar: ManoBooAvatar, dynamicInfo: "ManoBoo出了新的开源项目啦")
        let recommend2 = ITFeedDynamicRecommendModel.init(user_id: 111, user_name: "ZRFlower", user_avatar: ZRFlowerAvatar, dynamicInfo: "ZRFlower出了新的开源项目啦")
        let recommend3 = ITFeedDynamicRecommendModel.init(user_id: 111, user_name: "ManoBoo1", user_avatar: "https://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83erNhRG8FibaTZbHrnuT2U8ZdkazwhzycoqenTLPQ55Andd1lWFOv4dtpuia4I0NcdSAef1UfWwwXV9w/0", dynamicInfo: "ManoBoo出了新的开源项目啦")
        let recommends = [recommend1, recommend2, recommend3]
        
        feedView.tableHeaderView = headerView
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalToSuperview()
            make.height.equalTo(47 * recommends.count)
        }
        headerView.nodes.value = recommends
        feedView.layoutIfNeeded()
    }

    func initFeedTableView() -> Swift.Void {
        feedView = UITableView.init(frame: .zero, style: .plain)
        feedView.delegate = self
        feedView.dataSource = self
        feedView.register(UINib.init(nibName: "ITHomeCityStoryCell", bundle: nil), forCellReuseIdentifier: "ITHomeCityStoryCell")
        effectView.contentView.addSubview(feedView)
        feedView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
            make.width.equalToSuperview()
        }
    }
    
    func loadLocalData() -> Swift.Void {
        feeds.asObservable()
        .subscribe(onNext: { [unowned self](_) in
            DispatchQueue.main.async {
                self.feedView.reloadData()
            }
        }, onError: { (error) in
            CIBlurHUD.default.showError(error.localizedDescription)
        }, onCompleted: nil, onDisposed: nil)
        .addDisposableTo(disposeBag)
        
        // 城市故事
        do {
            let dict = try ITJSONResourceManager.getJSONResources(from: Feed_dashboard)
            
            // 开始解析json
            let result = dict!["result"] as! Dictionary<String, Any>
            let rowsData = result["rows"] as! [Dictionary<String, Any>]
            
            
            feeds.value =  rowsData.flatMap({ (modelData) -> ITHomeCityStoryModel? in
                if let dic = modelData["data"] as? NSDictionary {
                    if let object = JSONDeserializer<ITHomeCityStoryModel>.deserializeFrom(dict: dic) {
                        return object
                    }else {
                        print("解析失败")
                    }
                }
                return ITHomeCityStoryModel()
            })
        } catch  ITJSONResourceManagerError.notFindJSONFile {
            CIBlurHUD.default.showError("some error occured, 兄台，找不到该文件呐～")
            print("some error occured, 兄台，找不到该文件呐～")
        } catch ITJSONResourceManagerError.jsonAnalysisFailed {
            print("some error occured, json格式不对吧～")
        } catch {
            print("朕并不知道发生了什么～")
        }
    }
    
    
    
    //MARK: UITableViewDelegate & DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.value.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 365
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ITHomeCityStoryCell") as! ITHomeCityStoryCell
        cell.indexPath = indexPath
        cell.model = feeds.value[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //****************************** Observable使用 *************************

    // 发送单次信号
    func rxswiftDemo(_ num: Int) -> Observable<Int> {
        let aObservable = { (number: Int) -> Observable<Int> in
            return Observable.create({ (observer) -> Disposable in
                observer.on(.next(number))
                observer.on(.completed)
                return Disposables.create()
            })
        }
        return aObservable(num)
    }
    
    // 只有观察者订阅时才会创建
    func deferredDemo(_ string: String) -> Observable<String> {
        let aObservacle = { (chatStr: String) -> Observable<String> in
            return Observable.deferred({ () -> Observable<String> in
                return Observable.create({ (observer) -> Disposable in
                    observer.onNext(string + "哈哈哈")
                    observer.onNext(string + "啦啦啦")
                    observer.onNext(string + "呵呵呵")
                    return Disposables.create()
                })
            })
        }
        return aObservacle(string)
    }
    
    // Sequence 创建 将集合转换为信号
    func sequenceDemo(_ arr: [String]) -> Swift.Void {
        Observable.from(arr).subscribe { (element) in
            print(element)
        }.addDisposableTo(disposeBag)
    }
    
    // 递增的interval定时发送信号
    func intervalDemo(_ interval: RxTimeInterval) -> Observable<Int> {
        return Observable<Int>.interval(interval, scheduler: MainScheduler.instance)
    }
    
    //****************************** Subject 使用 *************************
    
    // 类似于广播流，什么时候订阅什么时候才能收到消息
    func publishSubjectdemo() -> Swift.Void {
        let publishSubject = PublishSubject<Int>()
        publishSubject.subscribe { (event) in
            print("One" + "\(event)")
        }.addDisposableTo(disposeBag)
        publishSubject.onNext(1)
        publishSubject.onNext(2)
        
        publishSubject.subscribe { (event) in
            // 在此可以看到 这次订阅只能收到订阅后发送的消息
            print("Two" + "\(event)")
        }.addDisposableTo(disposeBag)
        publishSubject.onNext(3)
        publishSubject.onNext(4)
    }
    
    // 类似于录音机，每次订阅都可以收到以往发送的消息
    func replaySubjectDemo() -> Swift.Void {
        // 类似于创建一个大小为4个信号的缓冲池
        let replaySubject = ReplaySubject<Int>.create(bufferSize: 4)
        replaySubject.onNext(1)
        replaySubject.onNext(2)
        replaySubject.subscribe { (event) in
            print("replaySubject 1 收到： " + "\(event)")
        }.addDisposableTo(disposeBag)
        
        replaySubject.onNext(3)
        replaySubject.onNext(4)
        replaySubject.subscribe { (event) in
            print("replaySubject 2 收到： " + "\(event)")
        }.addDisposableTo(disposeBag)
    }
    
    // 默认会发送订阅前发送序列的最后一个信号  也就是 "啦啦啦"
    func behaviorSubjectDemo() -> Swift.Void {
        let bahaviorSubject = BehaviorSubject(value: "哈哈哈")
        bahaviorSubject.subscribe { (event) in
            print("behaviorSubjectDemo 1 收到： " + "\(event)")
        }.addDisposableTo(disposeBag)
        bahaviorSubject.onNext("呵呵呵")
        bahaviorSubject.onNext("啦啦啦")
        bahaviorSubject.subscribe { (event) in
            print("behaviorSubjectDemo 2 收到： " + "\(event)")
        }.addDisposableTo(disposeBag)
    }
    
    // Varable是BehaviorSubject封装的一个子类， 类似于观察者模式，订阅后，发送无限序列，信号不会因为错误终止 ，value属性发生变化，就会发送新的消息，可以用与tableViewDataSource
    func varableDemo() -> Swift.Void {
        varable.asObservable().subscribe { (event) in
            print("varableDemo 收到： " + "\(event)")
        }.addDisposableTo(disposeBag)
        
        varable.value = "哈哈哈哈哈哈哈"
    }
    
    //****************************** 序列变换 *************************
    func changeListDemo() {
        let sequence = Observable.of("1", "2", "3")
        sequence.map { (str) -> String in
            return str + " changeListDemo"
        }.subscribe { (event) in
            print(event)
        }.addDisposableTo(disposeBag)
        
        sequence.mapWithIndex { (str, index) -> String in
            return "\(index) " + str
        }.subscribe { (event) in
            print(event)
        }.addDisposableTo(disposeBag)
        
        //
        let seq1 = Observable.of(1,2,3,4,5,6)
        seq1.scan(0) { (acum, element) -> Int in
            return acum + element
        }.subscribe { (event) in
            print(event)
        }.addDisposableTo(disposeBag)
    }
    
    //****************************** 序列组合 *************************
    func combineListDemo() -> Swift.Void {
        
        // Observable.combineLastest
//        let intro1 = Observable.just(2)
//        let intro2 = Observable.of(1,2,3,4,5)
//        let intro3 = Observable.of(9,10, 11, 12, 13, 14)
//        Observable.combineLatest(intro1, intro2, intro3) {
//            "\($0) \($1) \($2)"
//        }.subscribe { (event) in
//            print(event)
//        }.addDisposableTo(disposeBag)

        
        // Subjest.combineLastest
        let intro1 = Observable.just("1 + ")
        let intro2 = ReplaySubject<Int>.create(bufferSize: 1)
        let intro3 = Observable.of("一", "二", "三")
        
        intro2.onNext(1)
    
        _ = Observable.combineLatest(intro1, intro2, intro3) {
            "\($0) \($1) \($2)"
            }.subscribe{
                print($0)
        }
        
        intro2.onNext(2)
            /*
             next(1 +  1 一)
             next(1 +  1 二)
             next(1 +  1 三)
             next(1 +  2 三)
             */
        
        // merge 操作
        let merge1 = PublishSubject<String>()
        let merge2 = PublishSubject<String>()
        Observable.of(merge1, merge2).merge().subscribe {
            print($0)
        }.addDisposableTo(disposeBag)
        
        merge1.onNext("1")
        merge2.onNext("一")
        merge1.onNext("2")
        merge2.onNext("二")
    }
    
    
    
    
}
