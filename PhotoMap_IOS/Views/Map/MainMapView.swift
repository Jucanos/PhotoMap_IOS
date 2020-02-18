//
//  MainMapView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct MainMapView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var mapStore: MapStore
    var body: some View {
        Group{
            if userSettings.userInfo?.data?.primary != nil {
                KoreaMap()
            } else{
                Text("대표 지도가 없습니다!")
            }
        }
        .onAppear(){
            if self.userSettings.userInfo?.data?.primary != nil {
                self.mapStore.loadMapDetail(mid: (self.userSettings.userInfo?.data?.primary!)!)
            }
        }
        
    }
}

struct MainMapView_Previews: PreviewProvider {
    static var previews: some View {
        MainMapView()
    }
}
