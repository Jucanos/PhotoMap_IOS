//
//  MainSettingView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct MainSettingView: View {
    var body: some View {
        VStack {
            UserInfoView()
            NavigationView {
                List {
                    Section(header: Text("앱 정보")) {
                        SettingRow(settingName: "공지사항")
                        SettingRow(settingName: "리뷰 작성하기")
                        SettingRow(settingName: "앱 공유하기")
                    }
                    Section(header: Text("회원정보관리")) {
                        SettingRow(settingName: "비밀번호 변경")
                        SettingRow(settingName: "로그아웃")
                    }
                }.listStyle(GroupedListStyle())
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
            }
        }
    }
}


struct SettingRow: View {
    @State var settingName: String
    var body: some View {
        Text("\(settingName)")
    }
}

struct UserInfoView: View {
    var body: some View {
        HStack {
            Image(systemName: "rectangle.stack.person.crop.fill")
                .resizable()
                .frame(width: 50, height: 50)
            Text("test0000@gmail.com")
                .font(.headline)
            
            Spacer()
        }
        .padding(5)
    }
}

struct MainSettingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainSettingView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            
            MainSettingView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            
            MainSettingView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
        }
    }
}
