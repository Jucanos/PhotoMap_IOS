//
//  SplashView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct SplashView: View {
//    @State var isAuth = false // fasle as default!
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {        
        return Group {
            if self.userSettings.userInfo != nil {
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
