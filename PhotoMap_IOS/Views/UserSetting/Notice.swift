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
    var body: some View {
        Group{
            if !noticeStore.noticeData.isEmpty{
                List{
                    ForEach(noticeStore.noticeData, id: \.id) { notice in
                        NoticeRow(notice: notice)
                    }
                }
                .listStyle(PlainListStyle())
            } else {
                Text("공지사항이 없습니다!")
            }
        }
        .navigationBarTitle("공지사항", displayMode: .inline)
        .onAppear(){
            self.noticeStore.loadNotice()
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
                        .font(.system(size: 20))
                }
                Spacer()
                isActivate ? Image(systemName: "chevron.up") : Image(systemName: "chevron.down")
            }
            .padding()
            .onTapGesture {
                self.isActivate.toggle()
            }
            if isActivate{
                Text(notice.context!)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .background(Color(.secondarySystemBackground))
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
