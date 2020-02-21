//
//  SplashView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

let appColor = UIColor(red: 0.149, green: 0.667, blue: 0.439, alpha: 1)

struct SplashView: View {
    @ObservedObject var userSettings = UserSettings.shared
    @ObservedObject var fbBackMid = FireBaseBackMid.shared
    
    init() {
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some View {
        Group {
            if self.userSettings.isValid() && fbBackMid.isValid() {
                MainTabView().environmentObject(MapStore()).environmentObject(FeedStore())
            }
            else {
                LoginView()
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SplashView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            
            SplashView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            
            SplashView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
        }
    }
}
