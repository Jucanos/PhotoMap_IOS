//
//  SplashView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    @State var isAuth = false
    var body: some View {
        return Group {
            if isAuth{
                MainTabView()
            }
            else {
                LoginView(isAuth: $isAuth)
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
