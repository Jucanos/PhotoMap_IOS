//
//  UserInfo.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/16.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct UserInfo: Codable {
    var data: UserInfoData?
    var message: String?
}

struct UserInfoData: Codable {
    var nickname: String
    var thumbnail: String
    var uid: Int
}
