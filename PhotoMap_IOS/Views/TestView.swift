//
//  TestView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/03/01.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        Image("dokdo").resizable().scaledToFit()
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
