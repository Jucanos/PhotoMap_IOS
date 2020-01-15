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
    
    let imageWidth: CGFloat = 22
    
    var body: some View {
        ZStack {
            Color.clear
            
            HStack {
                Spacer()
                Text(buttonText)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .foregroundColor(Color(.white))
                Image(systemName: self.imageName)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .foregroundColor(.black)
                    .frame(width: self.imageWidth, height: self.imageWidth)
                    .clipped()                
            }.padding(.leading, 15).padding(.trailing, 15)
        }
        .frame(width: 190, height: 45)
        .cornerRadius(8)
    }
}

struct MainButton: View {
    
    var imageName: String
    //    var colorHex: String
    
    var width: CGFloat = 50
    
    var body: some View {
        //        ZStack {
        //            Color(hex: colorHex)
        //                .frame(width: width, height: width)
        //                .cornerRadius(width/2)
        //                .shadow(color: Color(hex: colorHex).opacity(0.3), radius: 15, x: 0, y: 15)
        //            Image(systemName: imageName).foregroundColor(.black)
        //        }
        Image(systemName: imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
//            .frame(width: width, height: width)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.red, lineWidth: 5))
    }
}
