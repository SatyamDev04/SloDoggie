//
//  ChatViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/07/25.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var newMessage = ""

    let currentUserId = "user_1"
    let currentUserName = "You"

    func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let new = ChatMessage(userId: currentUserId,
                              userName: currentUserName,
                              avatar: "person.fill",
                              message: newMessage,
                              timestamp: Date())
        messages.append(new)
        newMessage = ""
    }
}
