//
//  GroupDetail.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/10.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct GroupDetail: View {
    
    init() {
        
        UINavigationBar.appearance().backgroundColor = .black
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    //    @State var groupData: UserGroup
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var backButton : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
            }
        }
    }
    
    var body: some View {
        
        KoreaMap()
            .navigationBarItems(leading:
                backButton, trailing:
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Image(systemName: "list.bullet")
                        .foregroundColor(.white)
                }
        )
            .navigationBarTitle("Test", displayMode: .inline)
    }
}

struct GroupDetail_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
