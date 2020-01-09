//
//  LoginWithKakao.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/05.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import UIKit

final class KakaoLoginButton: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<KakaoLoginButton>) -> UIButton {
        let loginButton = KOLoginButton()
        //        loginButton.addTarget(self, action: #selector(touchUpLoginButton(_:)), for: .touchUpInside)
        return loginButton
    }
    
    func updateUIView(_ uiView: UIButton, context: UIViewRepresentableContext<KakaoLoginButton>) {}
}
