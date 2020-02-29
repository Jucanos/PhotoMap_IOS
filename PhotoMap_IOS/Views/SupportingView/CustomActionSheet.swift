//
//  CustomActionSheet.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/02/28.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct CustomActionSheet: View {
    @Binding var showSheet: Bool
    var title: String?
    var buttons: [Button<Text>]
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(showSheet ? 0.6 : 0)
                .animation(.default)
                .edgesIgnoringSafeArea([.top, .bottom])
                .onTapGesture {
                    self.showSheet = false
            }
            VStack {
                Spacer()
                VStack(spacing: 15) {
                    VStack(spacing: 0){
                        Group{
                            if self.title != nil {
                                Text(title!)
                                .font(.custom("NanumSquareRoundB", size: 15))
                                .padding(15)
                            } else{
                                EmptyView()
                            }
                        }
                        
                        ForEach(0 ..< buttons.count, id: \.self) { i in
                            VStack(spacing: 2){
                                Divider()
                                self.buttons[i]
                                    .padding(15)
                                    .frame(width: UIScreen.main.bounds.size.width * 0.8)
                            }
                            .frame(width: UIScreen.main.bounds.size.width * 0.8)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.size.width * 0.8)
                    .background(Color(.white).frame(width: UIScreen.main.bounds.size.width * 0.8)
                    .cornerRadius(10))
                    
                    Button(action: {self.showSheet = false}) {
                        Text("취소")
                            .foregroundColor(.black)
                            .font(.custom("NanumSquareRoundB", size: 15))
                            .padding(10)
                    }
                    .frame(width: UIScreen.main.bounds.size.width * 0.8)
                    .background(Color(.white).frame(width: UIScreen.main.bounds.size.width * 0.8).cornerRadius(10))
                }
            }
            .offset(y: showSheet ? 0 : UIScreen.main.bounds.size.height)
            .animation(.default)
        }
    }
}

//struct CustomActionSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomActionSheet()
//    }
//}
