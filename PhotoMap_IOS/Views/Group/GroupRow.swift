//
//  GroupRow.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import URLImage
import FirebaseDatabase

struct GroupRow: View {
    @State var badgeCounter: Int = 0
    @State var midRep = DatabaseReference()
    @State var midRepHandle = DatabaseHandle()
    @ObservedObject var fbBackMid = FireBaseBackMid.shared
    @State var ThumbnailImage: Image?
    var group: MapData
    
    var body: some View {
         HStack{
                ZStack {
                    Group{
                        if ThumbnailImage != nil {
                            ThumbnailImage!.resizable().frame(width: 60, height: 60)
                        } else {
                            Image(systemName: "photo").resizable().scaledToFit().frame(width: 30, height: 30)
                            .onAppear(){
                                UserGroupStore.shared.getMapThumbnail(mid: self.group.mid!) { img in
                                    self.ThumbnailImage = Image(uiImage: img)
                                }
                            }
                        }
                    }
                    
                    ZStack {
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                        Text(String(self.badgeCounter))
                            .foregroundColor(.white)
                    }
                    .opacity(self.badgeCounter != 0 ? 1 : 0)
                    .frame(width: 15, height: 15)
                    .foregroundColor(.red)
                    .offset(x: 25, y: -25)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(verbatim: "\(self.group.name!)")
                        .font(.custom("NanumSquareRoundB", size: 25))
                    Text(self.group.getProperUpdateAt())
                        .font(.custom("NanumSquareRoundL", size: 12))
                        .foregroundColor(.gray)
                }
                .padding(5)
                Spacer()
                
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.yellow)
                    .opacity(UserSettings.shared.userInfo?.data?.primary == self.group.mid ? 1 : 0)
            }
        .onAppear(){
            self.midRep = Database.database().reference(withPath: "dev/maps").child(self.group.mid!)
            self.midRepHandle = self.midRep.observe(DataEventType.value, with: { snapShot in
                let remoteValue = snapShot.value as? [String: Int]
                let backValue = self.fbBackMid.getUpdateNumber(mid: self.group.mid!)
                if remoteValue != nil {
                    self.badgeCounter = remoteValue!["logNumber"]! - backValue
                    if remoteValue!["userNumber"]! <= 4 {
                        UserGroupStore.shared.getMapThumbnail(mid: self.group.mid!) { img in
                            self.ThumbnailImage = Image(uiImage: img)
                        }
                    }
                    UserGroupStore.shared.loadMaps()
                }
            })
        }
        .onDisappear(){
            self.midRep.removeObserver(withHandle: self.midRepHandle)
        }
    }
}
