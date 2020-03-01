//
//  ChangeGroupName.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/02/11.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct ChangeGroupName: View {
    @Binding var selectedGroup: MapData?
    @ObservedObject var groupStore = UserGroupStore.shared
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var strFromUser: String = ""
    @State var isLoading = false
    @State var showAlert = false
    var body: some View {
        NavigationView {
            LoadingView(isShowing: self.$isLoading){
                GeometryReader{ geo in
                    VStack(alignment: .leading){
                        Text("그룹의 이름을 입력해 주세요")
                            .font(.custom("NanumSquareRoundB", size: 17))
                            .foregroundColor(.gray)
                        Spacer()
                            .frame(height: 30)
                        TextField(self.selectedGroup!.name!, text: self.$strFromUser)
                            .font(.custom("NanumSquareRoundR", size: 17))
                        Divider()
                            .background(Color.gray)
                    }
                    .offset(y: -geo.frame(in: .global).size.width / 1.5)
                }
                .padding()
                .navigationBarTitle("그룹 이름", displayMode: .inline)
                .navigationBarItems(leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "multiply")
                            .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                    }, trailing:
                    Button(action: {
                        if self.strFromUser.isEmpty {
                            self.showAlert = true
                        } else {
                            self.isLoading = true
                            self.groupStore.changeGroupName(mid: self.selectedGroup!.mid!, newName: self.strFromUser) {
                                self.isLoading = false
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }) {
                        Text("확인")
                        .font(.custom("NanumSquareRoundB", size: 17))
                })
                    .alert(isPresented: self.$showAlert) {
                        Alert(title: Text("바꿀 이름을 입력해주세요"))
                }
            }
            
        }
    }
}
