//
//  NotiModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 28/07/25.
//

import SwiftUI

enum NotificationType {
    case like(imageURL: String)
    case followBackNeeded
    case follow
}

struct NotificationItem: Identifiable {
    let id = UUID()
    let username: String
    let profileImageURL: String
    let time: String
    let type: NotificationType
}
