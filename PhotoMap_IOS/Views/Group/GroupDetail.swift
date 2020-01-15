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
    @State private var isButtonActivate = false
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
            }
            ZStack {
                Color(.black).opacity(isButtonActivate ? 0.7 : 0)
                VStack {
                    Spacer().layoutPriority(10)
                    HStack {
                        Spacer().layoutPriority(10)
                        FloatingButton(mainButtonView: AnyView(mainButton), buttons: [AnyView(shareButton),AnyView(storeImageButton),AnyView(setRepImageButton)], isButtonActivate: self.$isButtonActivate)
                            .straight()
                            .direction(.top)
                            .alignment(.right)
                            .spacing(10)
                            .initialOpacity(0)
                            .padding()
                    }
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
    
    var mainButton: some View {
        Image(systemName: "plus.circle.fill")
            .resizable()
            .frame(width: 50, height: 50)
            .clipShape(Circle())
        
    }
    
    var setRepImageButton: some View {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
            IconAndTextButton(imageName: "map.fill", buttonText: "대표지도 설정")
        }
    }
    
    var storeImageButton: some View {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
            IconAndTextButton(imageName: "square.and.arrow.down.fill", buttonText: "이미지로 저장하기")
        }
    }
    
    var shareButton: some View {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
            IconAndTextButton(imageName: "square.and.arrow.up.fill", buttonText: "공유하기")
        }
    }
    
}

struct GroupDetail_Previews: PreviewProvider {
    
    static var previews: some View {
        GroupDetail(groupData: UserGroup(name: "test", updateTime: "test", imageName: "fse"), isNavigationBarHidden: .constant(true), isSideMenuActive: .constant(false))
        //        SplashView()
    }
}
