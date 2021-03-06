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

class UserGroupStore: ObservableObject {
    
    let objectWillChange = ObservableObjectPublisher()
    var mapData: [MapData]?{
        willSet{
            objectWillChange.send()
        }
    }
    
    static let shared: UserGroupStore = UserGroupStore()
    
    func loadMaps() {
        let url = NetworkURL.sharedInstance.getUrlString("/maps")
        AnyRequest<UserGroup> {
            Url(url)
            Method(.get)
            Header.Authorization(.bearer(UserSettings.shared.userTocken!))
        }.onObject{ groups in
            DispatchQueue.main.async {
                self.mapData = self.getSortedMaps(from: groups.data as! [MapData])
            }
        }.onError{ error in
            print("Error at loadMaps")
            if let stringError = String(data: error.error!, encoding: .utf8) {
                print(stringError)
            }
        }
        .call()
    }
    
    func addMap(name: String, completionHandler: @escaping ()->()) {
        let url = NetworkURL.sharedInstance.getUrlString("/maps")
        AnyRequest<MapDetail> {
            Url(url)
            Method(.post)
            Header.Authorization(.bearer(UserSettings.shared.userTocken!))
            Header.ContentType(.json)
            Body(["name":name])
        }.onObject{ newGroup in
            DispatchQueue.main.async {
                self.loadMaps()
                completionHandler()
            }
            
        }.onError{ error in
            print("Error at addMap")
            if let stringError = String(data: error.error!, encoding: .utf8){
                print(stringError)
            }
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
            print("Error at deleteMap")
            if let stringError = String(data: error.error!, encoding: .utf8){
                print(stringError)
            }
        }
        .call()
    }
    
    func changeGroupName(mid: String, newName: String, handler: @escaping ()->()) {
        let url = NetworkURL.sharedInstance.getUrlString("/maps/\(mid)")
        Request {
            Url(url)
            Method(.put)
            Header.Authorization(.bearer(UserSettings.shared.userTocken!))
            Header.ContentType(.json)
            Body(["name": newName])
        }.onData{ data in
            print("group name change success!")
            DispatchQueue.main.async {
                self.loadMaps()
                handler()
            }
        }.onError{ error in
            if let stringError = String(data: error.error!, encoding: .utf8){
                print(stringError)
            }
        }
        .call()
    }
    
    func joinGroup(at mid:String) {
        let url = NetworkURL.sharedInstance.getUrlString("/maps/\(mid)")
        Request{
            Url(url)
            Method(.patch)
            Header.Authorization(.bearer(UserSettings.shared.userTocken!))
        }.onError{ error in
            print("Error at joinGroup")
            if let stringData = String(data: error.error!, encoding: .utf8){
                print(stringData)
            }
        }.onData{ data in
            print("join success")
            self.loadMaps()
        }
        .call()
    }
    
    func exitGroup(from mid: String) {
        let url = NetworkURL.sharedInstance.getUrlString("/maps/\(mid)")
        Request{
            Url(url)
            Method(.patch)
            Header.Authorization(.bearer(UserSettings.shared.userTocken!))
            Header.ContentType(.json)
            Body(["remove": "true"])
        }.onError{ error in
            if let stringData = String(data: error.error!, encoding: .utf8){
                print(stringData)
            }
        }.onData{ data in
            DispatchQueue.main.async {
                print("exit success")
                if UserSettings.shared.userInfo?.data?.primary == mid{
                    UserSettings.shared.deleteRepresentMap(mid: mid){}
                }
                var idx = 0
                for map in self.mapData!{
                    if map.mid == mid{
                        self.mapData!.remove(at: idx)
                    }
                    idx += 1
                }
            }
        }
        .call()
    }
    
    func getMapThumbnail(mid: String, completionHandler: @escaping(_ target: UIImage) -> Void) {
        let url = "https://s3.soybeans.tech/uploads/prod/\(mid)/main.png"
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: URL(string: url)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completionHandler(image)
                    }
                }
            }
        }
    }
    
    func getSortedMaps(from oldArr: [MapData]) -> [MapData] {
        var newArr: [MapData] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
        
        newArr = oldArr.sorted(by: {dateFormatter.date(from: $0.updatedAt!)! > dateFormatter.date(from: $1.updatedAt!)!})
        
        if UserSettings.shared.userInfo?.data?.primary != nil {
            let idx = newArr.firstIndex(where: {$0.mid == UserSettings.shared.userInfo?.data?.primary})!
            let primary = newArr[idx]
            newArr.remove(at: idx)
            newArr.insert(primary, at: 0)
        }
        return newArr
    }
    
    func sortMaps() {
        DispatchQueue.main.async {
            self.mapData = self.getSortedMaps(from: self.mapData!)
        }
    }
}
