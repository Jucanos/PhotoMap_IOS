//
//  UserLogout.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/19.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct UserLogout: View {
    @EnvironmentObject var userSettings: UserSettings
    var body: some View {
        HStack {
            VStack {
                Spacer()
                Text("정말 로그아웃 하시겠습니까?\n\n로그아웃 시 모든 정보가 사라집니다.")
                Spacer()
                Button(action: {
                    self.userSettings.userLogout()
                }) {
                    ZStack {
                        Color(.gray)
                        Text("로그아웃 하기")
                            .foregroundColor(.white)
                    }
                .frame(height: 50)
                }
                .navigationBarTitle("로그아웃")
            }
        }
    }
}

struct UserLogout_Previews: PreviewProvider {
    static var previews: some View {
        UserLogout()
    }
}
