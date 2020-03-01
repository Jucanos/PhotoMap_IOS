//
//  HostingController.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/15.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

final class HostingController<T: View>: UIHostingController<T> {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
