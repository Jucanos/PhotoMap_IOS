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
    @EnvironmentObject var mapStore: MapStore
    @ObservedObject var groupStore = UserGroupStore.shared
    @Binding var isSideMenuActive: Bool
    
    @State var showActionsheet = false
    @State var showSheet = false
    @State var selectedGroup: MapData?
    @State var activateNavi = false
    
    var body: some View {
        Group{
            if self.groupStore.mapData.isEmpty{
                Text("그룹을 생성해주세요!")
            }
            else{
                ZStack {
                    Color(.secondarySystemBackground)
                    List{
                        ForEach(groupStore.mapData, id: \.mid){ group in
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
        .onAppear{
            UITableView.appearance().backgroundColor = UIColor.clear
            UITableViewCell.appearance().backgroundColor = UIColor.clear
            self.mapStore.mapData = MapData()
        }
    }
    
//    func deleteGroup(at indexSet: IndexSet) {
//        let curMid = self.groupStore.mapData[indexSet.first!].mid
//        self.groupStore.deleteMap(mid: curMid!, userTocken: self.userSettings.userTocken!)
//        self.groupStore.mapData.remove(atOffsets: indexSet)
//    }
}

//extension UITableViewController {
//    override open func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        let appearance = UITableView.appearance()
//        appearance.tableFooterView = UIView()
//        appearance.separatorStyle = .none
//        appearance.backgroundColor = UIColor.clear
//        
//        
//        let cellAppearance = UITableViewCell.appearance()
//        cellAppearance.backgroundColor = UIColor.clear
//    }
//}
