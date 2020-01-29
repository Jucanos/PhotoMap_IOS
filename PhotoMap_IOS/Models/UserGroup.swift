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

struct MapDetail: Codable{
    var data: MapData?
    var message: String?
}

struct MapData: Codable {
    var mid: String?
    var name: String?
    var represents: Represent?
    var createdAt: String?
    var updatedAt: String?
    var owners: [UserInfoData]?
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

class UserGroupStore: ObservableObject {
    
    let objectWillChange = ObservableObjectPublisher()
    var mapData: [MapData] = []{
        willSet{
            objectWillChange.send()
        }
    }
    
    func loadMaps(userTocken: String) {
        let url = NetworkURL.sharedInstance.getUrlString("/maps")
        print("try to road")
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
            print("Error at loadMaps", error)
        }
        .call()
    }
    
    func addMap(name: String, userTocken: String) {
        let url = NetworkURL.sharedInstance.getUrlString("/maps")
        AnyRequest<MapDetail> {
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




class MapStore: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    var mapData: MapData = MapData(){
        willSet{
            objectWillChange.send()
        }
    }
    
    init(){
        mapData.owners = []
    }
    
    func loadMapDetail(mid: String, userTocken: String) {
        print(mid, userTocken)
        let url = NetworkURL.sharedInstance.getUrlString("/maps/\(mid)")
        AnyRequest<MapDetail> {
            Url(url)
            Method(.get)
            Header.Authorization(.bearer(userTocken))
        }.onObject{ map in
            DispatchQueue.main.async {
                self.mapData = map.data!
            }
        }.onError{ error in
            print(error.self)
        }.onData{ data in
            print(data)
        }
        .call()
    }
    
}
