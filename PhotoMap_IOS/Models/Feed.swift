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

struct FeedData: Codable {
    var createdAt: String?
    var updatedAt: String?
    var title: String?
    var context: String?
    var files: [String?]
    var sid: String?
    var mid: String?
    
    func getImageViews() -> [UIHostingController<URLImage<Image,Image>>] {
        let urls = self.files.map{
            URL(string: "\(String(describing: $0))")
//            URLImage()
//            Image("\($0)").resizable()
        }
        
        var images: [URLImage<Image,Image>] = []
        for url in urls{
            images.append(URLImage(url!))
        }
        let vcs = images.map{
            UIHostingController(rootView: $0)
        }
        return vcs
    }
}


class FeedStore: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    var feedData: [FeedData] = []{
        willSet{
            objectWillChange.send()
        }
    }
    
    func loadFeeds(userTocken: String, mid: String, mapKey: String) {
        let url = NetworkURL.sharedInstance.getUrlString("/stories/\(mid)/\(mapKey)")
        print("try to road")
        AnyRequest<Feed> {
            Url(url)
            Method(.get)
            Header.Authorization(.bearer(userTocken))
        }.onObject{ feeds in
            print(feeds)
            DispatchQueue.main.async {
                self.feedData = feeds.data as! [FeedData]
            }
        }.onError{ error in
            print("Error at loadMaps", error)
        }
        .call()
    }
}
