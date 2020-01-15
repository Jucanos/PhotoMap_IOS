//
//  GroupList.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct GroupList: View {
    
    @Binding var isSideMenuActive: Bool
    @State private var showActionSheet = false
    @State var groupData: [UserGroup] = [UserGroup(name: "test1", updateTime: "2020.01.01", imageName: "t"), UserGroup(name: "test2", updateTime: "2020.01.01", imageName: "t")]
    
    private var actionSheet: ActionSheet {
        ActionSheet(title: Text("그룹추가"), buttons: [
            .default(Text("그룹 추가하기"), action:{
                self.groupData.append(UserGroup(name: "add", updateTime: "2020.01.02", imageName: "url"))
            }),
            .destructive(Text("취소"))
        ])
    }
    
    var body: some View {
        ZStack {
            List(groupData) {group in
                ZStack{
                    GroupRow(group: group)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 3)
                    )
                    
                    NavigationLink(destination: GroupDetail(groupData: group, isSideMenuActive: self.$isSideMenuActive)
                    ){
                        EmptyView()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.showActionSheet.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 50,height: 50)
                    }
                    .offset(x: -10, y: -30)
                }
            }
        }
        .actionSheet(isPresented: $showActionSheet, content: {actionSheet})
        .onAppear{            
            UITableView.appearance().tableFooterView = UIView()
            UITableView.appearance().separatorStyle = .none
        }
    }
}

struct GroupList_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
