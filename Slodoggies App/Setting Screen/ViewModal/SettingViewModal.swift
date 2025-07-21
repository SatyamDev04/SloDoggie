
//
//  SettingsViewModel.swift
//  AWPL
//
//  Created by YATIN KALRA on 16/07/25.
//

import Foundation
import SwiftUI

final class SettingsViewModel: ObservableObject {
    @Published var showDeletePopup = false
    @Published var deletePopupType: String = ""
    @Published var isNotificationEnabled = false

    func handleDeleteAccount() {
        deletePopupType = "delete"
        showDeletePopup = true
    }

    func handleLogout() {
        deletePopupType = "logout"
        showDeletePopup = true
    }

    func openNotificationSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsURL)
        else { return }

        UIApplication.shared.open(settingsURL)
    }

    func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isNotificationEnabled = settings.authorizationStatus == .authorized
            }
        }
    }
}
