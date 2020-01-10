//
//  GroupRow.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct GroupRow: View {
    var group: UserGroup
    var body: some View {
        HStack{
            Image(systemName: "1.circle")
                .resizable()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(verbatim: "\(group.name)")
                    .font(.title)
                Text("Update at: \(group.updateTime)")
                    .font(.footnote)
            }
            .padding(5)
            Spacer()
        }
    }
}

struct GroupRow_Previews: PreviewProvider {
    static var tgroup = UserGroup(name: "test", updateTime: "2020.01.01", imageName: "uir")
    
    static var previews: some View {
        Group{
            GroupRow(group: tgroup)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
