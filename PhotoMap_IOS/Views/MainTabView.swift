//
//  MainTabView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    @State var selectedView = 0
    
    var body: some View {
        TabView(selection: $selectedView) {
            MainGroupView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    .resizable()
            }.tag(0)
            MainMapView()
                .tabItem {
                    Image(systemName: "map.fill")
                    .resizable()
            }.tag(1)
            MainSettingView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    .resizable()
            }.tag(2)
        }
        .accentColor(.black)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
            Group {
                MainTabView()
                    .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                    .previewDisplayName("iPhone SE")
    
                MainTabView()
                    .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                    .previewDisplayName("iPhone 8")
    
                MainTabView()
                    .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                    .previewDisplayName("iPhone 11 Pro")
            }
        }
}
