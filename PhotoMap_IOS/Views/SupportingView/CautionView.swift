//
//  CautionView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/02/25.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct CautionView: View {
    let imageName: String
    let context : String
    var body: some View {
        GeometryReader {gr in
            VStack(spacing: 40) {
                Image(systemName: self.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: gr.size.width * 0.7)
                    .foregroundColor(Color(appColor))
                    .shadow(radius: 1)
                Text("\(self.context)")
                    .fontWeight(.medium)
            }.offset(y: -80)
        }
    }
}

//struct CautionView_Previews: PreviewProvider {
//    static var previews: some View {
//        CautionView(imageName: <#String#>)
//    }
//}
