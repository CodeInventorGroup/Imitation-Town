//
//  UIImage+ITExtension.swift
//  ImitationTown
//
//  Created by NEWWORLD on 2017/3/23.
//  Copyright © 2017年 CodeInventor Group. All rights reserved.
//

import Foundation
import UIKit

public enum CIImageOperation {
    // .corner(0) ==  clip image's size
    case corner(CGFloat)
    case scale(CGSize)
    case zip(Bool, CGFloat)
    case other
}

extension UIImage {
    
    //MARK:  ************************ Handel Image
    public func handleImage(operations: [CIImageOperation]? = nil) -> (UIImage, Data?) {
        let start = CFAbsoluteTimeGetCurrent()
        var data =  UIImageJPEGRepresentation(self, 1.0)
        if let operations = operations {
            var image = self
            
            for operation in operations {
                switch operation {
                case .corner(let cornerRadius):
                    let cornerSize = CGFloat.minimum(image.size.width, image.size.height)
                    image = image.adjust(cornerRadius: cornerRadius == 0 ?  cornerSize: cornerRadius)
                    data =  UIImagePNGRepresentation(image)
                case .scale(let size):
                    image = image.scaled(to: size)!
                case .zip(let isZip, let compressionQuality):
                    if isZip {
                        data = UIImageJPEGRepresentation(image, compressionQuality)
                    }else {
                        data = UIImagePNGRepresentation(image)
                    }
                default:
                    break
                }
            }
            
            return (image, data)
        }
        let end = CFAbsoluteTimeGetCurrent()
        print("渲染时长 = \(end - start)")
        return (self, data)
    }
    
    
    
    func draw(cgImage: CGImage?, to size: CGSize, draw: ()->()) -> UIImage {
        #if os(macOS)
            guard let rep = NSBitmapImageRep(
                bitmapDataPlanes: nil,
                pixelsWide: Int(size.width),
                pixelsHigh: Int(size.height),
                bitsPerSample: cgImage?.bitsPerComponent ?? 8,
                samplesPerPixel: 4,
                hasAlpha: true,
                isPlanar: false,
                colorSpaceName: NSCalibratedRGBColorSpace,
                bytesPerRow: 0,
                bitsPerPixel: 0) else
            {
                assertionFailure("[CIImageKit] Image representation cannot be created.")
                return base
            }
            rep.size = size
            
            NSGraphicsContext.saveGraphicsState()
            
            let context = NSGraphicsContext(bitmapImageRep: rep)
            NSGraphicsContext.setCurrent(context)
            draw()
            NSGraphicsContext.restoreGraphicsState()
            
            let outputImage = Image(size: size)
            outputImage.addRepresentation(rep)
            return outputImage
        #else
            
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            defer { UIGraphicsEndImageContext() }
            draw()
            return UIGraphicsGetImageFromCurrentImageContext() ?? self
            
        #endif
    }
    
    // 切图片圆角
    func adjust(cornerRadius radius: CGFloat) -> UIImage {
        
        guard let cgImage = cgImage else {
            assertionFailure("[UIImageView+Extension] round corder image only is kind of (CG-based) image.")
            return self
        }
        
        let rect = CGRect.init(origin: CGPoint(x: 0, y: 0), size: self.size)
        
        return draw(cgImage: cgImage, to: self.size) {
            guard let context = UIGraphicsGetCurrentContext() else {
                print("\(self) adjust radius failed")
                return
            }
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
            context.addPath(path)
            context.clip()
            self.draw(in: rect)
        }
    }
    
    // 图片尺寸调整
    func scaled(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 叠加两张图片，重合两张图片(第一张为底图，第二张在表层)
    class func superimoposeImages(baseImageName: String, surfaceImageName: String) -> UIImage {
        return UIImage.superimoposeImages(baseImage: UIImage(named: baseImageName)!, surfaceImage: UIImage(named: surfaceImageName)!)
    }
    
    class func superimoposeImages(baseImage: UIImage, surfaceImage: UIImage) -> UIImage {
        return UIImage.superimoposeImages(baseImage: baseImage, surfaceImage: surfaceImage, bestImage: nil)
    }

    class func superimoposeImages(baseImageName: String, surfaceImageName: String, bestImageName: String?) -> UIImage {
        return UIImage.superimoposeImages(baseImage: UIImage.init(named: baseImageName)!, surfaceImage: UIImage.init(named: surfaceImageName)!, bestImage: UIImage(named: bestImageName!))
    }
    
    class func superimoposeImages(baseImage: UIImage, surfaceImage: UIImage, bestImage: UIImage?) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(baseImage.size, false, UIScreen.main.scale)
        baseImage.draw(in: CGRect(x: 0, y: 0, width: baseImage.size.width, height: baseImage.size.height))
        surfaceImage.draw(in: CGRect(x: (baseImage.size.width - surfaceImage.size.width)/2, y: (baseImage.size.height - surfaceImage.size.height)/2, width: surfaceImage.size.width, height: surfaceImage.size.height))
        if let bestImage = bestImage {
            bestImage.draw(in: CGRect(x: baseImage.size.width - bestImage.size.width - 3, y: 3, width: bestImage.size.width, height: bestImage.size.height))
        }
        
        let resultImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }
}

