//
//  KoreaMap.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 1515/01/10.
//  Copyright © 1515 김근수. All rights reserved.
//

import SwiftUI
import URLImage
struct KoreaMap: View {
    @ObservedObject var mapStore = MapStore.shared
    @EnvironmentObject var userSettings: UserSettings
    @State var selected: Int? = 0
    @State var selectedLoc: String?
    @State var showActionSheet: Bool = false
    
    var body: some View {
        GeometryReader { gr in
            ZStack {
                Group {
                    BackImage(mapImage: "chungbuk", masterSize: CGSize(width: 140,height: 140))
                        .offset(x: 12.4, y: -57.3)
                    BackImage(mapImage: "chungnam", masterSize: CGSize(width: 135,height: 130))
                        .offset(x: -71, y: -46)
                    BackImage(mapImage: "gangwon", masterSize: CGSize(width: 215,height: 215))
                        .offset(x: 35, y: -158)
                    BackImage(mapImage: "gyeongbuk", masterSize: CGSize(width: 170,height: 180))
                        .offset(x: 73, y: -26)
                    BackImage(mapImage: "gyeonggi", masterSize: CGSize(width: 125,height: 150))
                        .offset(x: -50, y: -151)
                    BackImage(mapImage: "gyeongnam", masterSize: CGSize(width: 175,height: 130))
                        .offset(x: 59, y: 64)
                    BackImage(mapImage: "jeju", masterSize: CGSize(width: 150,height: 100))
                        .offset(x: -62, y: 215)
                    BackImage(mapImage: "jeonbuk", masterSize: CGSize(width: 145,height: 120))
                        .offset(x: -49, y: 32)
                    BackImage(mapImage: "jeonnam", masterSize: CGSize(width: 150,height: 135))
                        .offset(x: -62, y: 110)
                }
                
                Group{
                    NavigationLink(destination: FeedView(location: "충청북도", mapKey: "chungbuk"), tag: 1, selection: self.$selected) {
                        EmptyView()
                    }
                    NavigationLink(destination: FeedView(location: "충청남도", mapKey: "chungnam"), tag: 2, selection: self.$selected) {
                        EmptyView()
                    }
                    NavigationLink(destination: FeedView(location: "강원도", mapKey: "gangwon"), tag: 3, selection: self.$selected) {
                        EmptyView()
                    }
                    NavigationLink(destination: FeedView(location: "경상북도", mapKey: "gyeongbuk"), tag: 4, selection: self.$selected) {
                        EmptyView()
                    }
                    NavigationLink(destination: FeedView(location: "경기도", mapKey: "gyeonggi"), tag: 5, selection: self.$selected) {
                        EmptyView()
                    }
                    NavigationLink(destination: FeedView(location: "경상남도", mapKey: "gyeongnam"), tag: 6, selection: self.$selected) {
                        EmptyView()
                    }
                    NavigationLink(destination: FeedView(location: "제주도", mapKey: "jeju"), tag: 7, selection: self.$selected) {
                        EmptyView()
                    }
                    NavigationLink(destination: FeedView(location: "전라북도", mapKey: "jeonbuk"), tag: 8, selection: self.$selected) {
                        EmptyView()
                    }
                    NavigationLink(destination: FeedView(location: "전라남도", mapKey: "jeonnam"), tag: 9, selection: self.$selected) {
                        EmptyView()
                    }
                }
                Group{
                    NavigationLink(destination: SetRepresent(mapKey: self.$selectedLoc), tag: 10, selection: self.$selected) {
                        EmptyView()
                    }
                }
                TouchHandler(num: self.$selected, selectedLoc: self.$selectedLoc, showActionSheet: self.$showActionSheet, masterViewSize: gr.size)
                    .opacity(0.1)
            }
            .actionSheet(isPresented: self.$showActionSheet){
                ActionSheet(title: Text(""), message: Text(""), buttons: [
                    .default(Text("대표사진 설정"), action: {
                        self.selected = 10
                    }),
                    .default(Text("대표사진 지우기"), action: {
                        self.mapStore.deleteRepresentImage(cityKey: self.selectedLoc!, userTocken: self.userSettings.userTocken!)
                    }),
                    .destructive(Text("취소"))
                ])
            }
        }
    }
}

/// View for Background Map Image
/// Masked or UnMasked
struct BackImage: View {
    @ObservedObject var mapStore = MapStore.shared
    @State var mapImage: String
    var masterSize: CGSize
    
    var body: some View {
        Group{
            if mapStore.mapData.represents?.getStr(location: mapImage) == nil{
                Image(mapImage)
                    .scaledToFit()
            }else{
                ZStack{
                    URLImage(URL(string: (mapStore.mapData.represents?.getStr(location: mapImage))!)!, placeholder: {_ in EmptyView()}){ proxy in
                        proxy.image
                            .resizable()
                            .frame(width: self.masterSize.width, height: self.masterSize.height)
                            .scaledToFit()
                            .mask(Image(self.mapImage)
                                .resizable()
                                .frame(width: self.masterSize.width, height: self.masterSize.height)
                                .scaledToFit())
                    }
                    .animation(.default)
                    .shadow(color: .gray, radius: 2)
                    
                    Image(self.mapImage + "White")
                        .resizable()
                        .frame(width: self.masterSize.width, height: self.masterSize.height)
                        .scaledToFit()
                }
            }
        }
    }
}

@objc class ClosureSleeve: NSObject {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    func addLongPressAction(_ closuer: @escaping ()->()) {
        let sleeve = ClosureSleeve(closuer)
        let getureReg = UILongPressGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        addGestureRecognizer(getureReg)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIButton {
    func getColorFromPoint(point: CGPoint) -> UIColor {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        var pixelData:[UInt8] = [0, 0, 0, 0]
        
        let context = CGContext.init(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: UInt32(bitmapInfo.rawValue))
        context!.translateBy(x: -point.x, y: -point.y)
        
        self.layer.render(in: context!)
        
        let red: CGFloat = CGFloat(pixelData[0])/CGFloat(255.0)
        let green: CGFloat = CGFloat(pixelData[1])/CGFloat(255.0)
        let blue: CGFloat = CGFloat(pixelData[2])/CGFloat(255.0)
        let alpha: CGFloat = CGFloat(pixelData[3])/CGFloat(255.0)
        
        let color: UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if(!self.bounds.contains(point)){
            return nil
        }
        else{
            let color: UIColor = self.getColorFromPoint(point: point)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            if (alpha<=0.0) {
                return nil
            }
            return self
        }
    }
}

struct TouchHandler: UIViewRepresentable {
    @Binding var num: Int?
    @Binding var selectedLoc: String?
    @Binding var showActionSheet: Bool
    var masterViewSize: CGSize
    struct Elements {
        let name: String
        let navigationTag: Int
        let position: CGPoint
    }
    
    func makeUIView(context: UIViewRepresentableContext<TouchHandler>) -> UIView {
        let masterView = UIView(frame: CGRect(origin: .zero, size: masterViewSize))
        let elements: [Elements] = [
            Elements(name: "chungbuk", navigationTag: 1, position: CGPoint(x: 12.4,y: -57.3)),
            Elements(name: "chungnam", navigationTag: 2, position: CGPoint(x: -71, y: -46)),
            Elements(name: "gangwon", navigationTag: 3, position: CGPoint(x: 35, y: -158)),
            Elements(name: "gyeongbuk", navigationTag: 4, position: CGPoint(x: 73, y: -26)),
            Elements(name: "gyeonggi", navigationTag: 5, position: CGPoint(x: -50, y: -151)),
            Elements(name: "gyeongnam", navigationTag: 6, position: CGPoint(x: 59, y: 64)),
            Elements(name: "jeju", navigationTag: 7, position: CGPoint(x: -62, y: 215)),
            Elements(name: "jeonbuk", navigationTag: 8, position: CGPoint(x: -49, y: 32)),
            Elements(name: "jeonnam", navigationTag: 9, position: CGPoint(x: -62, y: 110))
        ]
        
        for ele in elements {
            let btn = UIButton()
            btn.addAction(for: .touchUpInside) {
                self.num = ele.navigationTag
            }
            btn.addLongPressAction {
                self.selectedLoc = ele.name
                self.showActionSheet = true
            }
            
            let img = UIImage(named: ele.name)
            btn.frame = CGRect(origin: .zero, size: img!.size)
            btn.setImage(img, for: .normal)
            let calcPos = CGPoint(x: masterView.center.x + ele.position.x, y: masterView.center.y + ele.position.y)
            btn.center = calcPos
            masterView.addSubview(btn)
        }
        return masterView
    }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<TouchHandler>) {
    }
}


struct KoreaMap_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            KoreaMap()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            
            KoreaMap()
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            
            KoreaMap()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
        }
    }
}
