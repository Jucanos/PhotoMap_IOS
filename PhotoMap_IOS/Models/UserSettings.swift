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
import Firebase
import FirebaseMessaging

class UserSettings: ObservableObject {
    @Published var userTocken: String?
    @Published var userInfo: UserInfo?
    
    static let shared: UserSettings = UserSettings()
    private init() {}
    
    func isValid() -> Bool {
        return self.userTocken != nil && self.userInfo != nil
    }
    
    func getAuthFromServer(onEndHandler: @escaping () -> Void) -> Void {
        // 1. 카카오 세션이 유효한지 검사 후, 유효하면 tocken 참조
        guard let session = KOSession.shared() else {
            return
        }
        KOSessionTask.accessTokenInfoTask() { (accessTockenInfo, error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                print(accessTockenInfo?.expiresInMillis ?? 0)
            }
        }
        if session.isOpen(){
            self.userTocken = session.token!.accessToken
            print("kakao tocken: ", self.userTocken!)
        }
        if self.userTocken == nil{
            print("kakao tocken nil!!")
            return
        }
        
        // 2. 참조 된 카카오 tocken으로 Photomap server에 인증 시도
        let authUrl = NetworkURL.sharedInstance.getUrlString("/users")
        AnyRequest<UserInfo>{
            Url(authUrl)
            Method(.get)
            Header.Authorization(.bearer(self.userTocken!))
        }.onObject { usrInfo in
            print(usrInfo)
            DispatchQueue.main.async {
                self.userInfo = usrInfo
                FireBaseBackMid.shared.initObserve(uid: (usrInfo.data?.uid!)!)
                Messaging.messaging().subscribe(toTopic: (usrInfo.data?.uid!)!)
                onEndHandler()
            }
        }
        .onError { error in
            if let stringError = String(data: error.error!, encoding: .utf8){
                print(stringError)
            }
            onEndHandler()
        }
        .call()
    }
    
    func loginFromKakao(handler: @escaping ()->Void) -> Void{
        guard let session = KOSession.shared() else {
            return
        }
        if session.isOpen() {
            session.close()
        }
        
        session.open(completionHandler: { (error) -> Void in
            if error != nil || !session.isOpen() {return}
            self.getAuthFromServer(){
                handler()
            }
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
        let url = NetworkURL.sharedInstance.getUrlString("/users/\(mid)")
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
    
    func deleteRepresentMap(mid: String, completionHandler: @escaping ()->()) {
        let url = NetworkURL.sharedInstance.getUrlString("/users/\(mid)")
        Request{
            Url(url)
            Method(.patch)
            Header.Authorization(.bearer(self.userTocken!))
            Header.ContentType(.json)
            Body(["remove": "true"])
        }.onError { error in
            print("error occuered!", error)
            if let stringData = String(data: error.error!, encoding: .utf8){
                print(stringData)
            }
        }.onData{data in
            print("deleting REPMAP success!")
            DispatchQueue.main.async {
                self.userInfo?.data?.primary = nil
                completionHandler()
            }
        }.call()
    }
    
    // MARK: -Firebase with UserDefault functions
    
//    func getFirebaseBackup(uid: String, handler: @escaping () -> ()) {
//        let ref = Database.database().reference()
//        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { snapShot in
//            let mapDic = snapShot.value as? Dictionary<String, AnyObject>
//            if mapDic == nil {
//                handler()
//            }else{
//                if self.saveDictionary(dict: mapDic!, key: "midList") {
//                    handler()
//                } else{
//                    print("save mid list failed!")
//                }
//            }
//        })
//    }
//
//    func saveDictionary(dict: Dictionary<String, AnyObject>, key: String) -> Bool{
//        let preferences = UserDefaults.standard
//        if let encodedData: Data = try? NSKeyedArchiver.archivedData(withRootObject: dict, requiringSecureCoding: false){
//            print(encodedData)
//            preferences.set(encodedData, forKey: key)
//        } else {
//            print("data archiving failed!")
//            return false
//        }
//
//        // Checking the preference is saved or not
//        return preferences.synchronize()
//    }
//
//    func getDictionary(key: String) -> Dictionary<String, AnyObject> {
//        let preferences = UserDefaults.standard
//        if preferences.object(forKey: key) != nil{
//            let decoded = preferences.object(forKey: key)  as! Data
//            guard let decodedDict = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSDictionary.self, from: decoded) else{
//                print("object couldn't unarchived!")
//                return Dictionary<String, AnyObject>()
//            }
//            return decodedDict as! Dictionary<String, AnyObject>
//        } else {
//            let emptyDict = Dictionary<String, AnyObject>()
//            return emptyDict
//        }
//    }
}
