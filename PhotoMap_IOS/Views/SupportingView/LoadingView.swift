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
                VStack {
                    ActivityIndicator(isAnimating: self.$isShowing)
                        .configure {$0.color = appColor
                            $0.style = .large
                    }
                }
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
