//
//  TestView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/14.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct View1: View {
    @State var isNavigationBarHidden: Bool = true
    @State var col = Color.clear
    @State var isHidden = true
    var body: some View {
        
        ZStack {
            List(0 ..< 5) { item in
                Text("List contents")
            }
            VStack {
                FloatingButton(mainButtonView: AnyView(Sub1()), buttons: [AnyView(Sub2()),AnyView(Sub2()),AnyView(Sub2())], isButtonActivate: .constant(false))
                    .straight()
                    .direction(.top)
                    .alignment(.left)
                    .spacing(10)
                    .initialOpacity(0)
            }
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
