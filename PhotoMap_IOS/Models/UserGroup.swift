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
    var represents: Represent?
}

struct MapDataForAdd: Codable{
    var data: MapData?
    var message: String?
}

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
}

class UserGroupData: ObservableObject {
    
    let objectWillChange = ObservableObjectPublisher()
    var mapData: [MapData] = []{
        willSet{
            objectWillChange.send()
        }
    }
    
    func loadMapData(userTocken: String) {
        let url = NetworkURL.sharedInstance.getUrlString("/maps")
        AnyRequest<UserGroup> {
            Url(url)
            Method(.get)
            Header.Authorization(.bearer(userTocken))
        }.onObject{ groups in
            print(groups)
            DispatchQueue.main.async {
                self.mapData = groups.data as! [MapData]
            }
        }.onError{ error in
            print(error)
        }
        .call()
    }
    
    func addMap(name: String, userTocken: String) {
        let url = NetworkURL.sharedInstance.getUrlString("/maps")
        AnyRequest<MapDataForAdd> {
            Url(url)
            Method(.post)
            Header.Authorization(.bearer(userTocken))
            Header.ContentType(.json)
            Body(["name":name])
        }.onObject{ newGroup in
            print("add new group to server success!!")
            DispatchQueue.main.async {
                self.mapData.append(newGroup.data!)
            }
            
        }.onError{ error in
            print(error)
        }
        .call()
    }
    
    func deleteMap(mid: String, userTocken: String) {
        let url = NetworkURL.sharedInstance.getUrlString("/maps/\(mid)")
//        print(url)
        Request {
            Url(url)
            Method(.delete)
            Header.Authorization(.bearer(userTocken))
        }.onData{ data in
            print(data)
            print("group deletion success!")
        }.onError{ error in
            print(error)
        }
        .call()
    }
}
