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
    var body: some View {
        NavigationView {
            GeometryReader{ geo in
                VStack(alignment: .leading){
                    Text("그룹의 이름을 입력해 주세요")
                        .foregroundColor(.gray)
                    Spacer()
                        .frame(height: 20)
                    TextField(self.selectedGroup!.name!, text: self.$strFromUser)
                    Divider()
                    .background(Color.gray)
                }
                .offset(y: -geo.frame(in: .global).size.width / 2)
            }
            .padding()
            .navigationBarTitle("그룹 이름", displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "multiply")
                        .resizable()
                        .foregroundColor(.white)
                }, trailing:
                Button(action: {
                    self.groupStore.changeGroupName(mid: self.selectedGroup!.mid!, newName: self.strFromUser) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("확인")
                        .foregroundColor(.white)
            })
        }
    }
}

//struct ChangeGroupName_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangeGroupName()
//    }
//}
