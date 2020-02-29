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
                                            
                                        .onTapGesture {
                                            self.selectedGroup = group
                                            self.activateNavi = true
                                            print("tapped!")
                                        }
                                        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
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
                                    .default(Text("그룹 나가기").foregroundColor(.red), action: {
                                        self.groupStore.exitGroup(from: self.selectedGroup!.mid!)
                                    }),
                                    .default(Text("이름 바꾸기").font(.custom("NanumSquareRoundR", size: 15)), action: {
                                        self.showSheet.toggle()
                                    }),
                                    .cancel(Text("취소").font(.custom("NanumSquareRoundR", size: 15)))
                                ])
                            }
//                        .modifier(ActionSheetCustom())
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

//struct ActionSheetConfigurator: UIViewControllerRepresentable {
//    var configure: (UIAlertController) -> Void = { _ in }
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ActionSheetConfigurator>) -> UIViewController {
//        UIViewController()
//    }
//
//    func updateUIViewController(
//        _ uiViewController: UIViewController,
//        context: UIViewControllerRepresentableContext<ActionSheetConfigurator>) {
//        if let actionSheet = uiViewController.presentedViewController as? UIAlertController,
//            actionSheet.preferredStyle == .actionSheet {
//            self.configure(actionSheet)
//        }
//    }
//}
//
//struct ActionSheetCustom: ViewModifier {
//
//    func body(content: Content) -> some View {
//        content
//            .background(ActionSheetConfigurator { action in
//                action.view.tintColor = UIColor.black
//                let titleAttribute = [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 25)!, NSAttributedString.Key.foregroundColor: UIColor.black]
//
//                for item in action.actions {
//                    item.setValue(UIColor.yellow, forKey: "title")
//                }
//            })
//
//    }
//}
extension UIAlertController {
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.tintColor = .black
    }
}
