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
    @State var selectedGroup: String?
    
    var body: some View {
        Group{
            if self.groupStore.mapData.isEmpty{
                Text("그룹을 생성해주세요!")
            }
            else{
                ZStack {
                    List{
                        ForEach(groupStore.mapData, id: \.mid){ group in
                            ZStack{
                                GroupRow(group: group)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.clear, lineWidth: 1)
                                            .shadow(radius: 5))
                                    .gesture(LongPressGesture()
                                        .onEnded{ _ in
                                            self.showActionsheet = true
                                            self.selectedGroup = group.mid
                                    })
                                
                                NavigationLink(destination: GroupDetail(groupData: group, isSideMenuActive: self.$isSideMenuActive)
                                ){
                                    EmptyView()
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .onDelete(perform: deleteGroup)
                    }
                }
                .actionSheet(isPresented: self.$showActionsheet) {
                    ActionSheet(title: Text(""), buttons: [
                        .default(Text("그룹 나가기"), action: {
                            self.groupStore.exitGroup(from: self.selectedGroup!)
                        }),
                        .destructive(Text("취소"))
                    ])
                }
            }
        }
        .onAppear{
            UITableView.appearance().tableFooterView = UIView()
            UITableView.appearance().separatorStyle = .none
            self.mapStore.mapData = MapData()
        }
    }
    
    func deleteGroup(at indexSet: IndexSet) {
        let curMid = self.groupStore.mapData[indexSet.first!].mid
        self.groupStore.deleteMap(mid: curMid!, userTocken: self.userSettings.userTocken!)
        self.groupStore.mapData.remove(atOffsets: indexSet)
    }
}

//struct MainGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            MainGroupView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
//                .previewDisplayName("iPhone SE")
//
//            MainGroupView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
//                .previewDisplayName("iPhone 8")
//
//            MainGroupView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
//                .previewDisplayName("iPhone 11 Pro")
//        }
//    }
//}
