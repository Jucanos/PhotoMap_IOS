//
//  KoreaMap.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/10.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct KoreaMap: View {
    var body: some View {
        GeometryReader { gr in
            ZStack {
                CustomImage(location: "gyeonggi", size: gr.size)
                    .offset(x: -50, y: -151)
                CustomImage(location: "gangwon", size: gr.size)
                    .offset(x: 35, y: -158)
                CustomImage(location: "chungnam", size: gr.size)
                    .offset(x: -71, y: -46)
                CustomImage(location: "chungbuk", size: gr.size)
                    .offset(x: 13, y: -57)
                CustomImage(location: "gyeongbuk", size: gr.size)
                    .offset(x: 73, y: -26)
                CustomImage(location: "junbuk", size: gr.size)
                    .offset(x: -49, y: 32)
                CustomImage(location: "gyeongnam", size: gr.size)
                    .offset(x: 59, y: 64)
                CustomImage(location: "junnam", size: gr.size)
                    .offset(x: -62, y: 110)
                CustomImage(location: "jeju", size: gr.size)
                    .offset(x: -62, y: 220)
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
        //            .frame(width: 200, height: 200)
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
            KoreaMap()
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch)"))
                .previewDisplayName("iPad Pro (12.9-inch)")
        }
    }
}
