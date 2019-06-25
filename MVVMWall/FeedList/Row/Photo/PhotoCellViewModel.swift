//
//  PhotoCellViewModel.swift
//  MVVMWall
//
//  Created by praveen velanati on 6/23/19.
//  Copyright © 2019 praveen velanati. All rights reserved.
//

import Foundation

class PhotoCellViewModel: RowViewModel, ViewModelPressible {
 
    var cellPressed: (() -> Void)?
    let title: String
    let desc: String
    var image: AsyncImage
    
    init(title: String, desc: String, image: AsyncImage) {
        self.title = title
        self.desc = desc
        self.image = image
    }
    
}
