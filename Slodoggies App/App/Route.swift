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
    case phoneNumberLogin
    case verifyPhone
    case emailLogin
    case verifyEmail
    case notificationpermision
    case locationPermission
    case tabBar
}

final class Coordinator: ObservableObject {
    
    @Published var path: [Route] = []
    
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
