//
//  FeedPreviewDetail.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/12.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import URLImage

struct FeedPreviewDetail: View {
    @EnvironmentObject var feedStore: FeedStore
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var mapStore = MapStore.shared
    @State var currentPage = 0
    @Binding var showFeedOption: Bool
    @Binding var selectedFeed: FeedData?
    var feedData: FeedData
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            // User Profile
            HStack{
                Group{
                    if self.mapStore.getOwnerThumbnail(from: self.feedData.creator!).isEmpty{
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding(.leading, 5)
                            .foregroundColor(Color(appColor))
                        
                    } else{
                        URLImage(URL(string: self.mapStore.getOwnerThumbnail(from: self.feedData.creator!))!) { proxy in
                            proxy.image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                                .overlay(Circle().stroke(Color(appColor), lineWidth: 1))
                                .padding(.leading, 5)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 5){
                    Text(mapStore.getOwnerName(from: feedData.creator!))
                    .font(.custom("NanumSquareRoundB", size: 17))
                    Text("\(feedData.getProperCreatedAt())")
                    .font(.custom("NanumSquareRoundR", size: 12))
                        .foregroundColor(Color(.lightGray))
                }
                
                Spacer()
                
                Button(action: {
                    self.showFeedOption.toggle()
                    self.selectedFeed = self.feedData
                }){
                    Image("threeDots")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
                .padding(5)
            }.frame(width: UIScreen.main.bounds.width)
            
            // Image PageView
            if self.feedData.files.count == 1{
                URLImage(URL(string: self.feedData.files.first!!)!){ proxy in
                    proxy.image.resizable()
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            } else{
                PageView(self.feedData.getImageViews())
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            }
            
            // Title & Context
            VStack(alignment: .leading, spacing: 5){
                Text("\(feedData.title!)")
                    .font(.custom("NanumSquareRoundB", size: 17))
                Text("\(feedData.context!)")
                    .font(.custom("NanumSquareRoundR", size: 12))
            }.padding(.leading, 10)
        }
    }
}

//struct FeedPreviewDetail_Previews: PreviewProvider {
//    static let tfeed = Feed(imageUrl: "test1")
//    static var previews: some View {
//        Group {
//            FeedPreviewDetail(feedData: tfeed)
//                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
//                .previewDisplayName("iPhone SE")
//            
//            FeedPreviewDetail(feedData: tfeed)
//                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
//                .previewDisplayName("iPhone 8")
//            
//            FeedPreviewDetail(feedData: tfeed)
//                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
//                .previewDisplayName("iPhone 11 Pro")
//        }
//        
//    }
//}
