//
//  FeedView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/11.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct FeedView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var location: String
    var mapKey: String
    
    var body: some View {
        FeedDetail(mapKey: self.mapKey, masterViewSize: UIScreen.main.bounds.size).environmentObject(FeedStore())
            .navigationBarItems(leading:
                backButton, trailing:
                NavigationLink(destination: AddFeed()) {
                    Image(systemName: "plus.square")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
        )
            .navigationBarTitle("\(location)", displayMode: .inline)
    }
    
    var backButton : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
        }
    }
}
