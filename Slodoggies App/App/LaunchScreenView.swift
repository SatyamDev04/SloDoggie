//
//  LaunchScreenView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 11/07/25.
//


import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject private var coordinator: Coordinator
//    @StateObject private var viewModel: LaunchScreenVM = LaunchScreenVM()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            launchImageView
                .onAppear(perform: handleOnAppear)
                .navigationDestination(for: Route.self, destination: buildDestination(for:))
        }
    }
}

private extension LaunchScreenView {
    
    var launchImageView: some View {
        VStack {
            Image("Launch Image Logo")
//                .resizable()
                  .scaledToFit()
                  .edgesIgnoringSafeArea(.all)
                
        }
    }
    
    func handleOnAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                coordinator.push(.tabBar)
//                if viewModel.isUserLoggedIn {
//                    coordinator.push(.tabBar)
//                }else{
//                    coordinator.push(.chooselanguage)
//                }
                
            }
        }
//        NotificationCenter.default.addObserver(forName: Notification.Name("logout"), object: nil, queue: .main) { _ in
//            coordinator.logoutAndGoToLogin()
//            print("User logged out")
//        }
           
    }
    
    @ViewBuilder
    func buildDestination(for route: Route) -> some View {
        switch route {
        case .onboarding:
            OnboardingView()
                .navigationBarBackButtonHidden()
        case .joinAs:
            JoinAsView()
                .navigationBarBackButtonHidden()
        case .phoneNumberLogin:
            PhoneNumberLoginView()
                .navigationBarBackButtonHidden()
        case .verifyPhone:
            VerifyPhoneView()
                .navigationBarBackButtonHidden()
        case .emailLogin:
            EmailLoginView()
                .navigationBarBackButtonHidden()
        case .verifyEmail:
            VerifyEmailView()
                .navigationBarBackButtonHidden()
        case .notificationpermision:
            NotificationPermissionView()
                .navigationBarBackButtonHidden()
        case .locationPermission:
            LocationPermissionView()
                .navigationBarBackButtonHidden()
        case .tabBar:
            MainTabView()
                .navigationBarBackButtonHidden()
        case .settingView:
            SettingView()
                .navigationBarBackButtonHidden()
        case .savedView:
            SavedView()
                .navigationBarBackButtonHidden()
        case .aboutUs:
            AboutUSView()
                .navigationBarBackButtonHidden()
        case .privacyPolicy:
            PrivacyPolicyView()
                .navigationBarBackButtonHidden()
        case .termsAndCondition:
            TermConditionView()
                .navigationBarBackButtonHidden()
        case .faq:
            FAQsView()
                .navigationBarBackButtonHidden()
        case .helpSupport:
            HelpSupportView()
                .navigationBarBackButtonHidden()
        case .EventParticipants:
            EventParticipantsView()
                .navigationBarBackButtonHidden()
        case .addParticipants:
            AddParticipantsView()
                .navigationBarBackButtonHidden()
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .environmentObject(Coordinator())
    }
}
