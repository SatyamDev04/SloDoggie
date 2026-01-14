//
//  NewChatListModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 27/10/25.
//

import Foundation

struct NewChatListModel: Identifiable {
    let id: UUID = UUID()
    let name: String
    let isVerified: Bool
    let profileImage: String // URL or asset name
}
