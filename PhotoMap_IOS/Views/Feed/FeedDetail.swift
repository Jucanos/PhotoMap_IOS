//
//  FeedDetail.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/12.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import Request

struct FeedDetail: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var mapStore: MapStore
    @EnvironmentObject var feedStore: FeedStore
    @State var showFeedOption: Bool = false
    @State var selectedFeed: String = ""
    var mapKey: String
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 2){
                ForEach(feedStore.feedData, id: \.sid) { item in
                    FeedPreviewDetail(showFeedOption: self.$showFeedOption, selectedFeed: self.$selectedFeed, feedData: item)
                        .padding(.bottom, 20)
                }
            }
        }
        .actionSheet(isPresented: $showFeedOption){
            ActionSheet(title: Text(""), message: Text(""), buttons: [
                .default(Text("스토리 삭제"), action: {
                    self.feedStore.deleteFeed(sid: self.selectedFeed, userTocken: self.userSettings.userTocken!)
                }),
                .destructive(Text("취소"))
            ])
        }
        .onDisappear(){
            self.feedStore.feedData.removeAll()
        }
    }
}

//struct FeedDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedDetail()
//    }
//}
