//
//  MemberRow.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/15.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct MemberRow: View {
    @State var member: UserInfoData
    var body: some View {
        HStack{
            Image(systemName: "person.crop.square.fill")
                .resizable()
                .frame(width: 30, height: 30)
            
            Text(verbatim: "user")
                    .font(.headline)
            Spacer()
        }
    }
}

//struct MemberRow_Previews: PreviewProvider {
//    static var previews: some View {
//        MemberRow()
//            .previewLayout(.fixed(width: 415, height: 50))
//    }
//}
