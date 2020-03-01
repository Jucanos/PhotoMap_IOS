//
//  PageView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/29.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct PageView<Page: View>: View {
    @State var currentPage: Int = 0
    var viewControllers: [UIHostingController<Page>]
    
    init(_ views: [Page]) {
        self.viewControllers = views.map { UIHostingController(rootView: $0) }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PageViewController(controllers: viewControllers, currentPage: $currentPage)
            PageControl(numberOfPages: viewControllers.count, currentPage: $currentPage)
                .padding(.trailing)
        }
    }
}

//struct PageView_Previews: PreviewProvider {
//    static var previews: some View {
//        PageView()
//    }
//}
