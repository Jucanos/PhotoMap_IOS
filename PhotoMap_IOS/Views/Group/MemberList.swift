//
//  MemberList.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/12.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct MemberList: View {
    var body: some View {
        List(0 ..< 5) { item in
            Text("Member List after")
        }
    }
}

struct MemberList_Previews: PreviewProvider {
    static var previews: some View {
        MemberList()
    }
}
