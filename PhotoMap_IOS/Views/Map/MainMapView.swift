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
    @ObservedObject var mapStore = MapStore.shared
    @State var isLoading = false
    var body: some View {
        Group{
            if userSettings.userInfo?.data?.primary != nil {
                LoadingView(isShowing: self.$isLoading){
                    Group{
                        if self.isLoading{
                            EmptyView()
                        } else{
                            KoreaMap()
                        }
                    }
                }
            } else{
                Text("대표 지도가 없습니다!")
            }
        }
        .onAppear(){
            if self.userSettings.userInfo?.data?.primary != nil {
                self.isLoading = true
                self.mapStore.loadMapDetail(mid: (self.userSettings.userInfo?.data?.primary!)!){
                    self.isLoading = false
                }
            }
        }
    }
}

struct MainMapView_Previews: PreviewProvider {
    static var previews: some View {
        MainMapView()
    }
}
