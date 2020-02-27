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
    var group: MapData
    
    var body: some View {
            HStack{
                ZStack {
                    URLImage(URL(string: "https://s3.soybeans.tech/uploads/dev/\(self.group.mid!)/main.png")!, expireAfter: Date(timeIntervalSinceNow: 0.1)){ proxy in
                        proxy.image
                            .resizable()
                            .frame(width: 60, height: 60)
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
                    .offset(x: 20, y: -20)
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
            self.midRep = Database.database().reference(withPath: "maps").child(self.group.mid!)
            self.midRepHandle = self.midRep.observe(DataEventType.value, with: { snapShot in
                print("at groupRow callback")
                let remoteValue = snapShot.value as? Int ?? 0
                print(remoteValue)
                let backValue = self.fbBackMid.getUpdateNumber(mid: self.group.mid!)
                self.badgeCounter = remoteValue - backValue
            })
        }
        .onDisappear(){
            self.midRep.removeObserver(withHandle: self.midRepHandle)
        }
    }
}

//struct GroupRow_Previews: PreviewProvider {
//    static var tgroup = MapData(name: "Test", updatedAt: "2020.01.01")
//
//    static var previews: some View {
//        Group{
//            GroupRow(group: tgroup)
//        }
//        .previewLayout(.fixed(width: 300, height: 70))
//    }
//}
