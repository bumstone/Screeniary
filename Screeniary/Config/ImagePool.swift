//
//  CachedImage.swift
//  MasterDetailBasic
//
//  Created by jmleehs on 5/5/24.
//

import UIKit

class ImagePool{
    static var imagePool: [String: UIImage] = [:]
    static var maxImages = 20
    
    static public func image(name: String, size: CGSize? = nil) -> UIImage{
        if var image = imagePool[name]{
            if let size = size{
                image = image.resized(to: size)
            }
            return image
        }
        if var image = UIImage(named: name){
            if let size = size{
                image = image.resized(to: size)
            }
            sacrifice()
            imagePool[name] = image
            return image
        }
        return UIImage()
    }
    
    static public func image(name: String, size: CGSize? = nil, completion: @escaping (UIImage)->Void){
        if var image = imagePool[name]{
            if let size = size{
                image = image.resized(to: size)
            }
            completion(image)
            return
        }
        if var image = UIImage(named: name){
            if let size = size{
                image = image.resized(to: size)
            }
            sacrifice()
            imagePool[name] = image
            completion(image)
            return
        }
        
        DbFirebase.downloadImage(imageName: name){ image in
            // 스레드에 의해 실행
            if let image = image{
                let resizedImage = image.resized(to: size!)
                sacrifice() // 메모리가 부족한 경우 선입제거
                self.imagePool[name] = image
                completion(resizedImage)
                return
            }
            completion(UIImage())
        }
        completion(UIImage())
    }
    
    static public func putImage(name: String, image: UIImage?){
        imagePool[name] = image
    }
    
    static public func sacrifice(){
        if(imagePool.count < maxImages){
            return
        }
        let scrificed = Int.random(in: 0..<imagePool.count)
        let keys = Array(imagePool.keys)
        imagePool.removeValue(forKey: keys[scrificed])
    }
    
}
