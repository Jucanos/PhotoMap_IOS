//
//  TestView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/14.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import Request

struct View1: View {
    @State var isNavigationBarHidden: Bool = true
    @State var col = Color.clear
    @State var isHidden = true
//    @EnvironmentObject var testItems: [String]
    var body: some View {
        Button(action: {
                    let authUrl = NetworkURL.sharedInstance.getUrlString("/users")
                    AnyRequest<UserInfo>{
                        Url(authUrl)
                        Method(.get)
                        Header.Authorization(.bearer("self.$userTocken"))
                    }.onObject { usrInfo in
                        print(usrInfo)
                    }
        }) {
        Text(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/)
        }
    }
}

struct Sub1: View {
    
    var body: some View {
        
        Text("sub1")
        
    }
}

struct Sub2: View {
    @State var col = Color(.red)
    var body: some View {
        
        Button(action: {self.col = Color(.blue)}) {
            Text("Button")
        }.foregroundColor(col)
        
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        View1()
    }
}
