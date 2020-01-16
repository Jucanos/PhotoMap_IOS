//
//  AddGroup.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/16.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct AddGroup: View {
    let isOpen: Bool
    let menuClose: () -> Void
    var body: some View {
        ZStack{
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.black.opacity(0.7))
            .opacity(self.isOpen ? 1.0 : 0.0)            
            .onTapGesture {
                self.menuClose()
            }
            
            VStack {
                SubAddGroup()
                    .frame(height: 100)
                    .background(Color.black)
                    .offset(y: self.isOpen ? 0 : -UIScreen.main.bounds.height)
                    .animation(.easeInOut(duration: 0.25))
                Spacer()
            }
        }
    }
}

struct SubAddGroup: View {
    @State var groupName: String = ""
    var body: some View {
        
        VStack {
            Text("그룹 추가하기")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            HStack{
                TextField("그룹 이름을 입력하세요", text: $groupName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Image(systemName: "plus.square")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct AddGroup_Previews: PreviewProvider {
    static var previews: some View {
        SubAddGroup()
    }
}
