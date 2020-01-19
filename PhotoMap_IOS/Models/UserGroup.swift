//
//  UserGroup.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/10.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import Combine
import Request

struct UserGroup: Codable{
    var data: [MapData?]
    var message: String?
}

struct MapData: Codable {
    var mid: String?
    var name: String?
}

class UserGroupData: ObservableObject {
    
    let objectWillChange = ObservableObjectPublisher()
    var mapData: [MapData] = []{
        willSet{
            objectWillChange.send()
        }
    }
    
    func fetch(userTocken: String) {
        let url = NetworkURL.sharedInstance.getUrlString("/maps")
        AnyRequest<UserGroup> {
            Url(url)
            Method(.get)
            Header.Authorization(.bearer(userTocken))
        }.onObject{ groups in
            print("groups")
            print(groups)
            DispatchQueue.main.async {
                let sampleGroup = MapData(mid: "kasdkfoas2390", name: "내그룹")
                self.mapData.append(sampleGroup)
            }
            
        }.onError{ error in
            print(error)
        }
        .call()
    }
}
