//
//  MainGroupView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct MainGroupView: View {
    
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var mapStore = MapStore.shared
    @ObservedObject var groupStore = UserGroupStore.shared
    @Binding var isSideMenuActive: Bool
    
    @State var showActionsheet = false
    @State var showSheet = false
    @State var selectedGroup: MapData?
    @State var activateNavi = false
    @State var isLoading = true
    
    var body: some View {
        LoadingView(isShowing: self.$isLoading) {
            Group{
                if self.groupStore.mapData != nil{
                    Group{
                        if self.groupStore.mapData!.isEmpty{
                            Text("그룹을 생성해주세요🤔")
                                .font(.custom("NanumSquareRoundR", size: 15))
                        }
                        else{
                            ZStack {
                                Color(.secondarySystemBackground)
                                List{
                                    ForEach(self.groupStore.mapData!, id: \.mid){ group in
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color(.white))
                                                .shadow(radius: 5)
                                            GroupRow(group: group)
                                                .padding()
                                        }
                                        .listRowInsets(.init(top: 30, leading: 10, bottom: 0, trailing: 10))
                                        .onTapGesture {
                                            self.selectedGroup = group
                                            self.activateNavi = true
                                            print("tapped!")
                                        }
                                        .onLongPressGesture {
                                            self.showActionsheet = true
                                            self.selectedGroup = group
                                        }
                                        
                                    }
                                }
                                NavigationLink(destination: GroupDetail(groupData: self.selectedGroup, isSideMenuActive: self.$isSideMenuActive), isActive: self.$activateNavi){
                                    Text("")
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .actionSheet(isPresented: self.$showActionsheet) {
                                ActionSheet(title: Text(""), buttons: [
                                    .default(Text("그룹 나가기"), action: {
                                        self.groupStore.exitGroup(from: self.selectedGroup!.mid!)
                                    }),
                                    .default(Text("이름 바꾸기"), action: {
                                        self.showSheet.toggle()
                                    }),
                                    .destructive(Text("취소"))
                                ])
                            }
                            .sheet(isPresented: self.$showSheet) {
                                ChangeGroupName(selectedGroup: self.$selectedGroup)
                            }
                        }
                    }
                    .onAppear(){
                        self.isLoading = false
                        self.mapStore.mapData = MapData()
                    }
                } else{
                    EmptyView()
                }
            }
        }
    }
}
