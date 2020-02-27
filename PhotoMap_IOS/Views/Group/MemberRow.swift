//
//  MemberRow.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/15.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import URLImage

struct MemberRow: View {
    var member: UserInfoData
    var body: some View {
        HStack{
            URLImage(URL(string: member.thumbnail!)!) { proxy in
                proxy.image
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: 50, height: 50)
            }
            Text(member.nickname!)
                .font(.custom("NanumSquareRoundR", size: 15))
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
