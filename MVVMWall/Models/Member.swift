//
//  Member.swift
//  MVVMWall
//
//  Created by praveen velanati on 6/23/19.
//  Copyright © 2019 praveen velanati. All rights reserved.
//

import Foundation

struct Member: Feed {
    
    var id: String
    var userID: String
    var time: Date
    var name: String
    var isFollowing: Bool
    var avatarURL: String
}
