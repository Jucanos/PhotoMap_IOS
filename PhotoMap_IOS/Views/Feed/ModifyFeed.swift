//
//  ModifyFeed.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/02/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct ModifyFeed: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var feedStore: FeedStore
    @EnvironmentObject var userSettings: UserSettings
    @Binding var selectedFeed: FeedData?
    @State var modifiedTitle: String = ""
    @State var modifiedContext: String = ""
    @State var isLoading = false
    @State var showAlert = false
    
    var body: some View {
        NavigationView {
            LoadingView(isShowing: self.$isLoading){
                VStack(alignment: .leading) {
                    Text("제목")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    TextField(self.selectedFeed!.title!.isEmpty ? "제목을 정해주세요!" : self.selectedFeed!.title!,  text: self.$modifiedTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Spacer()
                        .frame(height: 100)
                    
                    Text("내용")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    TextField(self.selectedFeed!.context!.isEmpty ? "내용을 정해주세요!" : self.selectedFeed!.context!,  text: self.$modifiedContext)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                }
            }
            .padding()
            .alert(isPresented: self.$showAlert){
                Alert(title: Text("제목이 없습니다!"), dismissButton: .default(Text("확인")))
            }
            .navigationBarTitle("스토리 수정하기", displayMode: .inline)
            .navigationBarItems(leading: backButton, trailing: Button(action: {
                if self.modifiedTitle.isEmpty{
                    self.showAlert = true
                } else{
                    self.isLoading = true
                    self.feedStore.modifyFeed(sid: (self.selectedFeed?.sid!)!,userTocken: self.userSettings.userTocken!, title: self.modifiedTitle, context: self.modifiedContext){
                        self.isLoading = false
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }) {
                Text("확인")
            })
        }
    }
    var backButton : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "multiply")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.white)
            }
        }
    }
}

//struct ModifyFeed_Previews: PreviewProvider {
//    static var previews: some View {
//        ModifyFeed()
//    }
//}
