//
//  GroupDetail.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/10.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct GroupDetail: View {
    
    @State var groupData: UserGroup // State later
    @State private var menuOpen = false
    @Binding var isNavigationBarHidden: Bool
    @Binding var isSideMenuActive: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            KoreaMap()
                .navigationBarItems(leading:
                    backButton, trailing:
                    Button(action: {self.isSideMenuActive.toggle()}) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(.white)
                    }
            )
                .navigationBarTitle("\(groupData.name)", displayMode: .inline)
                .onAppear{
                    self.isNavigationBarHidden = false
                    
                    //                .overlay(GroupSideMenu(width: UIScreen.main.bounds.width * 0.7, isOpen: self.menuOpen, menuClose: self.openMenu)
                    //                    .edgesIgnoringSafeArea(.all))
//            GroupSideMenu(width: UIScreen.main.bounds.width * 0.7, isOpen: self.menuOpen, menuClose: self.openMenu)
                    
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 50,height: 50)
                    }
                    .offset(x: -10, y: -30)
                }
            }
        }
        
    }
    
    
    
    var backButton : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
            }
        }
    }
}

//struct GroupDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupDetail(groupData: UserGroup(name: "test", updateTime: "test", imageName: "fse"))
//        //        SplashView()
//    }
//}
