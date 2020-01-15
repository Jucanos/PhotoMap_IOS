//
//  MainTabView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    
    @State var selectedView = 0
    @State var isNavigationBarHidden: Bool = true
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedView) {
                MainGroupView(isNavigationBarHidden: $isNavigationBarHidden)
                    .tabItem {
                        Image(systemName: "person.3.fill")
                            .resizable()
                            .imageScale(.large)
                }.tag(0)
                    .navigationBarTitle("")
                    .navigationBarHidden(self.isNavigationBarHidden)
                
                
                MainMapView()
                    .tabItem {
                        Image(systemName: "map.fill")
                            .resizable()
                            .imageScale(.large)
                }.tag(1)
                    .navigationBarTitle("")
                    .navigationBarHidden(self.isNavigationBarHidden)
                MainSettingView()
                    .tabItem {
                        Image(systemName: "line.horizontal.3")
                            .resizable()
                            .imageScale(.large)
                }.tag(2)
                    .navigationBarTitle("")
                    .navigationBarHidden(self.isNavigationBarHidden)
            }
            .accentColor(.black)
            .edgesIgnoringSafeArea(.top)
            .onAppear{
                self.isNavigationBarHidden = true
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}
extension UINavigationController {
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor : UIColor.white]
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}


//struct MainTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            MainTabView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
//                .previewDisplayName("iPhone SE")
//
//            MainTabView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
//                .previewDisplayName("iPhone 8")
//
//            MainTabView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
//                .previewDisplayName("iPhone 11 Pro")
//        }
//    }
//}

