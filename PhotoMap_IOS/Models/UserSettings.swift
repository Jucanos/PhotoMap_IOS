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
    
    func getAuthFromServer() -> Void {
        print("trying to get auth from Photomap server")
        guard let session = KOSession.shared() else {
            return
        }
        
        if session.isOpen(){
            self.userTocken = session.token!.accessToken
            print("getting tocken success: ", self.userTocken!)
        }
        
        if self.userTocken == nil{
            print("user tocken nil!!")
            return
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
                    print("UserInfo init success: ", self.userInfo!)
                } else{
                    print("UserInfo init failed!")
                }
            }
        }
        .onError { error in
            print("Error at getAuthFromServer", error)
        }
        .call()
    }
    
    func getTockenFromKakao() -> Void{
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
        })
    }
    
    func userLogout() -> Void {
        let authUrl = NetworkURL.sharedInstance.getUrlString("/users")
        Request{
            Url(authUrl)
            Method(.delete)
            Header.Authorization(.bearer(self.userTocken!))
        }.onError { error in
            print("logout failed: ", error)
        }
        .onData{ data in
            print("\nlogout success from Photomap server!")
            DispatchQueue.main.async {
                self.userInfo = nil
                print("\nuserInfo deleted!")
            }
        }
        .call()
        
        guard let session = KOSession.shared() else{
            return
        }
        session.logoutAndClose(completionHandler: { (success, error) in
            if success{
                print("\nlogout success from kakao session")
                self.userTocken = nil
                print("\nuserTocken deleted!")
            } else{
                print(error!.localizedDescription)
            }
        })
    }
    
    func setRepresentMap(mid: String, _ handler: @escaping ()->()) {
        print("try to set REPMAP at NETWORK")
        let url = NetworkURL.sharedInstance.getUrlString("/users/\(mid)")
        print(url)
        Request{
            Url(url)
            Method(.patch)
            Header.Authorization(.bearer(self.userTocken!))
            Header.ContentType(.json)
            Body(["remove": "false"])
        }.onError { error in
            print("error occuered!", error)
            if let stringData = String(data: error.error!, encoding: .utf8){
                print(stringData)
            }
        }.onData{data in
            print("setting REPMAP success!")
            DispatchQueue.main.async {
                self.userInfo?.data?.primary = mid
                handler()
            }
        }.call()
        
    }
}
