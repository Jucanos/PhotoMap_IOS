//
//  FeedView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/11.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import Request

struct FeedView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var mapStore: MapStore
    @EnvironmentObject var feedStore: FeedStore
    @State var location: String
    @State var isLoading = true
    var mapKey: String
    
    var body: some View {
        LoadingView(isShowing: self.$isLoading){
            Group{
                if self.feedStore.feedData.isEmpty{
                    Text("피드가 없어요!")
                } else{
                    FeedDetail(mapKey: self.mapKey)
                }
            }
        }
        .navigationBarTitle("\(location)", displayMode: .inline)
        .navigationBarItems( trailing:
            NavigationLink(destination: AddFeed(cityKey: self.mapKey)) {
                Image(systemName: "plus.square")
                    .resizable()
                    .frame(width: 20, height: 20)
//                    .foregroundColor(.white)
            }
        )
            .onAppear(){
                self.feedStore.loadFeeds(mid: self.mapStore.mapData.mid!, mapKey: self.mapKey) {
                    self.isLoading = false
                }
        }
    }
    
//    var backButton : some View {
//        Button(action: {
//            self.presentationMode.wrappedValue.dismiss()
//        }) {
//            HStack {
//                Image(systemName: "arrow.left")
//                    .resizable()
//                    .frame(width: 20, height: 20)
//                    .foregroundColor(.white)
//            }
//        }
//    }
}
