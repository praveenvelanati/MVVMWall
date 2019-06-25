//
//  ImageDownloadHelper.swift
//  MVVMWall
//
//  Created by praveen velanati on 6/23/19.
//  Copyright © 2019 praveen velanati. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

protocol ImageDownloaderHelperProtocol {
    func download(url: URL, completion: @escaping (UIImage?, URLResponse?, Error?) -> ())
}


class ImageDownloaderHelper: ImageDownloaderHelperProtocol {
    
    let urlSession: URLSession = URLSession.shared
    
    static var shared: ImageDownloaderHelper = {
       return ImageDownloaderHelper()
    }()
    
    func download(url: URL, completion: @escaping (UIImage?, URLResponse?, Error?) -> ()) {
        urlSession.dataTask(with: url) { (data, response, error) in
            if let data = data {
                completion(UIImage(data: data), response, error)
            } else {
                completion(nil, response, error)
            }
        }.resume()
    }
    
}

class MockImageDownloadHelper: ImageDownloaderHelperProtocol {

    func download(url: URL, completion: @escaping (UIImage?, URLResponse?, Error?) -> ()) {
    
        DispatchQueue.global().async {
            usleep(1000000 + (arc4random() % 9)*100000)
            let images = ["sample", "sample2", "sample3", "sample4", "sample5", "profile"]
            let idx = Int(arc4random()) % images.count
            let randName = images[idx]
            let image = UIImage(contentsOfFile: Bundle.main.path(forResource: randName, ofType: "jpg")!)
            completion(image, nil, nil)
        }
        
    }
}










