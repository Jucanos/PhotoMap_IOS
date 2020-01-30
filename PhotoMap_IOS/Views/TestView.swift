//
//  TestView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/14.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import Request

struct View1: View {
    var body: some View {
        //        NavigationView {
        //            NavigationLink(destination: View2()) {
        //                Image("gangwon")
        //                    .border(Color.black)
        //
        //            }
        //        }
        
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
            Image("gangwon")
                .renderingMode(.original)
        }
        
    }
}

struct View2: View {
    var body: some View {
        Text("View2")
    }
}
extension UIButton{
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



struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        View1()
    }
}
