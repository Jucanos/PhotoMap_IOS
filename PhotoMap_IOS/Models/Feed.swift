//
//  Feed.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/12.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import Combine
import Request
import URLImage

struct Feed: Codable {
    var data: [FeedData?]
    var message: String?
}

struct FeedForAdd: Codable{
    var data: FeedData?
    var message: String?
}

struct FeedData: Codable {
    var createdAt: String?
    var updatedAt: String?
    var title: String?
    var context: String?
    var files: [String?]
    var sid: String?
    var mid: String?
    var creator: String?
    
    func getImageViews() -> [URLImage<Image,Image>] {
        var images: [URLImage<Image,Image>] = []
        for urlStr in files {
            let url = URL(string: urlStr!)
            let item = URLImage(url!){ proxy in
                proxy.image.resizable()
            }
            images.append(item)
        }
        return images
    }
    
    func getProperCreatedAt() -> String {
        if createdAt != nil{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
            let date = dateFormatter.date(from: createdAt!)
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            return dateFormatter.string(from: date!)
        } else {
            return ""
        }
    }
}


class FeedStore: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    var feedData: [FeedData]? {
        willSet{
            objectWillChange.send()
        }
    }
    
    func loadFeeds(mid: String, mapKey: String, completionHandler: @escaping ()->()) {
        let url = NetworkURL.sharedInstance.getUrlString("/stories/\(mid)/\(mapKey)")
        AnyRequest<Feed> {
            Url(url)
            Header.Authorization(.bearer(UserSettings.shared.userTocken!))
        }.onObject{ feeds in
            DispatchQueue.main.async {
                self.feedData = self.getSortedFeeds(from: (feeds.data as? [FeedData])!)
                completionHandler()
            }
        }.onError{ error in
            print("Error at loadMaps", error)
        }
        .call()
    }
    
    func addFeed(mid: String, cityKey: String, title: String, context: String, images: [UIImage], _ handler: @escaping () -> ()){
        let url = NetworkURL.sharedInstance.getUrlString("/stories/\(mid)")
        let boundary = UUID().uuidString
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(UserSettings.shared.userTocken!)", forHTTPHeaderField: "Authorization")
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Add the reqtype field and its value to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"cityKey\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(cityKey)".data(using: .utf8)!)
        
        // Add the userhash field and its value to the raw http reqyest data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"title\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(title)".data(using: .utf8)!)
        
        // Add the userhash field and its value to the raw http reqyest data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"context\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(context)".data(using: .utf8)!)
        
        // Add the image data to the raw http request data
        for img in images{
            let curTime = currentTime()
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"img\"; filename=\"\(curTime).jpeg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(img.jpegData(compressionQuality: 0.5)!)
        }
        
        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
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
            }
        }).resume()
    }
    
    func modifyFeed(sid: String, title: String, context: String, _ handler: @escaping ()->()) {
        let url = NetworkURL.sharedInstance.getUrlString("/stories/\(sid)")
        Request {
            Url(url)
            Method(.patch)
            Header.Authorization(.bearer(UserSettings.shared.userTocken!))
            Header.ContentType(.json)
            Body(["title": title, "context": context])
        }.onError{ error in
            if let stringData = String(data: error.error!, encoding: .utf8) {
                print(stringData)
            }
        }.onData { data in
            DispatchQueue.main.async {
                var idx = 0
                for item in self.feedData!{
                    if item.sid == sid{
                        self.feedData![idx].title = title
                        self.feedData![idx].context = context
                        break
                    }
                    idx += 1
                }
                handler()
            }
        }
        .call()
    }
    
    func deleteFeed(sid: String) {
        let url = NetworkURL.sharedInstance.getUrlString("/stories/\(sid)")
        AnyRequest<Feed> {
            Url(url)
            Method(.delete)
            Header.Authorization(.bearer(UserSettings.shared.userTocken!))
        }.onData{ data in
            DispatchQueue.main.async {
                var idx = 0
                for item in self.feedData! {
                    if item.sid == sid {
                        self.feedData!.remove(at: idx)
                        return
                    }
                    idx += 1
                }
            }
        }.onError{ error in
            if let stringData = String(data: error.error!, encoding: .utf8){
                print(stringData)
            }
            print("Error at deleteFeed", error)
            return
        }
        .call()
    }
    
    func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let sec = calendar.component(.second, from: date)
        return "\(hour):\(minutes):\(sec)"
    }
    
    func getSortedFeeds(from oldArr: [FeedData]) -> [FeedData] {
        var newArr: [FeedData] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
        
        newArr = oldArr.sorted(by: {dateFormatter.date(from: $0.createdAt!)! > dateFormatter.date(from: $1.createdAt!)!})
        return newArr
    }
}
