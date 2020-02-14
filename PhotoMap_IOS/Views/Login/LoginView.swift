//
//  ContentView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/05.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import KakaoOpenSDK
import Request




struct LoginView: View {
    @ObservedObject var userSettings = UserSettings.shared
    
    var body: some View {
        GeometryReader{ geo in
            VStack(alignment: .center, spacing: 40) {
                VStack(spacing: 10) {
                    Text("PhotoMap")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    Image("mainlogo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red)
                        .frame(height: geo.size.height / 3)
                }
                .shadow(radius: 5)
                Spacer()
                    .frame(height: 10)
                VStack() {
                    Text("포토맵에 오신것을 환영합니다!")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Button(action: {
                        self.userSettings.loginFromKakao()
                    }){
                        KakaoLoginButton()
                            .scaledToFit()
                    }
                }
                .shadow(radius: 5)
            }
        }
        .padding()
        .background(Color(appColor))
        .edgesIgnoringSafeArea(.all)
        .onAppear(){
            self.userSettings.getAuthFromServer()
        }
    }
}

struct Login_Pre: PreviewProvider {
    static var previews: some View {
        Group{
            LoginView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            LoginView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            LoginView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewDisplayName("iPhone 11")
        }
    }
}
