//
//  ContentView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/05.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import KakaoOpenSDK
import Request


let appColor = Color(red: 0.976, green: 0.875, blue: 0.196)

struct LoginView: View {
    //    @Binding var isAuth: Bool
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        VStack(alignment: .center) {
            Image("mainlogo")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .scaledToFit()
                .padding(.top, 80)
            
            Spacer()
            
            Text("포토맵에 오신것을 환영합니다!")
                .font(.body)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Button(action: {
                self.attemptLogin()
            }){
                KakaoLoginButton()
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 10)
            }
            Spacer()
        }
        .padding()
        .background(appColor)
        .edgesIgnoringSafeArea(.all)
        .onAppear(){
            self.userSettings.getAuthFromServer()
        }
    }
    
    func attemptLogin(){
        guard let session = KOSession.shared() else {
            return
        }
        if session.isOpen() {
            session.close()
        }
        print("trying to open kakao session")
        session.open(completionHandler: { (error) -> Void in
            if error != nil || !session.isOpen() {return}
            print(session.token!.accessToken)
            self.userSettings.userTocken = session.token!.accessToken
            let authUrl = NetworkURL.sharedInstance.getUrlString("/users")
            AnyRequest<UserInfo>{
                Url(authUrl)
                Method(.get)
                Header.Authorization(.bearer(self.userSettings.userTocken!))
            }.onObject { usrInfo in
                DispatchQueue.main.async {
                    self.userSettings.userInfo = usrInfo
                    if self.userSettings.userInfo != nil {
                        print("UserInfo init success!")
                        print(self.userSettings.userInfo!)
                    } else{
                        print("UserInfo init failed!")
                    }
                }
            }
            .onError { error in
                print(error)
            }
            .call()
        })
        
    }
}




#if DEBUG
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            LoginView(isAuth: .constant(false))
//                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
//                .previewDisplayName("iPhone SE")
//
//            LoginView(isAuth: .constant(false))
//                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
//                .previewDisplayName("iPhone 8")
//
//            LoginView(isAuth: .constant(false))
//                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
//                .previewDisplayName("iPhone 11 Pro")
//        }
//    }
//}
#endif
