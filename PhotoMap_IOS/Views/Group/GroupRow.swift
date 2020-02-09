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
            URLImage(URL(string: "https://s3.soybeans.tech/uploads/\(group.mid!)/main.png")!){ proxy in
                proxy.image
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            VStack(alignment: .leading) {
                Text(verbatim: "\(group.name!)")
                    .font(.title)
                Text(group.updatedAt!)
                    .font(.footnote)
            }
            .padding(5)
            Spacer()
        }
    }
}

//struct GroupRow_Previews: PreviewProvider {
//    static var tgroup = UserGroup(name: "test", updateTime: "2020.01.01", imageName: "uir")
//
//    static var previews: some View {
//        Group{
//            GroupRow(group: tgroup)
//        }
//        .previewLayout(.fixed(width: 300, height: 70))
//    }
//}
