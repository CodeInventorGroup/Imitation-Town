//
//  UIImageView+Extension.swift
//  ImitationTown
//
//  Created by ManoBoo on 17/2/10.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//  小组网站:https://www.codeinventor.club
//  简书网址:http://www.jianshu.com/c/d705110de6e0
//  项目网址:https://github.com/CodeInventorGroup/Imitation-Town
//  欢迎在github上提issue，也可向 codeinventor@foxmail.com 发送邮件询问
//

import UIKit
import Foundation

// 是否打印Debug消息
let CIImageViewExtensionDebug = false

extension UIImageView {
    func clipToCircle(_ cornderRadius: CGFloat) -> Swift.Void {
        if let image = self.image {
            self.image = image.adjust(cornerRadius: cornderRadius)
        }
    }
}

//MARK: ********************************************* CIImageProtocol ************************************************************


public final class CIImageKit<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
    private var CIImageKitWebUrlKey: Void?
    
    func setURL(_ url: URL) -> Swift.Void {
        objc_setAssociatedObject(self, &CIImageKitWebUrlKey, url, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public var url: URL? {
        return objc_getAssociatedObject(self, &CIImageKitWebUrlKey) as? URL
    }

}


public protocol CIImageDownloaderProtocol {
    associatedtype type
    var ci: type { get }
}

public extension CIImageDownloaderProtocol {
    public var ci: CIImageKit<Self> {
        get {
            return CIImageKit(self)
        }
    }
}


protocol CIDataConvertible {
    associatedtype Result
    static func convertFromData(data: Data!) -> (Result?, Error?)
}

public var DownloadTaskArr = Set<URL>.init()

class CIDownloadRequest<T: CIDataConvertible> {
    var url: URL?
    init(url: URL?) {
        self.url = url
    }
    deinit {
        if CIImageViewExtensionDebug {
            print("dealloc")
        }
    }
    func download(_ completionHandler: @escaping (T.Result?, Error?) -> ()) -> Swift.Void {
        guard let url = url else {
            if CIImageViewExtensionDebug {
                print("image url is not valid")
            }
            return
        }
    
      
      if DownloadTaskArr.contains(url) {
        return
      }else {
        DownloadTaskArr.insert(url)
      }
      let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
          if error == nil {
              if let data = data {
                  let (result, error) = T.convertFromData(data: data)
                  if T.Result.self == UIImage.self {
                      
                  }
                    if let res = response as? HTTPURLResponse {
                        if let lastModified = res.allHeaderFields["Last-Modified"] {
                            print(lastModified)
                        }
                        
                    }
                  // 下载完成
                  completionHandler(result, error)
              }
          }else {
            
          }
      }
      task.resume()
    }
}

extension UIImage: CIImageDownloaderProtocol, CIDataConvertible {
    typealias Result = UIImage
    internal static func convertFromData(data: Data!) -> (UIImage?, Error?) {
        return (UIImage(data: data), nil)
    }
}
extension UIImageView: CIImageDownloaderProtocol {}
//extension UIButton: CIImageDownloaderProtocol {}

//MARK: ImageCache
open class CIImageCache: NSObject {
    
    public static let `default` = CIImageCache.init()
    private override init() {
         super.init()
        NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationDidReceiveMemoryWarning, object: nil, queue: OperationQueue.main) { [unowned self] (notification) in
            self.memoryCache.removeAllObjects()
            DownloadTaskArr.removeAll()
        }
//        NotificationCenter.default.addObserver(self, forKeyPath: "memoryCache", options: [.new, .old], context: nil)
//        NotificationCenter.default.addObserver(memoryCache, selector: <#T##Selector#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
    }

    public enum CIImageCacheCase {
        case disk
        case memoryCache
    }
    
    // 设置第一缓存方式，默认为内存
    public static var cacheCase: CIImageCacheCase = .memoryCache
    
    private let memoryCache = NSCache<NSURL, UIImage>()

    var maxMemoryCost: UInt = 0 {
        didSet {
            memoryCache.totalCostLimit = Int(maxMemoryCost)
        }
    }
    
    var maxDiskCache: UInt = 0 {
        didSet {
            
        }
    }
    
    // 保存到内存中
    func save(_ imageData: Data, key: URL) -> Swift.Void {
        
//        memoryCache.setObject(imageData as NSData, forKey: key as NSURL)
        memoryCache.setObject(UIImage(data: imageData)!, forKey: key as NSURL)
    }
    
    // 从内存中获取
//    func get(from key: URL) -> Data? {
//        if let imageData = memoryCache.object(forKey: key as NSURL) {
//            return imageData as Data
//        }
//        return nil
//    }
    
    func get(from key: URL) -> UIImage? {
        if let image = memoryCache.object(forKey: key as NSURL) {
            return image
        }
        return nil
    }
    
    // 设置硬盘图片缓存路径
    public static let cachePath = (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last)! as NSString
    public static let ciImageCachepath = cachePath.appendingPathComponent("codeinventor.club.ciImageCache")
    private static var isExistCachePath = false
    
    private static func configure() -> Swift.Void {
        if !isExistCachePath {
            // 缓存目录已经创建
            let url = URL.init(fileURLWithPath: ciImageCachepath)
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: ["desc": "details: created by CIImageKit"])
                if FileManager.default.fileExists(atPath: ciImageCachepath) {
                    isExistCachePath = true
                }
            } catch (let error) {
                print("create CachePath failed!")
                print(error)
            }
        }
    }
    
    // 保存到本地
    public static func saveToDisk(atPath imagePath: String, contents imageData: Data, attributes desc: [String: Any]? = nil) throws -> () {
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: imagePath) {
            return
        }else {
            configure()
            try imageData.write(to: URL.init(fileURLWithPath: imagePath), options: .atomic)
        }
    
    }
}



public typealias cicompleteHandler = ((_ image: UIImage?, _ error: NSError?,  _ imageURL: URL?) -> ())

public enum CIImagePlaceHolder {
    case color(UIColor?)
    case image(UIImage?)
    case other
}

// MARK: extension CIImageKit where Base: UIImageView
extension CIImageKit where Base: UIImageView {
    
    public func setImage(with url: URL?, placeHolder: CIImagePlaceHolder? = nil, imageOperation: [CIImageOperation]? = nil,completionHandler: cicompleteHandler? = nil ) -> Swift.Void {
        if let placeHolder = placeHolder {
            switch placeHolder {
            case .color(let color):
                base.backgroundColor = color
                break
            case .image(let image) :
                base.image = image
                break
            default:
                break
            }
        }
        guard let url = url else {
            completionHandler?(nil, nil, nil)
            return
        }
        // 关联key
        if self.url == nil {
            setURL(url)
        }
        // 异步请执行任务
        DispatchQueue.global().async {
            // 用url的hashValue 作为 key
            let imagePath = CIImageCache.ciImageCachepath.appending("/\(url.hashValue).imgTemp")
            let fileManager = FileManager.default
            
            // 优先从内存中读取
            if let memoryData = CIImageCache.default.get(from: url) {
                let image = memoryData
                DispatchQueue.main.async {
                    self.base.image = image
                    completionHandler?(image, nil, self.url)
                }
            }
            // 内存中没有 检查磁盘中是否存在
            else if let diskCacheData =  fileManager.contents(atPath: imagePath) {
                DispatchQueue.main.async {
                    self.base.image = UIImage.init(data: diskCacheData)
                }
                CIImageCache.default.save(diskCacheData, key: self.url!)
            }
            else {
                
                CIDownloadRequest<UIImage>(url: url).download { (image, error) in
                    //
                  
                    if let image = image {
                        print("获取到图片数据")
                        let (handledImage, data) = image.handleImage(operations: imageOperation)
                        DispatchQueue.main.async {
                            self.base.image = handledImage
                            completionHandler?(handledImage, nil, self.url)
                        }
                        if let data = data {
                            CIImageCache.default.save(data, key: self.url!)
                            // 存到DiskCache中
                            do {
                                try CIImageCache.saveToDisk(atPath: imagePath, contents: data, attributes: ["desc": "CIImageKit - \(url.hashValue)"])
                            } catch (let error) {
                                print(error)
                            }
                        }
                    }else {
                        if CIImageViewExtensionDebug { print("image response is nil") }
                    }
                }
            }
        }
        
    }
    
}

// MARK: extension CIImageKit where Base: UIButton
extension CIImageKit where Base: UIButton {
    
    @discardableResult
    private func imageDataFetchSuccess(_ data: Data, imageOperation: [CIImageOperation]? = nil,completionHandler: cicompleteHandler? = nil) -> (UIImage?, Data?)? {
        var result = UIImage(data: data)
        var resultData = data
        if let (handledImage, data) = result?.handleImage(operations: imageOperation) {
            result = handledImage
            resultData = data!
        }
        // 回到主线程刷新UI
        DispatchQueue.main.async {
            
            completionHandler?(result, nil, self.url)
        }
        return (result, resultData)
    }


    public func setImage(with url: URL?, placeHolder: UIImage? = nil, states: [UIControlState]? = [.normal], imageOperation: [CIImageOperation]? = nil, completionHandler: cicompleteHandler? = nil) -> Swift.Void {
        // 设置placeHolder
        if let placeHolder = placeHolder {
            for state in states! {
                base.setImage(placeHolder, for: state)
            }
        }
        guard let url = url else {
            completionHandler?(nil, nil, nil)
            return
        }
        // 关联key
        if self.url == nil {
            setURL(url)
        }
        // 异步请执行任务
        DispatchQueue.global().async {
            // 用url的hashValue 作为 key
            let imagePath = CIImageCache.ciImageCachepath.appending("/\(url.hashValue).imgTemp")
            let fileManager = FileManager.default
            var imageData = Data()
            
            if fileManager.fileExists(atPath: imagePath) {
                // 本地存在缓存 直接取出
                if let contentData =  fileManager.contents(atPath: imagePath) {
                    imageData = contentData
                    self.imageDataFetchSuccess(imageData, imageOperation: imageOperation, completionHandler: completionHandler)
                }else {
                    completionHandler?(nil, NSError(domain: "缓存读取失败", code: 110, userInfo: ["desc": "缓存读取失败"]), self.url)
                }
            }else {
                // 本地没有 重新请求
                do {
                    imageData = try Data(contentsOf: url)
                    if let (_, resultData) = self.imageDataFetchSuccess(imageData, imageOperation: imageOperation, completionHandler: completionHandler) {
                        // 存储到Disk
                        try CIImageCache.saveToDisk(atPath: imagePath, contents: resultData!, attributes: ["desc": "CIImageKit - \(url.hashValue)"])
                    }
                } catch(let error as NSError)  {
                    print(error)
                }
            }
        }

        
    }
}



