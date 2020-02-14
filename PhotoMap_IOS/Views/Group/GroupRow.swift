//
//  GroupRow.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import URLImage
struct GroupRow: View {
    var group: MapData
    var body: some View {
        HStack{
            ZStack {
                URLImage(URL(string: "https://s3.soybeans.tech/uploads/\(group.mid!)/main.png")!, expireAfter: Date(timeIntervalSinceNow: 0.1)){ proxy in
                    proxy.image
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                //                ZStack {
                //                    Circle()
                //                        .frame(width: 20, height: 20)
                //                        .foregroundColor(.red)
                //                    Text("1")
                //                        .foregroundColor(.white)
                //                }
                //                .frame(width: 15, height: 15)
                //                .foregroundColor(.red)
                //                .offset(x: 20, y: -20)
            }
            VStack(alignment: .leading) {
                Text(verbatim: "\(group.name!)")
                    .font(.title)
                Text(group.updatedAt ?? "")
                    .font(.footnote)
            }
            .padding(5)
            Spacer()
            
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.yellow)
                .opacity(UserSettings.shared.userInfo?.data?.primary == group.mid ? 1 : 0)
        }
    }
}

//struct GroupRow_Previews: PreviewProvider {
//    static var tgroup = MapData(name: "Test", updatedAt: "2020.01.01")
//
//    static var previews: some View {
//        Group{
//            GroupRow(group: tgroup)
//        }
//        .previewLayout(.fixed(width: 300, height: 70))
//    }
//}
