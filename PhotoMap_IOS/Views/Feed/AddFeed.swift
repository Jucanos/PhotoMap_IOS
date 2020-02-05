//
//  AddFeed.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/24.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct AddFeed: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var mapStore: MapStore
    @EnvironmentObject var feedStore: FeedStore
    @State var title: String = ""
    @State var content: String = ""
    @State var selectedImage: [UIImage]?
    @State var showImagePicker = true
    @State var showTitleSetter = false
    @State var isCompleted = false
    @State var tag: Int? = nil
    var cityKey: String
    
    var body: some View {
        ZStack {
            SetTitleView
                .navigationBarTitle("피드 추가하기")
                .onAppear(){
                    if self.isCompleted{
                        self.presentationMode.wrappedValue.dismiss()
                    }
            }
        }
        .sheet(isPresented: $showImagePicker, onDismiss: {
            if self.selectedImage!.isEmpty {
                self.presentationMode.wrappedValue.dismiss()
            }
            self.showTitleSetter = true
            
        }, content: {
            MyImagePicker.shared.view
        })
            .onReceive(MyImagePicker.shared.$images, perform: { images in
                self.selectedImage = images
            })
    }
    
    var SetTitleView: some View {
        VStack(alignment: .leading) {
            Text("제목을 정해주세요")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
                .frame(height: 60)
            TextField("제목을 정해랏!", text: self.$title)
            Spacer()
                .navigationBarItems(leading: Button(action: {
                    self.showTitleSetter = false
                    self.showImagePicker = true
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    }, trailing:
                    Button(action: {self.tag = 1}) {
                        Text("다음")
                            .foregroundColor(.white)
                    }
            )
            NavigationLink(destination: SetContentView, tag: 1, selection: $tag) {
                EmptyView()
            }
        }
        .opacity(showTitleSetter ? 1 : 0)
        .animation(.spring())
        .padding()
    }
    
    var SetContentView: some View {
        VStack(alignment: .leading) {
            Text("내용을 적어주세요")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
                .frame(height: 60)
            TextField("내용을 정해랏!", text: self.$content)
            Spacer()
        }
        .padding()
        .navigationBarItems(leading: Button(action: {
            self.tag = nil
        }) {
            Image(systemName: "arrow.left")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
            }, trailing:
            Button(action: {
                // 완료 버튼
                self.feedStore.addFeed(userTocken: self.userSettings.userTocken!, mid: self.mapStore.mapData.mid!, cityKey: self.cityKey, title: self.title, context: self.content, images: self.selectedImage!)
                self.tag = nil
                self.isCompleted = true
            }) {
                    Text("완료")
                        .foregroundColor(.white)
            }
        )
    }
}



//struct AddFeed_Previews: PreviewProvider {
//    static var previews: some View {
//        AddFeed()
//    }
//}
//                    ZStack{
//                        MyImagePicker.shared.view
//                        .onReceive(MyImagePicker.shared.$images, perform: { images in
//                            print(images)
//                            print("received!!!\n")
//
//                        })
//                        Text("base")
//                    }
