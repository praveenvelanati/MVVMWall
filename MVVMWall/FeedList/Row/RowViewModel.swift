//
//  RowViewModel.swift
//  MVVMWall
//
//  Created by praveen velanati on 6/23/19.
//  Copyright © 2019 praveen velanati. All rights reserved.
//

import Foundation

protocol RowViewModel {}

protocol ViewModelPressible {
    
    var cellPressed: ( () -> Void )? { get set }
}
