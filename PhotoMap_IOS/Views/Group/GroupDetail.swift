//
//  GroupDetail.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/10.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import FirebaseDatabase
import URLImage

struct GroupDetail: View {
    
    var groupData: MapData?
    @State var ref = DatabaseReference()
    @State var refHandle = DatabaseHandle()
    @ObservedObject var mapStore = MapStore.shared
    @EnvironmentObject var userSettings: UserSettings
    @State private var menuOpen = false
    @State private var isButtonActivate = false
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    @State var isLoading = false
    @Binding var isSideMenuActive: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        var MapView = KoreaMap()
            .navigationBarItems(trailing:
                Button(action: {self.isSideMenuActive.toggle()}) {
                    Image(systemName: "line.horizontal.3")
                        .resizable()
                        .frame(width: 20, height: 20)
            })
            .navigationBarTitle("\((self.groupData?.name!)!)", displayMode: .inline)
            .scaleEffect(self.scale)
            .offset(x: self.currentPosition.width, y: self.currentPosition.height)
            .gesture(MagnificationGesture()
                .onChanged { val in
                    let minZoom: CGFloat = 0.5
                    let maxZoom: CGFloat = 2.0
                    let delta = val / self.lastScale
                    self.lastScale = val
                    let newScale = self.scale * delta
                    self.scale = max(min(newScale, maxZoom), minZoom)
            }
            .onEnded { _ in
                self.lastScale = 1.0
            })
            .simultaneousGesture(DragGesture()
                .onChanged { value in
                    self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
            }
            .onEnded { value in
                self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                self.newPosition = self.currentPosition
            })
        
        var mainButton: some View {
            ZStack{
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .background(Color(appColor))
                    .clipShape(Circle())
                    .rotationEffect(self.isButtonActivate ? Angle(degrees: 45.0) : Angle(degrees: 0.0))
                    .animation(.default)
            }
            .frame(width: 60, height: 60)
            .shadow(radius: 2)
        }
        
        var setRepMapButton: some View {
            Button(action: {
                self.isLoading = true
                self.userSettings.setRepresentMap(mid: self.mapStore.mapData.mid!){
                    UserGroupStore.shared.sortMaps()
                    self.isLoading = false
                    self.isButtonActivate.toggle()
                }
            }) {
                IconAndTextButton(imageName: "mappin.and.ellipse", buttonText: "대표지도 설정")
            }
        }
        
        var storeImageButton: some View {
            Button(action: {
                self.isLoading = true
                self.mapStore.getMapImage() { target in
                    print(target)
                    let tmpView = Image(uiImage: target).resizable().scaledToFit()
                    let img = tmpView.takeScreenshot(origin: .zero, size: UIScreen.main.bounds.size)
                    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                    self.isLoading = false
                    self.isButtonActivate.toggle()
                    }
            }) {
                IconAndTextButton(imageName: "photo", buttonText: "이미지로 저장하기")
            }
        }
        
        return LoadingView(isShowing: self.$isLoading){
            Group{
                if self.mapStore.mapData.mid != nil{
                    ZStack {
                        MapView
                        
                        ZStack {
                            Color(.black).opacity(self.isButtonActivate ? 0.7 : 0)
                            VStack {
                                Spacer().layoutPriority(10)
                                HStack {
                                    Spacer().layoutPriority(10)
                                    FloatingButton(mainButtonView: AnyView(mainButton), buttons: [AnyView(storeImageButton),AnyView(setRepMapButton)], isOpen: self.$isButtonActivate)
                                        .straight()
                                        .direction(.top)
                                        .alignment(.right)
                                        .spacing(10)
                                        .initialOpacity(0)
                                        .offset(y: -15)
                                        .padding()
                                }
                            }
                        }
                        .edgesIgnoringSafeArea(.bottom)
                        .onTapGesture {
                            self.isButtonActivate.toggle()
                        }
                    }
                }
                else{
                    EmptyView()
                }
            }
        }
        .onAppear(){
            self.isLoading = true
            self.ref = Database.database().reference(withPath: "dev/maps").child((self.groupData?.mid!)!)
            self.refHandle = self.ref.observe(DataEventType.value, with: { snapShot in
                print("at groupDetail callback")
                FireBaseBackMid.shared.syncUpdateNumber(mid: (self.groupData?.mid!)!, value: snapShot.value as! Int)
                self.mapStore.loadMapDetail(mid: (self.groupData?.mid!)!) {self.isLoading = false}
            })
        }
        .onDisappear(){
            self.ref.removeObserver(withHandle: self.refHandle)
        }
    }
}
