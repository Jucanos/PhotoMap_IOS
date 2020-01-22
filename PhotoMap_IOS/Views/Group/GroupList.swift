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
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var groupData: UserGroupData
    
    var body: some View {
        ZStack {
            List(groupData.mapData, id: \.mid) {group in
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
        }
        .onAppear{            
            UITableView.appearance().tableFooterView = UIView()
            UITableView.appearance().separatorStyle = .none
//            self.groupData.loadMapData(userTocken: self.userSettings.userTocken!)
        }
    }
}

struct GroupList_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
