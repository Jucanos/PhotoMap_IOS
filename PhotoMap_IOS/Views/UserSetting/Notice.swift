//
//  Notice.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/02/11.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct Notice: View {
    @ObservedObject var noticeStore = AppNoticeStore.shared
    @State var isLoading: Bool = false
    var body: some View {
        LoadingView(isShowing: self.$isLoading){
            Group{
                if self.noticeStore.noticeData != nil{
                    Group{
                        if !self.noticeStore.noticeData!.isEmpty{
                            List{
                                ForEach(self.noticeStore.noticeData!, id: \.id) { notice in
                                    NoticeRow(notice: notice)
                                }
                            }
                            .listStyle(PlainListStyle())
                        } else {
                            Text("공지사항이 없습니다!")
                        }
                    }
                } else {
                    EmptyView()
                }
            }
        }
        .navigationBarTitle("공지사항", displayMode: .inline)
        .onAppear(){
            self.isLoading = true
            self.noticeStore.loadNotice(){
                self.isLoading = false
            }
        }
    }
}

struct NoticeRow: View {
    @State var isActivate: Bool = false
    var notice: AppNoticeData
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(notice.updatedAt!)
                        .foregroundColor(.gray)
                    Text(notice.title!)
                }
                Spacer()
                isActivate ? Image(systemName: "chevron.up") : Image(systemName: "chevron.down")
            }
            .padding()
            .onTapGesture {
                self.isActivate.toggle()
            }
            if isActivate{
                ZStack(alignment: .leading){
                    Color(.secondarySystemBackground)
                    Text(notice.context!)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .animation(.spring())
    }
}

//struct Notice_Previews: PreviewProvider {
//    static var previews: some View {
//        Notice()
//    }
//}
