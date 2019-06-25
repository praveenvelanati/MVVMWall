//
//  AsyncImage.swift
//  MVVMWall
//
//  Created by praveen velanati on 6/23/19.
//  Copyright © 2019 praveen velanati. All rights reserved.
//

import Foundation
import UIKit

/// Promise-pattern wrapped image object, with in-memor eternal cache support
class AsyncImage {
    
    let url: URL
    
    var image: UIImage {
        return self.imageStore ?? placeholder
    }
    
    var completeDownload: ( (UIImage?) -> Void)?
    
    private var imageStore: UIImage?
    private var placeholder: UIImage
    
    private let imageDownloadHelper: ImageDownloaderHelperProtocol
    private var isDownloading: Bool = false
    
    
    init(url: String, placeholderImage: UIImage, imageDownloadHelper: ImageDownloaderHelperProtocol = MockImageDownloadHelper()) {
        self.url = URL(string: url)!
        self.placeholder = placeholderImage
        self.imageDownloadHelper = imageDownloadHelper
    }
    
    /// Start download the image with provided url
    
    func startDownload() {
        if imageStore != nil {
            completeDownload?(image)
        } else {
            if isDownloading { return }
            isDownloading = true
            imageDownloadHelper.download(url: url, completion: { [weak self] (image, response, error) in
                self?.imageStore = image
                self?.isDownloading = false
                DispatchQueue.main.async {
                    self?.completeDownload?(image)
                }
            })
        }
    }
    
    
}
