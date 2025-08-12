//
//  ChatListModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 11/08/25.
//

import Foundation

struct ChatModel: Identifiable {
    let id = UUID()
    let profileImageName: String
    let name: String
    let message: String
    let time: String
}
