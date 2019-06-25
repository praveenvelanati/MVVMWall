//
//  FeedListViewModel.swift
//  MVVMWall
//
//  Created by praveen velanati on 6/23/19.
//  Copyright © 2019 praveen velanati. All rights reserved.
//

import Foundation
import UIKit
import SwiftIconFont

class FeedListViewModel {
    
    let title = Observable<String>(value: "Loading")
    let isLoading = Observable<Bool>(value: false)
    let isTableViewHidden = Observable<Bool>(value: false)
    let sectionViewModels = Observable<[SectionViewModel]>(value: [])
    
}
