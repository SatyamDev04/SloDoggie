//
//  BusiSettingViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 29/08/25.
//

import Foundation
import SwiftUI

final class BusiSettingViewModal: ObservableObject {
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
