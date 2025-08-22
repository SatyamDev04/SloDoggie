//
//  GroupChatModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 19/08/25.
//

import Foundation

struct GroupChatMessage: Identifiable {
    let id = UUID()
    let senderName: String
    let message: String
    let isCurrentUser: Bool
    let timestamp: Date
    let profileImage: String // image name or URL
}
