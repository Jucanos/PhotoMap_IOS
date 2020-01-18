//
//  NetworkStandards.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/16.
//  Copyright © 2020 김근수. All rights reserved.
//

import Foundation

class NetworkURL {
    
    static let sharedInstance = NetworkURL()
    private let baseUrlString = "https://soybeans.tech/dev"
    
    func getBaseUrlString() -> String {
        return baseUrlString
    }
    
    func getUrlString(_ urlPath: String) -> String {
        return baseUrlString + urlPath
    }
}

