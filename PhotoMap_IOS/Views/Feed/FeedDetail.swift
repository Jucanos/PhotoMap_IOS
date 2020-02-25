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
    @ObservedObject var mapStore = MapStore.shared
    @EnvironmentObject var feedStore: FeedStore
    @State var showFeedOption: Bool = false
    @State var selectedFeed: FeedData?
    @State var showModifyFeed: Bool = false
    var mapKey: String
    
    var body: some View {
        Group{
            if self.feedStore.feedData != nil{
                ScrollView{
                    VStack(alignment: .leading, spacing: 2){
                        ForEach(feedStore.feedData!, id: \.sid) { item in
                            FeedPreviewDetail(showFeedOption: self.$showFeedOption, selectedFeed: self.$selectedFeed, feedData: item)
                                .padding(.top, 10)
                        }
                    }
                }
                .actionSheet(isPresented: $showFeedOption){
                    ActionSheet(title: Text(""), message: Text(""), buttons: [
                        .default(Text("스토리 삭제"), action: {
                            self.feedStore.deleteFeed(sid: (self.selectedFeed?.sid!)!)
                        }),
                        .default(Text("스토리 수정"), action: {
                            self.showModifyFeed = true
                        }),
                        .destructive(Text("취소"))
                    ])
                }
                .sheet(isPresented: self.$showModifyFeed) {
                    ModifyFeed(selectedFeed: self.$selectedFeed).environmentObject(self.feedStore)
                }
            }
            else {
                EmptyView()
            }
        }
    }
}
