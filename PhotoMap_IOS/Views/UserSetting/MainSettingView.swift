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
        VStack {
            UserInfoView()
                .padding()
            List {
                Section(header: Text("앱 정보")) {
                    NavigationLink(destination: Notice()) {
                        SettingRow(setImage: "exclamationmark.bubble", settingName: "공지사항")
                    }
                    SettingRow(setImage: "ellipses.bubble",settingName: "리뷰 작성하기")
                    SettingRow(setImage: "square.and.arrow.up",settingName: "앱 공유하기")
                }
                Section(header: Text("회원정보관리")) {
                    SettingRow(setImage: "lock",settingName: "비밀번호 변경")
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
                .frame(width: 20, height: 20)
                .foregroundColor(Color(appColor))
            Text("\(settingName)")
        }
        
    }
}

struct UserInfoView: View {
    var body: some View {
        HStack {
            URLImage(URL(string: (UserSettings.shared.userInfo?.data?.thumbnail!)!)!) { proxy in
                proxy.image
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: 50, height: 50)
            }
            Text((UserSettings.shared.userInfo?.data?.nickname!)!)
                .font(.title)
            
            Spacer()
        }
    }
}

struct MainSettingView_Previews: PreviewProvider {
    static var previews: some View {
//        Group {
//            MainSettingView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
//                .previewDisplayName("iPhone SE")
//
//            MainSettingView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
//                .previewDisplayName("iPhone 8")
//
//            MainSettingView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
//                .previewDisplayName("iPhone 11 Pro")
//        }
        UserInfoView()
    }
}
