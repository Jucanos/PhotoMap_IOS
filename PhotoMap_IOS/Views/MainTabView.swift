//
//  MainTabView.swift
//  PhotoMap_IOS
//
//  Created by 김근수 on 2020/01/09.
//  Copyright © 2020 김근수. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    
    @ObservedObject var groupData = UserGroupStore.shared
    @EnvironmentObject var userSettings: UserSettings
    @State private var selectedView = 0
    @State private var isSideMenuActive: Bool = false
    @State private var isAddGroupViewActive: Bool = false
    
    private let titles = ["그룹","메인지도","설정"]
    
    var body: some View {
        ZStack {
            NavigationView {
                TabView(selection: $selectedView) {
                    MainGroupView(isSideMenuActive: $isSideMenuActive)
                        .tabItem {
                            Image(systemName: "person.3")
                                .resizable()
                                .imageScale(.large)
                    }.tag(0)
                    
                    MainMapView()
                        .tabItem {
                            Image(systemName: "map")
                                .resizable()
                                .imageScale(.large)
                    }.tag(1)
                    
                    MainSettingView()
                        .tabItem {
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .imageScale(.large)
                    }.tag(2)
                }
                .accentColor(Color(appColor))
                .edgesIgnoringSafeArea(.top)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(leading:
                    HStack {
                        Text("\(self.titles[selectedView])")
                            .font(.system(size: 25, weight: .heavy))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(width: 100)
                    ,trailing: Button(action: {self.activeAddGroupView()}){
                        Image(systemName: "plus.bubble.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(5)
                    }.opacity(selectedView == 0 ? 1 : 0)
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            GroupSideMenu(width: UIScreen.main.bounds.width * 0.7, isOpen: self.isSideMenuActive, menuClose: self.activeSideMenu)
            
            AddGroup(isOpen: self.isAddGroupViewActive, menuClose: self.activeAddGroupView)
        }
        .onAppear(){
            self.groupData.loadMaps()
        }
    }
    
    func activeSideMenu() {
        self.isSideMenuActive.toggle()
    }
    
    func activeAddGroupView(){
        self.isAddGroupViewActive.toggle()
    }
    
    
}

extension UINavigationController {
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
        let backBtn = UIImage(systemName: "chevron.left")
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = appColor
        appearance.titleTextAttributes = [.foregroundColor : UIColor.white, .font: UIFont.systemFont(ofSize: 20)]
        appearance.setBackIndicatorImage(backBtn, transitionMaskImage: nil)
        
        navigationBar.tintColor = UIColor.white
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainTabView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            
            MainTabView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            
            MainTabView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
        }
    }
}

