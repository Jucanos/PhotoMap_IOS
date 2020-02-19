//
//  LoadingView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/02/19.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text("Loading...")
                        .foregroundColor(Color(appColor))
                    ActivityIndicator(isAnimating: self.$isShowing)
                        .configure {$0.color = appColor
                            $0.style = .large
                    }
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
//                .background(Color.secondary.colorInvert())
//                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }

}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isShowing: .constant(true)) {
            Text("test")
        }
    }
}
