//
//  UserGroup.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/10.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct UserGroup: Hashable, Codable, Identifiable {
    var id = UUID()
    var name: String
    var updateTime: String
    var imageName: String
}
