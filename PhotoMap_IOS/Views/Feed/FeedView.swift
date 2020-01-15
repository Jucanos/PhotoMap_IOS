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
    
    var body: some View {
        
        FeedDetail(masterViewSize: UIScreen.main.bounds.size)
            
            .navigationBarItems(leading:
                backButton, trailing:
                Button(action: {print(self.presentationMode)}) {
                    Image(systemName: "list.bullet")
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
                    .foregroundColor(.white)
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FeedView(location: "test")
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            
            FeedView(location: "test")
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            
            FeedView(location: "test")
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
        }
        
    }
}
