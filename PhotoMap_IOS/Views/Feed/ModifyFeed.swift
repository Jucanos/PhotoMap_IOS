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
    @Binding var selectedFeed: FeedData?
    @State var modifiedTitle: String = ""
    @State var modifiedContext: String = ""
    @State var isLoading = false
    
    var body: some View {
        NavigationView {
            LoadingView(isShowing: self.$isLoading){
                VStack(alignment: .leading) {
                    Text("제목")
                        .font(.custom("NanumSquareRoundB", size: 25))
                    VStack(spacing: 2){
                        TextField(self.selectedFeed!.title!.isEmpty ? "제목을 정해주세요!" : self.selectedFeed!.title!,  text: self.$modifiedTitle)
                            .font(.custom("NanumSquareRoundR", size: 15))
                        Divider().foregroundColor(Color(.lightGray))
                    }
                    Spacer()
                        .frame(height: 100)
                    Text("내용")
                        .font(.custom("NanumSquareRoundB", size: 25))
                    VStack(spacing: 2) {
                        TextField(self.selectedFeed!.context!.isEmpty ? "내용을 정해주세요!" : self.selectedFeed!.context!,  text: self.$modifiedContext)
                            .font(.custom("NanumSquareRoundR", size: 15))
                        Divider().foregroundColor(Color(.lightGray))
                    }
                    Spacer()
                }
            }
            .padding()
            .navigationBarTitle("스토리 수정하기", displayMode: .inline)
            .navigationBarItems(leading: backButton, trailing: Button(action: {
                if self.modifiedTitle.isEmpty{
                    self.modifiedTitle = (self.selectedFeed?.title!)!
                }
                self.isLoading = true
                self.feedStore.modifyFeed(sid: (self.selectedFeed?.sid!)!, title: self.modifiedTitle, context: self.modifiedContext){
                    self.isLoading = false
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("확인")
                    .font(.custom("NanumSquareRoundR", size: 17))
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
