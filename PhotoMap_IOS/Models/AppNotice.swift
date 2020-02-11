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
    var data: AppNoticeData?
}

struct AppNoticeData: Codable{
    var context: String?
    var createdAt: Date?
    var id: String?
    var title: String?
    var updatedAt: Date?
}

class AppNoticeStore: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    @Published var noticeData: AppNoticeData? {
        willSet{
            objectWillChange.send()
        }
    }
    
    static let shared: AppNoticeStore = AppNoticeStore()
    init() {}
    
    func loadNotice() {
        let url = NetworkURL.sharedInstance.getUrlString("/notice")
        AnyRequest<AppNoticeData> {
            Url(url)
            Method(.get)
            Header.Authorization(.bearer(UserSettings.shared.userTocken!))
        }.onObject { notice in
            print("Get notice Success!")
            DispatchQueue.main.async {
                self.noticeData = notice
            }
        }.onError{ error in
            if let stringError = String(data: error.error!, encoding: .utf8){
                print(stringError)
            }
        }
        .call()
    }
}
