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

class UserGroupStore: ObservableObject {
    
    let objectWillChange = ObservableObjectPublisher()
    var mapData: [MapData] = []{
        willSet{
            objectWillChange.send()
        }
    }
    
    static let shared: UserGroupStore = UserGroupStore()
    
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
    
    func joinGroup(at mid:String) {
        print("try to join!!!!!!")
        let url = NetworkURL.sharedInstance.getUrlString("/maps/\(mid)")
        Request{
            Url(url)
            Method(.patch)
            Header.Authorization(.bearer(UserSettings.shared.userTocken!))
        }.onError{ error in
            print("error ocured!!!!")
            if let stringData = String(data: error.error!, encoding: .utf8){
                print(stringData)
            }
        }.onData{ data in
            print("join success")
        }
        .call()
    }
    
    func exitGroup(from mid: String) {
        print("try to exit!!!!")
        let url = NetworkURL.sharedInstance.getUrlString("/maps/\(mid)")
        Request{
            Url(url)
            Method(.patch)
            Header.Authorization(.bearer(UserSettings.shared.userTocken!))
            Header.ContentType(.json)
            Body(["remove": "true"])
        }.onError{ error in
            print("error ocured!!!!")
            if let stringData = String(data: error.error!, encoding: .utf8){
                print(stringData)
            }
        }.onData{ data in
            print("exit success")
        }
        .call()
    }
}




class MapStore: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    @Published var mapData: MapData = MapData(){
        willSet{
            objectWillChange.send()
        }
    }
    
    static let shared: MapStore = MapStore()
    init(){
        mapData.owners = []
    }
    
    func loadMapDetail(mid: String, userTocken: String) {
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
    
    func setRepresentImage(cityKey: String, userTocken: String, image: UIImage, _ handler: @escaping () -> ()) {
        let url = NetworkURL.sharedInstance.getUrlString("/maps/\(mapData.mid!)")
        let boundary = UUID().uuidString
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(userTocken)", forHTTPHeaderField: "Authorization")
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Add the reqtype field and its value to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"cityKey\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(cityKey)".data(using: .utf8)!)
        
        // Add the image data to the raw http request data
        
        let curTime = currentTime()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"img\"; filename=\"\(curTime).jpeg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 0.5)!)
        
        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            
            if(error != nil){
                print("\(error!.localizedDescription)")
            }
            
            guard let responseData = responseData else {
                print("no response data")
                return
            }
            if let responseString = String(data: responseData, encoding: .utf8) {
                print("uploaded to: \(responseString)")
                DispatchQueue.main.async {
                    handler()
                }
            }else{
                print("Represent Image set failed after get data!")
            }
        }).resume()
    }
    
    func deleteRepresentImage(cityKey: String, userTocken: String) {
        let url = NetworkURL.sharedInstance.getUrlString("/maps/\(mapData.mid!)")
        let boundary = UUID().uuidString
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(userTocken)", forHTTPHeaderField: "Authorization")
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Add the reqtype field and its value to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"cityKey\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(cityKey)".data(using: .utf8)!)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"remove\"\r\n\r\n".data(using: .utf8)!)
        data.append("true".data(using: .utf8)!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if(error != nil){
                print("\(error!.localizedDescription)")
            }
            guard let responseData = responseData else {
                print("no response data")
                return
            }
            if let newRep = try? JSONDecoder().decode(RepresentData.self, from: responseData){
                print("Deletion Success!!")
                DispatchQueue.main.async {
                    self.mapData.represents =  newRep.data
                }
            }
            
        }).resume()
    }
    
    func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let sec = calendar.component(.second, from: date)
        return "\(hour):\(minutes):\(sec)"
    }
    
}
