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
    var mapKey: String
    var masterViewSize: CGSize
    
    var body: some View {
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

//struct FeedDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedDetail()
//    }
//}
