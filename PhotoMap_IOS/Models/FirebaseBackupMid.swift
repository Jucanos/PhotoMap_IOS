//
//  FirebaseBackupMid.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/02/18.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import FirebaseDatabase
import Combine
class FireBaseBackMid: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    @Published var mids: Dictionary<String, AnyObject>? {
        willSet {
            print("will reload View at FirebaseBackMid!!!")
            objectWillChange.send()
        }
    }
    var ref = DatabaseReference()
    init() {}
    static let shared: FireBaseBackMid = FireBaseBackMid()
    
    func isValid() -> Bool {
        return self.mids != nil ? true : false
    }
    
    func initObserve(uid: String) {
        ref = Database.database().reference(withPath: "dev/users/" + uid)
        ref.observe(.value, with: { snapShot in
            print("Backup Changed!!")
            self.mids = snapShot.value as? [String : AnyObject] ?? [:]
        })
    }
    
    func getUpdateNumber(mid: String) -> Int{
        return mids![mid] != nil ? mids![mid] as! Int : 0
    }
    
    func syncUpdateNumber(mid: String, value: Int) {
        ref.child(mid).setValue(value)
    }
}
