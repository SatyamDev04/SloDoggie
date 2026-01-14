//
//  MainTabView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 15/07/25.
//

import SwiftUI

class TabRouter: ObservableObject {
    @Published var selectedTab: CustomTab = .home
    @Published var isTabBarHidden: Bool = false

}

struct MainTabView: View {
    @EnvironmentObject var tabRouter: TabRouter
    @State var showBusiWelcomPopUp: Bool = true
    @State var showWelcomPopUp: Bool = true
    @State var petInfoPopView: Bool = false
    @State var addYourInfoPopView: Bool = false
    @State var profileCreatedPopView: Bool = false
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject var userData: UserData
    @State private var addPetPopView: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Group {
                    switch tabRouter.selectedTab {   // Use tabRouter here
                    case .home:
                        HomeView()
                    case .discover:
                        DiscoverView()
                    case .add:
                        let userType = UserDefaults.standard.string(forKey: "userType")
                        if userType == "Professional" {
                            BusiCreatePostEventView()
                        }else{
                            CreatePostScreen()
                        }
                    case .services:
                        let userType = UserDefaults.standard.string(forKey: "userType")
                        if userType == "Professional" {
                            BusiServiceView()
                        }else{
                            ServicesView()
                        }
                    case .profile:
                        let userType = UserDefaults.standard.string(forKey: "userType")
                        if userType == "Professional" {
                            BusiProfileView(comesFrom: "Tab", businessID: UserDetail.shared.getUserId())
                        }else{
                            ProfileView(userID: UserDetail.shared.getUserId())
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if !tabRouter.isTabBarHidden {
                    CustomTabBar()
                        .environmentObject(tabRouter)
                }
            }
            
            // MARK: - Popups
            if UserDetail.shared.getFistLogin(){
                let userType = UserDefaults.standard.string(forKey: "userType")
                if userType == "Professional" {
                    if showBusiWelcomPopUp {
                        BusiWelcomePopUp {
                            showBusiWelcomPopUp = false
                            //petInfoPopView = true
                        }
                    }
                }else{
                    if showWelcomPopUp {
                        WelcomePopUp {
                            showWelcomPopUp = false
                            petInfoPopView = true
                        }
                    }
                    if petInfoPopView {
                        PetInfoPopupView(pets: []) {
                            petInfoPopView = false
                            addYourInfoPopView = true
                        }
                    }
                    if addPetPopView {
                        AddPetPopUPView(isVisible: $addPetPopView) {
                            // Ye closure directly state change karega
                            petInfoPopView = false
                            addPetPopView = false
                            addYourInfoPopView = true
                        }
                    }
                    
                    if addYourInfoPopView {
                        AddYourDetailPopUpView {
                            addYourInfoPopView = false
                            profileCreatedPopView = true
                        }
                    }
                    if profileCreatedPopView {
                        ProfileCreatedPopUpView {
                            profileCreatedPopView = false
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}



