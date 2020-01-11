//
//  Feed.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/12.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct Feed: Hashable, Codable, Identifiable {
    var id = UUID()
//    var name: String
//    var updateTime: String
    var imageUrl: String
}

