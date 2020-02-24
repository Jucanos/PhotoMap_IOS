//
//  AddGroup.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/16.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct AddGroup: View {
    @State var isLoading: Bool = false
    let isOpen: Bool
    let menuClose: () -> Void
    var body: some View {
        LoadingView(isShowing: $isLoading){
            ZStack{
                GeometryReader { _ in
                    EmptyView()
                }
                .background(Color.black.opacity(0.7))
                .onTapGesture {
                    self.menuClose()
                    self.endEditing()
                }
                
                VStack {
                    SubAddGroup(isLoading: self.$isLoading, menuClose: self.menuClose)
                        .frame(height: 90)
                        .background(Color(appColor))
                        //                        .offset(y: self.isOpen ? 0 : -UIScreen.main.bounds.height)
                        .offset(y: 0)
                    EmptyView().frame(height: 30)
                    Spacer()
                }
            }
            .opacity(self.isOpen ? 1.0 : 0.0)
            .animation(.default)
            .edgesIgnoringSafeArea(.bottom)
        }
        
    }
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

struct SubAddGroup: View {
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var userGroupStore = UserGroupStore.shared
    @State var groupName: String = ""
    @State var showAlert: Bool = false
    @Binding var isLoading: Bool
    let menuClose: () -> Void
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            Text("그룹생성")
                .font(.system(size: 25, weight: .heavy))
                .foregroundColor(.white)
                .padding(.leading, 15)
            HStack{
                TextField("그룹 이름을 입력하세요", text: $groupName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if self.groupName.isEmpty{
                        self.showAlert.toggle()
                    }else{
                        self.isLoading = true
                        self.userGroupStore.addMap(name: self.groupName){
                            self.isLoading = false
                            self.menuClose()
                            self.endEditing()
                        }
                    }
                }) {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
            }.padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text("그룹 이름이 없습니다"), message: Text("그룹 이름을 정한 후 추가해주세요!"), dismissButton: .default(Text("취소")))
        }
    }
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SubAddGroup_Previews: PreviewProvider {
    static var previews: some View {
        SubAddGroup(isLoading: .constant(false), menuClose: {})
    }
}
