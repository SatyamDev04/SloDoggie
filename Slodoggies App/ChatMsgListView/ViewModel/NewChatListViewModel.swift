//
//  NewChatListViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 27/10/25.
//

import Foundation
import Combine

class NewChatListViewModel: ObservableObject {
    @Published var chatList: [NewChatListModel] = []
    @Published var searchText: String = ""
    
    var filteredUsers: [NewChatListModel] {
        if searchText.isEmpty {
            return chatList
        } else {
            return chatList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    init() {
        chatList = [
            NewChatListModel(name: "Adison Dias", isVerified: true, profileImage: "profile1"),
            NewChatListModel(name: "Ryan Dias", isVerified: false, profileImage: "profile2"),
            NewChatListModel(name: "Anika Torff", isVerified: true, profileImage: "profile3"),
            NewChatListModel(name: "Zain Dorwart", isVerified: false, profileImage: "profile4"),
            NewChatListModel(name: "Marcus Culhane", isVerified: true, profileImage: "profile5"),
            NewChatListModel(name: "Cristofer Torff", isVerified: false, profileImage: "profile6"),
            NewChatListModel(name: "Kierra Westervelt", isVerified: true, profileImage: "profile1"),
            NewChatListModel(name: "Adison Dias", isVerified: false, profileImage: "profile2")
        ]
    }
}
