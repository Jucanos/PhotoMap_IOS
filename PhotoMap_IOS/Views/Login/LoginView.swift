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


let appColor = Color(red: 0.976, green: 0.875, blue: 0.196)

struct LoginView: View {
    @ObservedObject var userSettings = UserSettings.shared
    
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
                self.userSettings.loginFromKakao()
            }){
                KakaoLoginButton()
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 10)
            }
            Spacer()
        }
        .padding()
        .background(appColor)
        .edgesIgnoringSafeArea(.all)
        .onAppear(){
            self.userSettings.getAuthFromServer()
        }
    }
}
