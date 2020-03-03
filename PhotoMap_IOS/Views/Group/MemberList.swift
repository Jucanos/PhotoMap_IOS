//
//  MemberList.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/12.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct MemberList: View {
    @ObservedObject var mapStore = MapStore.shared
    var body: some View {
        Group{
            if mapStore.mapData.owners == nil {
                EmptyView()
            } else{
                VStack {
                    MenuTtileView()
                        .frame(height: CGFloat(50))
                    AddingMemberView()
                    List{
                        ForEach(mapStore.mapData.getSortedOwners(), id: \.uid) { mb in
                            MemberRow(member: mb)                            
                        }
                    }
                }
            }
        }
    }
}

struct MenuTtileView: View {
    var body: some View {
        ZStack{
            Color(.white)
            HStack {
                Text("그룹멤버")
                    .font(.custom("NanumSquareRoundB", size: 17))
                    .foregroundColor(.black)
                    .padding()
                Spacer()
            }
        }
    }
}

struct MenuOptionView: View {
    var body: some View {
        HStack {
            Image(systemName: "arrowshape.turn.up.right")
            Spacer()
            Image(systemName: "star")
        }
        .padding()
    }
}

struct AddingMemberView: View {
    @ObservedObject var mapStore = MapStore.shared
    var body: some View {
        HStack{
            Button(action: {
                let name = UserSettings.shared.userInfo!.data!.nickname!
                let template = KMTFeedTemplate { feedTemplateBuilder in
                    feedTemplateBuilder.content = KMTContentObject(builderBlock: { contentBuilder in
                        contentBuilder.title = "\(name)님이 photoMap에 초대했습니다."
                        contentBuilder.imageURL = URL(string: "https://s3.soybeans.tech/logo.png")!
                        contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                            linkBuilder.iosExecutionParams = "mid=\(self.mapStore.mapData.mid!)"
                            linkBuilder.androidExecutionParams = "mid=\(self.mapStore.mapData.mid!)"
                        })
                    })
                    feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { buttonBuilder in
                        buttonBuilder.title = "초대 받기"
                        buttonBuilder.link = KMTLinkObject(builderBlock: { linkBuilder in
                            linkBuilder.iosExecutionParams = "mid=\(self.mapStore.mapData.mid!)"
                            linkBuilder.androidExecutionParams = "mid=\(self.mapStore.mapData.mid!)"
                        })
                    }))
                }
                
                KLKTalkLinkCenter.shared().sendDefault(with: template, success: { (warningMsg, argumentMsg) in
                    print("warnings!: ", String(describing: warningMsg))
                    print("argumentMsg!: ", String(describing: argumentMsg))
                }, failure: { error in
                    print(error)
                })
            }) {
                HStack{
                    Image(systemName: "person.badge.plus.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                    
                    Text("그룹멤버 초대")
                        .font(.custom("NanumSquareRoundB", size: 17))
                        .foregroundColor(.black)
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct MemberList_Previews: PreviewProvider {
    static var previews: some View {
        AddingMemberView()
    }
}
