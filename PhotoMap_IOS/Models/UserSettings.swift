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
    
    static let shared: UserSettings = UserSettings()
    private init() {}
    
    func isValid() -> Bool {
        return self.userTocken != nil && self.userInfo != nil
    }
    
    func getAuthFromServer() -> Void {
        // 1. 카카오 세션이 유효한지 검사 후, 유효하면 tocken 참조
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
        
        // 2. 참조 된 카카오 tocken으로 Photomap server에 인증 시도
        let authUrl = NetworkURL.sharedInstance.getUrlString("/users")
        AnyRequest<UserInfo>{
            Url(authUrl)
            Method(.get)
            Header.Authorization(.bearer(self.userTocken!))
        }.onObject { usrInfo in
            DispatchQueue.main.async {
                self.userInfo = usrInfo
            }
        }
        .onError { error in
            if let stringError = String(data: error.error!, encoding: .utf8){
                print(stringError)
            }
        }
        .call()
    }
    
    func loginFromKakao() -> Void{
        guard let session = KOSession.shared() else {
            return
        }
        if session.isOpen() {
            session.close()
        }
        
        session.open(completionHandler: { (error) -> Void in
            if error != nil || !session.isOpen() {return}
            self.getAuthFromServer()
        })
    }
    func userLogout() -> Void {
        guard let session = KOSession.shared() else{
            return
        }
        session.logoutAndClose(completionHandler: { (success, error) in
            if success{
                print("Logout success!")
                DispatchQueue.main.async {
                    self.userInfo = nil
                    self.userTocken = nil
                }
            } else{
                print(error!.localizedDescription)
            }
        })
    }
    /// 회원 탈퇴
    func userWithdrawal() -> Void {
        let authUrl = NetworkURL.sharedInstance.getUrlString("/users")
        Request{
            Url(authUrl)
            Method(.delete)
            Header.Authorization(.bearer(self.userTocken!))
        }.onError { error in
            if let stringError = String(data: error.error!, encoding: .utf8){
                print(stringError)
            }
        }
        .onData{ data in
            self.userLogout()
            print("withdrawal success!")
        }
        .call()
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
