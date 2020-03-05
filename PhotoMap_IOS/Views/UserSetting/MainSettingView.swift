//
//  MainSettingView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import URLImage

struct MainSettingView: View {
    var body: some View {
        VStack(spacing: 5) {
            UserInfoView()
                .padding(10)
            List {
                Section(header: Text("앱 정보").font(.custom("NanumSquareRoundL", size: 12))) {
                    NavigationLink(destination: Notice()) {
                        SettingRow(setImage: "exclamationmark.bubble", settingName: "공지사항")
                    }
                    NavigationLink(destination: Review()) {
                        SettingRow(setImage: "ellipses.bubble",settingName: "리뷰 작성하기")
                    }
                    NavigationLink(destination: AppSharing()) {
                        SettingRow(setImage: "square.and.arrow.up",settingName: "앱 공유하기")
                    }
                }
                Section(header: Text("회원정보관리").font(.custom("NanumSquareRoundL", size: 12))) {
                    NavigationLink(destination: UserLogout()) {
                        SettingRow(setImage: "person.crop.circle.badge.exclam",settingName: "로그아웃")
                    }
                    NavigationLink(destination: UserWithdrawal()) {
                        SettingRow(setImage: "person.crop.circle.badge.xmark",settingName: "회원탈퇴")
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
    }
    
}


struct SettingRow: View {
    @State var setImage: String
    @State var settingName: String
    var body: some View {
        HStack{
            Image(systemName: setImage)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Color(appColor))
            Text("\(settingName)")
                .font(.custom("NanumSquareRoundR", size: 17))
        }
        
    }
}

struct UserInfoView: View {
    var body: some View {
        HStack(spacing: 15) {
            URLImage(URL(string: (UserSettings.shared.userInfo?.data?.thumbnail!)!)!) { proxy in
                proxy.image
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 55, height: 55)
            }
            Text((UserSettings.shared.userInfo?.data?.nickname!)!)
                .font(.custom("NanumSquareRoundB", size: 20))
            Spacer()
        }
    }
}
