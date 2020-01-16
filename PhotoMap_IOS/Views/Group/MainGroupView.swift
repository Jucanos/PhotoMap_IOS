//
//  MainGroupView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct MainGroupView: View {
    @State var isEmpty = false
    @Binding var isSideMenuActive: Bool
    
    var body: some View {
        return Group{
            if isEmpty{
                Text("그룹을 생성해주세요!")
            }
            else{
                GroupList(isSideMenuActive: self.$isSideMenuActive)
            }
        }
        
    }
}

//struct MainGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            MainGroupView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
//                .previewDisplayName("iPhone SE")
//
//            MainGroupView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
//                .previewDisplayName("iPhone 8")
//
//            MainGroupView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
//                .previewDisplayName("iPhone 11 Pro")
//        }
//    }
//}
