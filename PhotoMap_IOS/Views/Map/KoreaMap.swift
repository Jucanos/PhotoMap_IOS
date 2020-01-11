//
//  KoreaMap.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 1515/01/10.
//  Copyright © 1515 김근수. All rights reserved.
//

import SwiftUI

struct KoreaMap: View {
    var body: some View {
        GeometryReader { gr in
            ZStack {
                NavigationLink(destination: FeedView(location: "경기도")) { CustomImage(location: "gyeonggi", size: gr.size)
                }
                .offset(x: -50, y: -151)
                .foregroundColor(.white)
                .shadow(radius: 10)
                NavigationLink(destination: FeedView(location: "강원도")) { CustomImage(location: "gangwon", size: gr.size)
                }
                .offset(x: 35, y: -158)
                .foregroundColor(.white)
                .shadow(radius: 10)
                NavigationLink(destination: FeedView(location: "충청남도")) { CustomImage(location: "chungnam", size: gr.size)
                }
                .offset(x: -71, y: -46)
                .foregroundColor(.white)
                .shadow(radius: 10)
                NavigationLink(destination: FeedView(location: "충청북도")) { CustomImage(location: "chungbuk", size: gr.size)
                }
                .offset(x: 13, y: -57)
                .foregroundColor(.white)
                .shadow(radius: 10)
                NavigationLink(destination: FeedView(location: "경상북도")) { CustomImage(location: "gyeongbuk", size: gr.size)
                }
                .offset(x: 73, y: -26)
                .foregroundColor(.white)
                .shadow(radius: 10)
                NavigationLink(destination: FeedView(location: "전라북도")) { CustomImage(location: "junbuk", size: gr.size)
                }
                .offset(x: -49, y: 32)
                .foregroundColor(.white)
                .shadow(radius: 10)
                NavigationLink(destination: FeedView(location: "경상남도")) { CustomImage(location: "gyeongnam", size: gr.size)
                }
                .offset(x: 59, y: 64)
                .foregroundColor(.white)
                .shadow(radius: 10)
                NavigationLink(destination: FeedView(location: "전라남도")) { CustomImage(location: "junnam", size: gr.size)
                }
                .offset(x: -62, y: 110)
                .foregroundColor(.white)
                .shadow(radius: 10)
                NavigationLink(destination: FeedView(location: "제주도")) { CustomImage(location: "jeju", size: gr.size)
                    
                }
                .offset(x: -62, y: 215)
                .foregroundColor(.white)
                .shadow(radius: 10)
                
            }
            .frame(width: gr.size.width, height: gr.size.height)
        }
    }
}

struct CustomImage: View {
    @State var location: String
    @State var size: CGSize
    
    var body: some View {
        Image("\(location)")
            //            .resizable()
            .scaledToFit()
        //            .frame(width: 150, height: 150)
    }
}



struct KoreaMap_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            KoreaMap()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            
            KoreaMap()
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            
            KoreaMap()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
        }
    }
}
