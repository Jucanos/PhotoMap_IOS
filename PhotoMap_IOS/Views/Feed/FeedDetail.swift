//
//  FeedDetail.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/12.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct FeedDetail: View {
    
    let feeds: [Feed] = [
        Feed(imageUrl: "test1"),
        Feed(imageUrl: "test1"),
        Feed(imageUrl: "test1"),
        Feed(imageUrl: "test1"),
        Feed(imageUrl: "test1"),
        Feed(imageUrl: "test1"),
        Feed(imageUrl: "test1"),
        Feed(imageUrl: "test1"),
        Feed(imageUrl: "test1"),
        Feed(imageUrl: "test1")
    ]
    var masterViewSize: CGSize
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 2){
                ForEach(feeds, id: \.id) { feed in
                    FeedPreviewDetail(feedData: feed, masterViewSize: self.masterViewSize).padding(.bottom, 20)
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
