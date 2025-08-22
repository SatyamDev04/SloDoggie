//
//  Route.swift
//  AWPL
//
//  Created by YATIN  KALRA on 14/05/25.
//
import SwiftUI

enum Route: Hashable {
    case onboarding
    case joinAs
    case createAccountView
    case phoneNumberLogin
    case verifyPhone
    case forgotPassword
    case emailLogin
    case verifyEmail
    case notificationpermision
    case locationPermission
    case tabBar
    case settingView
    case savedView
    case aboutUs
    case privacyPolicy
    case termsAndCondition
    case faq
    case helpSupport
    case myEvents
    case chatView
    case groupChatView
    case EventParticipants
    case notificationView
    case addParticipants
    case editPetProfileView
    case editProfileView
    case providerProfileView
    case createPostEventView
    case chatListView
    case followersScreen(initialTab: FollowersViewModel.Tab)
    
  }

final class Coordinator: ObservableObject {
    
    @Published var path: [Route] = []
    @Published var selectedTab: Int = 0
       
       func switchTab(to index: Int) {
           selectedTab = index
       }
    
    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        self.path.removeLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
    func logoutAndGoToLogin() {
        path = [.phoneNumberLogin]
    }
//
//    func popToHome() {
//        path = [.tabBar]
//    }

}
