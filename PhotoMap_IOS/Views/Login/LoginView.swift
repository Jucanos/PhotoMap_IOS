//
//  ContentView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/05.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

let appColor = Color(red: 0.976, green: 0.875, blue: 0.196)

struct LoginView: View {
    @Binding var isAuth: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            Image("mainlogo")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .scaledToFit()
                .padding(.top, 80)
            
            Spacer()
            
            Text("포토맵에 오신것을 환영합니다!")
                .font(.body)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Button(action: {
                if self.testAct() {
                    self.isAuth = true
                }
            }) {
                KakaoLoginButton()
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 10)
            }
            Spacer()
        }
        .padding()
        .background(appColor)
        .edgesIgnoringSafeArea(.all)
    }
    
    func testAct() -> Bool {
        print("button tapped!")
        return true
    }
}




#if DEBUG
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            LoginView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
//                .previewDisplayName("iPhone SE")
//
//            LoginView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
//                .previewDisplayName("iPhone 8")
//
//            LoginView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
//                .previewDisplayName("iPhone 11 Pro")
//        }
//    }
//}
#endif
