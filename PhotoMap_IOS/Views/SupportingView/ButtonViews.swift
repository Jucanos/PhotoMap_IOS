//
//  IconAndTextButton.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/15.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct IconAndTextButton: View {
    
    var imageName: String
    var buttonText: String
    
    let imageWidth: CGFloat = 40
    
    var body: some View {
        ZStack {
            Color.clear
            
            HStack {
                Spacer()
                Text(buttonText)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .foregroundColor(.white)
                ZStack{
                    Circle().foregroundColor(.white)
                    
                    Image(systemName: self.imageName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(appColor))
                        .padding(10)
                }.frame(width: self.imageWidth, height: self.imageWidth)
                
                
            }
            .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
        .frame(width: 200, height: 45)
        .cornerRadius(8)
    }
}
