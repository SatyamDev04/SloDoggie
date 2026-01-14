//
//  ChatViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/07/25.
//

import Foundation
import Combine
import UIKit

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [
        ChatMessage(userId: "user_2",
                    userName: "Jane Cooper",
                    avatar: "ChatProfile",
                    message: "Hello! I am interested in your grooming service.",
                    timestamp: Date()),
        
        ChatMessage(userId: "user_1",
                    userName: "You",
                    avatar: "ChatProfile",
                    message: "Hi! Thank you for reaching out. How can I assist you today?",
                    timestamp: Date()),
        
        ChatMessage(userId: "user_2",
                    userName: "Jane Cooper",
                    avatar: "ChatProfile",
                    message: "Can you tell me about the available packages?",
                    timestamp: Date()),
        
        ChatMessage(userId: "user_2",
                    userName: "Aspen Carder",
                    avatar: "ChatProfile",
                    message: "",
                    timestamp: Date(),
                    isCard: true,
                    cardTitle: "Aspen Carder",
                    cardSubtitle: "The game in...",
                    cardImage: "ChatProfile")
    ]
    
    @Published var newMessage = ""
    
    let currentUserId = "user_1"
    let currentUserName = "You"
    
    func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let new = ChatMessage(userId: currentUserId,
                              userName: currentUserName,
                              avatar: "profile_me",
                              message: newMessage,
                              timestamp: Date())
        messages.append(new)
        newMessage = ""
      }
    
//    func addImageMessage(_ image: UIImage) {
//        let new = ChatMessage(id: UUID(), userId: currentUserId, text: "[Image]", image: image, timestamp: Date())
//        messages.append(new)
//    }
//
//    func addDocumentMessage(_ url: URL) {
//        let new = ChatMessage(id: UUID(), userId: currentUserId, text: url.lastPathComponent, fileURL: url, timestamp: Date())
//        messages.append(new)
//      }
    }
