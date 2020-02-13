//
//  UserWithdrawal.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/02/13.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct UserWithdrawal: View {
    @ObservedObject var userSettings = UserSettings.shared
    var body: some View {
        VStack {
            Spacer()
            Text("정말 회원탈퇴 하시겠습니까?\n\n회원탈퇴를 하시면 모든 데이터가 사라집니다.")
            Spacer()
            Button(action: {
                self.userSettings.userWithdrawal()
            }) {
                ZStack {
                    Color(.gray)
                    Text("회원탈퇴 하기")
                        .foregroundColor(.white)
                }
                .frame(height: 70)
            }
            .navigationBarTitle("회원탈퇴")
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct UserWithdrawal_Previews: PreviewProvider {
    static var previews: some View {
        UserWithdrawal()
    }
}
