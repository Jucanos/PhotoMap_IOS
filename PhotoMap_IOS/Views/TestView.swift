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

    var body: some View {
        NavigationView {
            ZStack {
                Color.red
                NavigationLink("View 2", destination: View2(isNavigationBarHidden: self.$isNavigationBarHidden))
            }
            .navigationBarTitle("Hidden Title")
            .navigationBarHidden(self.isNavigationBarHidden)
            .onAppear {
                self.isNavigationBarHidden = true
            }
        }
    }
}

struct View2: View {
    @Binding var isNavigationBarHidden: Bool

    var body: some View {
        ZStack {
            Color.green
            NavigationLink("View 3", destination: View3())
        }
        .navigationBarTitle("Visible Title 1")
        .onAppear {
            self.isNavigationBarHidden = false
        }
    }
}

struct View3: View {
    var body: some View {
        Color.blue
            .navigationBarTitle("Visible Title 2")
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        View1()
    }
}
