//
//  UserLogout.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/19.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct UserLogout: View {
    @ObservedObject var userSettings = UserSettings.shared
    var body: some View {
        VStack {
            Spacer()
            Text("정말 로그아웃 하시겠습니까?")
                .font(.custom("NanumSquareRoundB", size: 17))
            
            Spacer()
            Button(action: {
                self.userSettings.userLogout()
            }) {
                ZStack {
                    Color(.gray)
                    Text("로그아웃 하기")
                        .font(.custom("NanumSquareRoundB", size: 17))
                        .foregroundColor(.white)
                }
                .frame(height: 70)
            }
            .navigationBarTitle("로그아웃")
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct UserLogout_Previews: PreviewProvider {
    static var previews: some View {
        UserLogout()
    }
}
