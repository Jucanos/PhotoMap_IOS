//
//  ActivityIndicator.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/02/19.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

//struct ActivityIndicator: UIViewRepresentable {
//
//    @Binding var isAnimating: Bool
//    let style: UIActivityIndicatorView.Style
//
//    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
//        return UIActivityIndicatorView(style: style)
//    }
//
//    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
//        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
//    }
//}
struct ActivityIndicator: UIViewRepresentable {

    typealias UIView = UIActivityIndicatorView
    @Binding var isAnimating: Bool
    var configuration = { (indicator: UIView) in }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView { UIView() }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        configuration(uiView)
    }
}

extension View where Self == ActivityIndicator {
    func configure(_ configuration: @escaping (Self.UIView)->Void) -> Self {
        Self.init(isAnimating: self.$isAnimating, configuration: configuration)
    }
}
