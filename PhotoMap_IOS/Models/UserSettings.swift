//
//  UserSettings.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/16.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import KakaoOpenSDK
import Request

class UserSettings: ObservableObject {
    @Published var userTocken: String?
    @Published var userInfo: UserInfo?
    
    func isAuth() -> Bool {
        return self.userTocken != nil && self.userInfo != nil
    }
    
    func getAuthFromServer() -> Bool {
        print("inside get auth")
        var isValid: Bool = false
        
        guard let session = KOSession.shared() else {
            return false
        }
        
        if session.isOpen(){
            self.userTocken = session.token!.accessToken
        }
        
        if self.userTocken == nil{
            print("user tocken nil!!")
            return false
        }
        
        let authUrl = NetworkURL.sharedInstance.getUrlString("/users")
        AnyRequest<UserInfo>{
            Url(authUrl)
            Method(.get)
            Header.Authorization(.bearer(self.userTocken!))
        }.onObject { usrInfo in
            DispatchQueue.main.async {
                self.userInfo = usrInfo
                if self.userInfo != nil {
                    print("UserInfo init success!")
                    print(self.userInfo!)
                    isValid = true
                } else{
                    print("UserInfo init failed!")
                }
            }
        }
        .onError { error in
            print(error)
        }
        .call()
        return isValid
    }
    
    func getTockenFromKakao() -> Void{
        print("enter tockenFromKakao")
        
        guard let session = KOSession.shared() else {
            return
        }
        
        print("before checking session open")
        if session.isOpen() {
            session.close()
        }
        print("after checking session open")
        print("trying to open kakao session")
        
        session.open(completionHandler: { (error) -> Void in
            if error != nil || !session.isOpen() {return}
            print(session.token!.accessToken)
        })
    }
}
