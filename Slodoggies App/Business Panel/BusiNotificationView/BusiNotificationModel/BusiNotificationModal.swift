//
//  BusiNotificationModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 26/08/25.
//

import Foundation
import SwiftUI

// MARK: - Enum
enum BusiNotificationType {
    case like(imageURL: String)
    case follow
    case review(rating: Int, message: String)
}

// MARK: - Model
struct BusiNotificationModel: Identifiable {
    let id = UUID()
    let username: String
    let userImage: String
    let type: BusiNotificationType   // ✅ fixed type
    let timeAgo: String
}
