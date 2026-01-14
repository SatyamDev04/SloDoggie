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
    case loginView
    case verifyPhone(profileDetails,onPop: ((String) -> Void)? = nil)
    case forgotPassword
    case changePasswordView(profileDetails)
    case emailLogin
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
    case editPetProfileView(PetsDetailData)
    case editProfileView
    case providerProfileView(Int)
    case createPostEventView
    case chatListView
    case newChatListView
    case followersScreen(String,initialTab: FollowersViewModel.Tab)
    case busiSubscriptionView
    case busiSettingsView
    case adsDashboardView
    //case addServiceView(mode: BusiAddServiceView.Mode)
    case addServiceView(mode: BusiAddServiceView.Mode, index: Int?)
    case editBusinessView
    case businessRegisteration
    case profileDetailsView(String,String)
    case accountPrivacyView
    case savedPostsView(String,String)
    case transactionView
    case budgetView(adsDataModel)
    case adsPreviewView(adsDataModel)
    case busiProfileView(String,String,hideSponsoredButton: Bool = false)
    
    static func == (lhs: Route, rhs: Route) -> Bool { false }
    func hash(into hasher: inout Hasher) {}

  }


class UserData: ObservableObject {
    @Published var role: Role?
}

enum Role: String {
    case professional
    case owner
}

final class Coordinator: ObservableObject {
    @Published var isTabBarHidden: Bool = false
    @Published var path: [Route] = []
    @Published var selectedTab: Int = 0
    
    @Published var shouldRefreshServices = false
       
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
        path = [.loginView]
    }
    
    func logoutAndGoToOnboard() {
        path = [.joinAs]
    }
    
    
    func popToHome() {
        path = [.tabBar]
    }
    
    func pop(value: String? = nil) {
        if let last = path.last {
            switch last {
            case .verifyPhone(_, let callback):
                callback?(value ?? "")
//            case .editProfileView(let callback):
//                callback?(value ?? "")
            default:
                break
            }
        }
        path.removeLast()
    }

    
//
//    func popToHome() {
//        path = [.tabBar]
//    }

}
class verifiedData: ObservableObject {
    @Published var mobileVerified: Bool?
    @Published var emailVerified: Bool?
}
