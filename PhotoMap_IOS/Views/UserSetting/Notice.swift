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
        List(0 ..< 5) {_ in
              NoticeRow()
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("공지사항", displayMode: .inline)
        .onAppear(){
            self.noticeStore.loadNotice()
        }
    }
}

struct NoticeRow: View {
    @State var isActivate: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("2020.01.01")
                        .foregroundColor(.gray)
                    Text("오픈 공지 오픈 공지 오픈 공지")
                        .font(.system(size: 20))
                }
                Spacer()
                isActivate ? Image(systemName: "chevron.up") : Image(systemName: "chevron.down")
            }
            .onTapGesture {
                self.isActivate.toggle()
            }
            if isActivate{
                Text("ContextContextContextContextContextContextContextContextContextContext")
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .background(Color(.secondarySystemBackground))
            }
        }
        .padding()
        .animation(.spring())
        
    }
}

//struct Notice_Previews: PreviewProvider {
//    static var previews: some View {
//        Notice()
//    }
//}
