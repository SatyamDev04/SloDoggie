//
//  NotiViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 28/07/25.
//

import Combine
import Foundation

class NotificationViewModel: ObservableObject {
    @Published var notificationsToday: [NotificationItem] = []
    
    init() {
        loadMockData()
    }
    
    private func loadMockData() {
        notificationsToday = [
            NotificationItem(username: "_username", profileImageURL: "profile1", time: "16 Min.", type: .followBackNeeded),
            NotificationItem(username: "_username", profileImageURL: "profile2", time: "16 Min.", type: .like(imageURL: "image")),
            NotificationItem(username: "_username", profileImageURL: "profile3", time: "16 Min.", type: .like(imageURL: "image")),
            NotificationItem(username: "_username", profileImageURL: "profile4", time: "16 Min.", type: .followBackNeeded),
            NotificationItem(username: "_username", profileImageURL: "profile5", time: "16 Min.", type: .follow),
            NotificationItem(username: "_username", profileImageURL: "profile6", time: "16 Min.", type: .followBackNeeded),
            NotificationItem(username: "_username", profileImageURL: "profile7", time: "16 Min.", type: .like(imageURL: "image")),
            NotificationItem(username: "_username", profileImageURL: "profile7", time: "16 Min.", type: .like(imageURL: "image"))
        ]
    }
}
