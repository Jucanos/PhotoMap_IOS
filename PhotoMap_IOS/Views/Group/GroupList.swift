//
//  GroupList.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct GroupList: View {
    
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
    
    init() {
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        VStack {
            NavigationView {
                List(groupData) {group in
                    GroupRow(group: group)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 3)
                    )
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
            .overlay(
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
                    .actionSheet(isPresented: $showActionSheet, content: {actionSheet})
            }, alignment: .bottomTrailing)
        }
    }
}

struct GroupList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GroupList()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            
            GroupList()
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            
            GroupList()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
        }
    }
}
