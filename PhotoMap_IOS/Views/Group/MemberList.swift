//
//  MemberList.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/12.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct MemberList: View {
    @EnvironmentObject var mapStore: MapStore
    var body: some View {
        return Group{
            if mapStore.mapData.owners == nil {
                EmptyView()
            } else{
                VStack {
                    MenuTtileView()
                        .frame(height: CGFloat(50))
                    AddingMemberView()
                    List{
                        ForEach(mapStore.mapData.owners!, id: \.uid) { mb in
                            MemberRow(member: mb)                            
                        }
                    }
                    MenuOptionView()
                }
            }
        }
    }
}
struct MenuTtileView: View {
    var body: some View {
        ZStack{
            Color(.gray)
            HStack {
                Text("그룹멤버")
                    .foregroundColor(.white)
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
    @EnvironmentObject var userSettings: UserSettings
    var body: some View {
        HStack{
            Button(action: {
                
                KLKTalkLinkCenter.shared().sendDefault(with: self.template, success: { (warningMsg, argumentMsg) in
                    print("warnings!: ", String(describing: warningMsg))
                    print("argumentMsg!: ", String(describing: argumentMsg))
                }, failure: { error in
                    print(error)
                })
            }) {
                Image(systemName: "person.badge.plus.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
            }
            Text(verbatim: "그룹멤버 초대")
                .font(.headline)
                .foregroundColor(.blue)
            Spacer()
        }
        .padding()
        
    }
    
    let template = KMTFeedTemplate { feedTemplateBuilder in
        feedTemplateBuilder.content = KMTContentObject(builderBlock: { contentBuilder in
            contentBuilder.title = "포토맵"
            contentBuilder.imageURL = URL(string: "https://ifh.cc/g/ODD7n.png")!
            contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                linkBuilder.iosExecutionParams = "test"
            })
        })
        feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { buttonBuilder in
            buttonBuilder.title = "초대받기"
            buttonBuilder.link = KMTLinkObject(builderBlock: { linkBuilder in
                linkBuilder.iosExecutionParams = "test"
            })
        }))
    }
    
    
}

struct MemberList_Previews: PreviewProvider {
    static var previews: some View {
        AddingMemberView()
    }
}
