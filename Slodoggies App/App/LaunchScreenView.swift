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
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("logout"))) { _ in
               handelLogout()
            }
        }
    }
    func handelLogout(){
        UserDetail.shared.removeUserId()
        UserDetail.shared.removeTokenWith()
        UserDetail.shared.removeName()
        coordinator.logoutAndGoToOnboard()
    }
}

private extension LaunchScreenView {
    var launchImageView: some View {
        VStack {
            Image("Launch Image Logo")
              .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    func handleOnAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                UserDetail.shared.removeFistLogin()
                if UserDetail.shared.getTokenWith() != "" {
                    coordinator.push(.tabBar)
                }else{
                    coordinator.push(.onboarding)
                }
//                coordinator.push(.onboarding)
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
        case .loginView:
            LoginView()
                .navigationBarBackButtonHidden()
        case .verifyPhone(let userData,_):
            VerifyPhoneView(userDeatils: userData)
                .navigationBarBackButtonHidden()
        case .emailLogin:
            EmailLoginView()
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
        case .editPetProfileView(let petDetail):
            PetProfileView(pet: petDetail, isPresented: .constant(true))
                .navigationBarBackButtonHidden()
        case .editProfileView:
            EditProfileView()
                .navigationBarBackButtonHidden()
        case .myEvents:
            EventListView()
                .navigationBarBackButtonHidden()
        case .chatView:
            ChatView()
                .navigationBarBackButtonHidden()
        case .providerProfileView(let bID):
            ProviderProfileView(businessID: bID)
                .navigationBarBackButtonHidden()
        case .createPostEventView:
            CreatePostScreen()
                .navigationBarBackButtonHidden()
        case .notificationView:
            NotificationView()
                .navigationBarBackButtonHidden()
        case .chatListView:
            ChatListView()
                .navigationBarBackButtonHidden()
        case .createAccountView:
            CreateAccountView()
                .navigationBarBackButtonHidden()
        case .forgotPassword:
            ForgotPasswordView()
                .navigationBarBackButtonHidden()
        case .groupChatView:
            GroupChatView()
                .navigationBarBackButtonHidden()
        case .followersScreen(let Str,let initialTab):
            FollowersScreenView(Id: Str, initialTab: initialTab)
                .navigationBarBackButtonHidden()
        case.changePasswordView(let userData):
            ChangePasswordView(userDeatils: userData)
                .navigationBarBackButtonHidden()
        case .busiSubscriptionView:
            BusiSubscriptionView()
                .navigationBarBackButtonHidden()
        case .busiSettingsView:
            BusiSettingsView()
                .navigationBarBackButtonHidden()
        case .adsDashboardView:
            AdsDashboardView()
                .navigationBarBackButtonHidden()
//        case .addServiceView(let mode):
//            BusiAddServiceView(mode: mode)
        case let .addServiceView(mode, index):
            BusiAddServiceView(mode: mode, Index: index)
                .navigationBarBackButtonHidden()
        case .editBusinessView:
            EditBusinessView()
                .navigationBarBackButtonHidden()
        case .businessRegisteration:
            BusinessRegistrationView()
                .navigationBarBackButtonHidden()
        case .profileDetailsView(let str,let petName):
            ProfileDetailsView(userID: str,petName: petName)
                .navigationBarBackButtonHidden()
        case .accountPrivacyView:
            AccountPrivacyView()
                .navigationBarBackButtonHidden()
        case .savedPostsView(let id,let str):
            SavedPostsView(userID:id, comingFrom: str)
                .navigationBarBackButtonHidden()
        case .transactionView:
            TransactionView()
                .navigationBarBackButtonHidden()
        case .budgetView(let ads):
            BudgetView(adsDetail:ads)
                .navigationBarBackButtonHidden()
        case .adsPreviewView(let data):
            AdsPreviewView(adsDetail: data)
                .navigationBarBackButtonHidden()
        case .busiProfileView(let str, let id,let hideSponsoredButton):
            BusiProfileView(comesFrom:str,businessID: id, hideSponsoredButton: hideSponsoredButton)
                .navigationBarBackButtonHidden()
        case .newChatListView:
            NewChatListView()
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
