//
//  ChatListViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 11/08/25.
//

import Foundation

class ChatListViewModel: ObservableObject {
    @Published var chats: [ChatModel] = [
        ChatModel(profileImageName: "profile1",
                  name: "Jane Cooper",
                  message: "I hope it goes well.",
                  time: "14:41"),
        ChatModel(profileImageName: "profile2",
                  name: "Event Community 1",
                  message: "So, what’s your plan this weekend?",
                  time: "15:41"),
        ChatModel(profileImageName: "profile3",
                  name: "SLO K9 Spa & Grooming",
                  message: "Hello! I am interested in your grooming service.",
                  time: "14:41")
    ]
}
