//
//  Map.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/02/17.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import Combine
import Request
import FirebaseDatabase
import URLImage

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
    
    func getProperUpdateAt() -> String {
        if updatedAt != nil{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.locale = Locale(identifier: "ko_kr")
            dateFormatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
            let date = dateFormatter.date(from: updatedAt!)
            
            let curDate = Date()
            let calendar = Calendar.current
            let curComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: curDate)
            let mapComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
            
            if curComponents.year != mapComponents.year{
                dateFormatter.dateFormat = "yy'년'M'월'dd'일'"
                return dateFormatter.string(from: date!)
            } else{
                if curComponents.month != mapComponents.month {
                    dateFormatter.dateFormat = "M'월'd'일'"
                    return dateFormatter.string(from: date!)
                } else{
                    if curComponents.day != mapComponents.day {
                        if curComponents.day == (mapComponents.day! + 1) {
                            
                            dateFormatter.dateFormat = "'어제' a h:mm"
                            return dateFormatter.string(from: date!)
                        } else{
                            dateFormatter.dateFormat = "d'일' h:mm"
                            return dateFormatter.string(from: date!)
                        }
                    } else {
                        dateFormatter.dateFormat = "a h:mm"
                        return dateFormatter.string(from: date!)
                    }
                }
            }
        } else {
            return ""
        }
    }
    
    func getSortedOwners() ->[UserInfoData] {
        if owners == nil {
            return []
        }
        return owners!.sorted(by: {$0.nickname! < $1.nickname!})
    }
}

struct MapImage: Codable {
    var data: String?
    var message: String?
}

// MARK:- MapStore

class MapStore: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    @Published var mapData: MapData = MapData(){
        willSet{
            objectWillChange.send()
            print("mapData Changed!!")
        }
    }
    
    static let shared: MapStore = MapStore()
    
    func loadMapDetail(mid: String, completionHandler: @escaping ()->()) {
        let url = NetworkURL.sharedInstance.getUrlString("/maps/\(mid)")
        AnyRequest<MapDetail> {
            Url(url)
            Method(.get)
            Header.Authorization(.bearer(UserSettings.shared.userTocken!))
        }.onObject{ map in
            print("map loadid!")
            DispatchQueue.main.async {
                self.mapData = map.data!
                print(self.mapData.owners! as Any)
                completionHandler()
            }
        }.onError{ error in
            print(error.self)
        }
        .call()
    }
    
    func setRepresentImage(cityKey: String, userTocken: String, image: UIImage, _ handler: @escaping () -> ()) {
        let url = NetworkURL.sharedInstance.getUrlString("/maps/\(MapStore.shared.mapData.mid!)")
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
        let url = NetworkURL.sharedInstance.getUrlString("/maps/\(MapStore.shared.mapData.mid!)")
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
    
    func getMapImage(completionHandler: @escaping(_ target: UIImage) -> Void) {
        let url = NetworkURL.sharedInstance.getUrlString("/maps/\(MapStore.shared.mapData.mid!)/represents")
        print(url)
        AnyRequest<MapImage> {
            Url(url)
            Method(.get)
            Header.Authorization(.bearer(UserSettings.shared.userTocken!))
        }.onObject{ mapImg in
            let imgUrl = mapImg.data!
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: URL(string: imgUrl)!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            completionHandler(image)
                        }
                    }
                }
            }
        }.onError{ error in
            if let stringError = String(data: error.error!, encoding: .utf8) {
                print(stringError)
            }
        }
        .call()
    }
    
    func getOwnerName(from uid: String) -> String{
        if let target = self.mapData.owners!.firstIndex(where: {$0.uid == uid}){
            return self.mapData.owners![target].nickname!
        } else{
            return "존재하지 않는 맴버!"
        }
    }
    
    func getOwnerThumbnail(from uid: String) -> String{
        if let target = self.mapData.owners!.firstIndex(where: {$0.uid == uid}){
            print(target)
            return self.mapData.owners![target].thumbnail!
        } else{
            return ""
        }
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
