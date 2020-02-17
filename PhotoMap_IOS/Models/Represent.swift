//
//  Represent.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/02/17.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct Represent: Codable {
    var gyeonggi: String?
    var gangwon: String?
    var chungbuk: String?
    var chungnam: String?
    var jeonbuk: String?
    var jeonnam: String?
    var gyeongbuk: String?
    var gyeongnam: String?
    var jeju: String?
    
    func getStr(location: String) -> String? {
        let dict = ["gyeonggi": gyeonggi,
                    "gangwon": gangwon,
                    "chungbuk": chungbuk,
                    "chungnam": chungnam,
                    "jeonbuk": jeonbuk,
                    "jeonnam": jeonnam,
                    "gyeongbuk": gyeongbuk,
                    "gyeongnam": gyeongnam,
                    "jeju": jeju]
        return dict[location] ?? nil
    }
}

struct RepresentData: Codable {
    var data: Represent?
    var message: String?
}
