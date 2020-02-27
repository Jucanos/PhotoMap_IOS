//
//  SwiftUIView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/02/11.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import Combine
import Request

struct AppNotice: Codable {
    var message: String?
    var data: [AppNoticeData?]
}

struct AppNoticeData: Codable{
    var context: String?
    var createdAt: String?
    var id: String?
    var title: String?
    var updatedAt: String?
    
    func getProperUpdatedAt() -> String {
        if updatedAt != nil{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
            let date = dateFormatter.date(from: updatedAt!)
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            return dateFormatter.string(from: date!)
        } else {
            return ""
        }
    }
}

class AppNoticeStore: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    @Published var noticeData: [AppNoticeData]? {
        willSet{
            objectWillChange.send()
        }
    }
    
    static let shared: AppNoticeStore = AppNoticeStore()
    init() {}
    
    func loadNotice(completionHandler: @escaping ()->()) {
        print("try to load notices!!")
        let url = NetworkURL.sharedInstance.getUrlString("/notice")
        AnyRequest<AppNotice> {
            Url(url)
            Method(.get)
            Header.Authorization(.bearer(UserSettings.shared.userTocken!))
        }.onObject { notice in
            print("Get notice Success!")
            print(notice)
            DispatchQueue.main.async {
                self.noticeData = (notice.data as! [AppNoticeData])
                completionHandler()
            }
        }.onError{ error in
            if let stringError = String(data: error.error!, encoding: .utf8){
                print(stringError)
            }
        }
        .call()
    }
}
