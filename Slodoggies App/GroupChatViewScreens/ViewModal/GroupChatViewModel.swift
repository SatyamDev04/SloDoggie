//
//  GroupChatViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 19/08/25.
//

import Foundation

class GroupChatViewModel: ObservableObject {
    @Published var messages: [GroupChatMessage] = [
        GroupChatMessage(senderName: "Admin", message: "Hi! Thank you for reaching out. How can I assist you today?", isCurrentUser: false, timestamp: Date(), profileImage: "profile1"),
        GroupChatMessage(senderName: "You", message: "Hello! I am interested in your grooming service.", isCurrentUser: true, timestamp: Date(), profileImage: "profile2"),
        GroupChatMessage(senderName: "Admin", message: "Sure! We have basic, premium, and deluxe grooming packages. Would you like details?", isCurrentUser: false, timestamp: Date(), profileImage: "profile1")
    ]
    
    @Published var newMessage: String = ""
    
    func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let message = GroupChatMessage(
            senderName: "You",
            message: newMessage,
            isCurrentUser: true,
            timestamp: Date(),
            profileImage: "profile2"
        )
        messages.append(message)
        newMessage = ""
    }
}
