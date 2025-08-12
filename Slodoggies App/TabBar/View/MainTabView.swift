//
//  MainTabView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 15/07/25.
//

import SwiftUICore

struct MainTabView: View {
    @State private var selectedTab: CustomTab = .home
    @State var showWelcomPopUp: Bool = true
    @State var petInfoPopView: Bool = false
    @State var addYourInfoPopView: Bool = false
    @State var profileCreatedPopView: Bool = false
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
            //  Spacer()
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView()
                    case .discover:
                        Text("Discover View")
                    case .add:
                       // Text("Add Pet View")
                        CreatePostScreen()
                    case .services:
                        ServicesView()
                        //Text("Services View")
                    case .profile:
                        ProfileView()
                        //Text("Profile View")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                CustomTabBar(selectedTab: $selectedTab)
            }
            if showWelcomPopUp {
                WelcomePopUp() {
                    showWelcomPopUp = false
                    petInfoPopView = true
                }
            }
            if petInfoPopView{
                PetInfoPopupView(){
                    petInfoPopView = false
                    addYourInfoPopView = true
                }
            }
            if addYourInfoPopView{
                AddYourDetailPopUpView(){
                    addYourInfoPopView = false
                    profileCreatedPopView = true
                }
            }
            if profileCreatedPopView{
                ProfileCreatedPopUpView(){
                    profileCreatedPopView = false
                }
            }
        }
    }
}
