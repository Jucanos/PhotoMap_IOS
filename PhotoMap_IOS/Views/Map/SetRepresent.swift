//
//  SetRepresent.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/02/05.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct SetRepresent: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selectedBaseImage: UIImage? = nil
    @State var showImagePicker = true
    @Binding var mapKey: String?
    var body: some View {
        Group{
            if selectedBaseImage == nil {
                Text("")
                    .sheet(isPresented: $showImagePicker, onDismiss: {
                        if self.selectedBaseImage == nil{
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }, content: {
                        ImagePicker.shared.view
                    })
                    .onReceive(ImagePicker.shared.$image, perform: { img in
                        self.selectedBaseImage = img
                    })
            } else {
                AdjustImage(targetImage: self.$selectedBaseImage, location: mapKey!)
                
            }
        }
        .onDisappear(){
            ImagePicker.shared.image = nil
        }
    }
}

struct AdjustImage: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var mapStore: MapStore
    @EnvironmentObject var userSettings: UserSettings
    @State private var rotationState: Double = 0
    @State private var lastRotationState: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    @State var isLoading = false
    @Binding var targetImage: UIImage?
    var location: String
    
    var body: some View {
        let ratio = targetImage!.size.height / targetImage!.size.width
        let TargetView = Image(uiImage: targetImage!)
            .resizable()
            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * ratio)
            .rotationEffect(Angle(degrees: self.rotationState))
            .scaleEffect(scale)
            .offset(x: self.currentPosition.width, y: self.currentPosition.height)
            .gesture(MagnificationGesture()
                .onChanged { val in
                    let minZoom: CGFloat = 0.5
                    let maxZoom: CGFloat = 3.0
                    let delta = val / self.lastScale
                    self.lastScale = val
                    let newScale = self.scale * delta
                    self.scale = max(min(newScale, maxZoom), minZoom)
            }
            .onEnded { _ in
                self.lastScale = 1.0
            })
            .simultaneousGesture(RotationGesture()
                .onChanged{ value in
                    let diff = value.degrees - self.lastRotationState
                    self.lastRotationState = value.degrees
                    self.rotationState += diff
            }
            .onEnded{ _ in
                self.lastRotationState = .zero
            })
            .simultaneousGesture(DragGesture()
                .onChanged { value in
                    self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
            }
            .onEnded { value in
                self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                self.newPosition = self.currentPosition
            })
        
        return LoadingView(isShowing: self.$isLoading){
            GeometryReader{ gr in
                ZStack{
                    // 1. selected image to be modified
                    TargetView
                    // 2. Guideline layer
                    VStack(spacing: 0){
                        Color(.black)
                            .opacity(0.6)
                        Image(self.location+"Hole")
                            .resizable()
                            .scaledToFit()
                            .layoutPriority(10)
                        Color(.black)
                            .opacity(0.6)
                    }
                    .allowsHitTesting(false)
                }
                .edgesIgnoringSafeArea(.bottom)
                .navigationBarItems(trailing: Button(action: {
                    self.isLoading = true
                    let imgSize = UIImage(named: self.location)?.size
                    let ratio = imgSize!.height / imgSize!.width
                    
                    let newHeight = gr.size.width * ratio
                    let newOffset = (gr.frame(in: .global).size.height - newHeight) / 2
                    
                    let image = TargetView.takeScreenshot(origin: gr.frame(in: .global).origin , size: gr.size)
                    
                    let cgimg = image.cgImage!
                    let offset = newOffset * (CGFloat(cgimg.height) / gr.size.height)
                    let ssize = CGSize(width: CGFloat(cgimg.width), height: CGFloat(cgimg.width) * ratio)
                    
                    let rect = CGRect(origin: CGPoint(x: 0, y: offset), size: ssize)
                    let imageRef = image.cgImage!.cropping(to: rect)
                    
                    let newImage = UIImage(cgImage: imageRef!)
                    print(newImage)
                    
                    self.mapStore.setRepresentImage(cityKey: self.location, userTocken: self.userSettings.userTocken!, image: newImage){
                        self.isLoading = false
                        self.presentationMode.wrappedValue.dismiss()
                    }})
                {
                    Text("확인")
                })
            }
        }
    }
}

extension UIView {
    var renderedImage: UIImage {
        // rect of capure
        let rect = self.bounds
        // create the context of bitmap
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        // get a image from current context bitmap
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capturedImage
    }
}

extension View {
    func takeScreenshot(origin: CGPoint, size: CGSize) -> UIImage {
        let window = UIWindow(frame: CGRect(origin: origin, size: size))
        let hosting = UIHostingController(rootView: self)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.renderedImage
    }
}
