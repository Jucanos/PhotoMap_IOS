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
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("제목")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                TextField(self.selectedFeed!.title!.isEmpty ? "제목을 정해랏!" : self.selectedFeed!.title!,  text: self.$modifiedTitle)
                
                Spacer()
                    .frame(height: 100)
                
                Text("내용")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                TextField(self.selectedFeed!.context!.isEmpty ? "제목을 정해랏!" : self.selectedFeed!.context!,  text: self.$modifiedContext)
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("스토리 수정하기", displayMode: .inline)
            .navigationBarItems(leading: backButton, trailing: Button(action: {
                self.feedStore.modifyFeed(sid: (self.selectedFeed?.sid!)!,userTocken: self.userSettings.userTocken!, title: self.modifiedTitle, context: self.modifiedContext){
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("확인")
            })
        }
        .onAppear(){
            print(self.feedStore.feedData, self.userSettings)
        }
    }
    var backButton : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "multiply")
                    .resizable()
                    .frame(width: 20, height: 20)
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
