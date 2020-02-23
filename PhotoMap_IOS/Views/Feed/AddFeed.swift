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
    @ObservedObject var mapStore = MapStore.shared
    @EnvironmentObject var feedStore: FeedStore
    @State var title: String = ""
    @State var content: String = ""
    @State var selectedImage: [UIImage] = []
    @State var showImagePicker = true
    @State var isLoading = false
    var cityKey: String
    
    var body: some View {
        LoadingView(isShowing: self.$isLoading){
            GeometryReader { geo in
                VStack(alignment: .leading, spacing: 10) {
                    Text("제목을 정해주세요")
                        .font(.title)
                        .fontWeight(.bold)
                    TextField("스토리의 제목을 정해주세요", text: self.$title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("내용을 정해주세요")
                        .font(.title)
                        .fontWeight(.bold)
                    TextField("스토리의 내용을 정해주세요", text: self.$content)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .offset(y: geo.size.height * 0.2)
            }
            .padding()
            .opacity(self.selectedImage.isEmpty ? 0 : 1)
            .animation(.spring())
            .onReceive(MyImagePicker.shared.$images, perform: { images in
                self.selectedImage = images
            })
                .sheet(isPresented: self.$showImagePicker, onDismiss: {
                    if self.selectedImage.isEmpty {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }, content: {
                    MyImagePicker.shared.view
                })
                .navigationBarItems(leading: Button(action: {
                    self.showImagePicker = true
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    }, trailing:
                    Button(action: {
                        self.isLoading = true
                        self.feedStore.addFeed(mid: self.mapStore.mapData.mid!, cityKey: self.cityKey, title: self.title, context: self.content, images: self.selectedImage){
                            self.isLoading = false
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("업로드")
                            .foregroundColor(.white)
                    }
            )
        }
    }
}



struct AddFeed_Previews: PreviewProvider {
    static var previews: some View {
        AddFeed(cityKey: "")
    }
}

