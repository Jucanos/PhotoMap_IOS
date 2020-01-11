//
//  FeedPreviewDetail.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/12.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct FeedPreviewDetail: View {
    let feedData: Feed
    var masterViewSize: CGSize
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack{
                Image("pro_test")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .shadow(radius: 3)
                    .overlay(Circle().stroke(Color.pink, lineWidth: 1))
                    .padding(.leading, 5)
                
                VStack(alignment: .leading){
                    Text("User").font(.headline)
                    Text("Upload at 2020.01.10").foregroundColor(Color(.lightGray)).font(.subheadline)
                }
                
                Spacer()
                
                Button(action: {}){
                    Image("threeDots")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
                .padding(.trailing, 5)
            }
            
            Image(self.feedData.imageUrl)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: masterViewSize.width, height: masterViewSize.width)
            
            HStack{
                Button(action: {}){
                    Image(systemName:"heart")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }.padding(.leading, 5)
                
                Button(action: {}){
                    Image(systemName:"message")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }.padding(.leading, 5)
                
                Button(action: {}){
                    Image(systemName: "location")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }.padding(.leading, 5)
                
                Spacer()
                
                Button(action: {}){
                    Image(systemName:"flag")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }.padding(.trailing, 5)
            }
            
            VStack(alignment: .leading){
                Text("Liked by Person1 and Person2")
                Text("See all comments").foregroundColor(Color(.lightGray)).font(.subheadline)
            }.padding(.leading, 5)
            
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
