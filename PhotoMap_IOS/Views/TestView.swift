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
    @State var title: String = ""
    @State var showSub = false
    @State var showSheet = false
    var body: some View {
        VStack {
//            Button(action: {self.showSheet.toggle()}) {
//                Text("sheet")
//            }
//            .sheet(isPresented: $showSheet, onDismiss: {
//                self.showSub = true
//            }, content: {
//                Text("Sheet")
//            })
            Button(action: {self.showSub = true}) {
            Text(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/)
            }
            NavigationLink(destination: View2(), isActive: $showSub) {
                EmptyView()
            }
        }
    }
}

struct View2: View {
    var body: some View {
        Text("View2")
    }
}



struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        View1()
    }
}
