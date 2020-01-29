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
    var mapKey: String
    
    var body: some View {
        Group{
            if feedStore.feedData.isEmpty{
                Text("Empty")
            } else{
                FeedDetail(mapKey: self.mapKey, masterViewSize: UIScreen.main.bounds.size)
            }
        }
        .navigationBarTitle("\(location)", displayMode: .inline)
        .navigationBarItems( trailing:
            NavigationLink(destination: AddFeed(cityKey: self.mapKey)) {
                Image(systemName: "plus.square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
        )
            .onAppear(){
                self.feedStore.loadFeeds(userTocken: self.userSettings.userTocken!, mid: self.mapStore.mapData.mid!, mapKey: self.mapKey)
        }
    }
    
    var backButton : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
        }
    }
}
