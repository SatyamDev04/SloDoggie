//
//  ChatListViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 11/08/25.
//

import Foundation

class ChatListViewModel: ObservableObject {
    @Published var query: String = "" {
        didSet {
            filterChats()
        }
    }
    
    @Published var chats: [ChatModel] = [
        ChatModel(profileImageName: "profile1",
                  name: "Jane Cooper",
                  message: "I hope it goes well.",
                  time: "14:41",
                  unreadCount: 2),
        
        ChatModel(profileImageName: "profile2",
                  name: "Event Community 1",
                  message: "So, what’s your plan this weekend?",
                  time: "15:41",
                  unreadCount: 2),
        
        ChatModel(profileImageName: "profile3",
                  name: "SLO K9 Spa & Grooming",
                  message: "Hello! I am interested in your grooming service.",
                  time: "14:41",
                  unreadCount: 4)
    ]
    
    @Published var filteredChats: [ChatModel] = []
    
    init() {
        filteredChats = chats
    }
    
    private func filterChats() {
        if query.isEmpty {
            filteredChats = chats
        } else {
            filteredChats = chats.filter {
                $0.name.lowercased().contains(query.lowercased()) ||
                $0.message.lowercased().contains(query.lowercased())
            }
        }
    }
}
