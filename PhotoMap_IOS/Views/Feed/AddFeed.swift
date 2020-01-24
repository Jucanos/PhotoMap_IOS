//
//  AddFeed.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/24.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct AddFeed: View {
    @State var title: String = ""
    var body: some View {
        
        VStack {
            Text("피드의 제목을 정해주세요!")
            TextField("피드 제목", text: $title)
            
        }
        .navigationBarTitle("피드 추가하기")
    }
}

struct AddFeed_Previews: PreviewProvider {
    static var previews: some View {
        AddFeed()
    }
}
