//
//  FeedDetail.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/12.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct FeedDetail: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var mapStore: MapStore
    @EnvironmentObject var feedStore: FeedStore
    var mapKey: String
    var masterViewSize: CGSize
    
    var body: some View {
        return Group{
            if feedStore.feedData.isEmpty {
                Text("피드를 추가해보세요!")
            } else{
                ScrollView{
                    VStack(alignment: .leading, spacing: 2){
                        ForEach(feedStore.feedData, id: \.title) { item in
                            FeedPreviewDetail(viewControllers: item.getImageViews(), feedData: item, masterViewSize: self.masterViewSize)
                                .padding(.bottom, 20)
                        }
                    }
                }
            }
        }
        .onAppear(){
            self.feedStore.loadFeeds(userTocken: self.userSettings.userTocken!, mid: self.mapStore.mapData.mid!, mapKey: self.mapKey)
        }
    }
}

//struct FeedDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedDetail()
//    }
//}
