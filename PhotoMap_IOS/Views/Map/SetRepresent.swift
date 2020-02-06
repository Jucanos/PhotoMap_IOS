//
//  SetRepresent.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/02/05.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

extension UIView {
  var renderedImage: UIImage {
    let image = UIGraphicsImageRenderer(size: self.bounds.size).image { context in
      UIColor.lightGray.set(); UIRectFill(bounds)
      context.cgContext.setAlpha(0.75)
      self.layer.render(in: context.cgContext)
    }
    return image
  }
}
extension View {
  var renderedImage: UIImage {
    let window = UIWindow(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 160)))
    let hosting = UIHostingController(rootView: self)
    hosting.view.frame = window.frame
    window.rootViewController = hosting
    window.makeKey()
    return hosting.view.renderedImage
  }
}

struct SetRepresent: View {
    var mid: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selectedBaseImage: UIImage? = nil
    @State var showImagePicker = true
    @Binding var mapKey: String?
    var body: some View {
        Group{
            if selectedBaseImage == nil {
                Text("base")
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
    @Binding var targetImage: UIImage?
    @State var rotationState: Double = 0
    @State var scale: CGFloat = 1.0
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    var location: String
    
    var body: some View {
        ZStack{
            // 1. selected image to be modified
            Image(uiImage: targetImage!)
                .resizable()
                .scaledToFit()
                .rotationEffect(Angle(degrees: self.rotationState))
                .scaleEffect(scale)
                .offset(x: self.currentPosition.width, y: self.currentPosition.height)
                .gesture(MagnificationGesture()
                    .onChanged{ value in
                        self.scale = value.magnitude
                })
                .simultaneousGesture(RotationGesture()
                    .onChanged{ value in
                        self.rotationState = value.degrees
                })
                .simultaneousGesture(DragGesture()
                    .onChanged { value in
                        self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                }
                .onEnded { value in
                    self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                    print(self.newPosition.width)
                    self.newPosition = self.currentPosition
                })
            
            // 2. Guideline layer
            VStack(spacing: 0){
                Color(.black)
                    .opacity(0.7)
                Image(location+"Hole")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.black)
                    .opacity(0.7)
                Color(.black)
                    .opacity(0.7)
            }
            .allowsHitTesting(false)
        }
    }
}



struct SetRepresent_Previews: PreviewProvider {
    static var previews: some View {
//        Image(uiImage: AdjustImage( targetImage: .constant(UIImage(named: "test")), location: "gangwon").renderedImage)
        Image(uiImage: Text("good").renderedImage)
        .resizable()
        .scaledToFit()
    }
}
