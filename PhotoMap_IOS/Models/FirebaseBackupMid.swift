//
//  FirebaseBackupMid.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/02/18.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI
import FirebaseDatabase

class FireBaseBackMid: ObservableObject {
    @Published var mids: Dictionary<String, AnyObject> = [:]
    var ref = DatabaseReference()
    init() {}
    static let shared: FireBaseBackMid = FireBaseBackMid()
    
    func initObserve(uid: String) {
        ref = Database.database().reference(withPath: "users/" + uid)
        ref.observe(.value, with: { snapShot in
            print("Backup Changed!!")
            self.mids = snapShot.value as? [String : AnyObject] ?? [:]
        })
    }
    
    func getUpdateNumber(mid: String) -> Int{
        return mids[mid] as! Int
    }
    
    func syncUpdateNumber(mid: String, value: Int) {
        ref.child(mid).setValue(value)
    }
}
