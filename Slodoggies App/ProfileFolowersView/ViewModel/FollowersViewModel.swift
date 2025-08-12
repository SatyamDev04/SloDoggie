//
//  FollowersViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import Foundation
import Combine

class FollowersViewModel: ObservableObject {
    @Published var followers: [UserModel] = []
    @Published var following: [UserModel] = []
    @Published var searchText: String = ""
    @Published var selectedTab: Tab = .followers
    
    enum Tab {
        case followers, following
    }
    
    var filteredUsers: [UserModel] {
        let list = selectedTab == .followers ? followers : following
        if searchText.isEmpty {
            return list
        } else {
            return list.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    init() {
        // Load mock data
        followers = [
            UserModel(name: "Adison Dias", isVerified: true, profileImage: "profile1", isFollowBack: false),
            UserModel(name: "Ryan Dias", isVerified: false, profileImage: "profile2", isFollowBack: true),
            UserModel(name: "Anika Torff", isVerified: true, profileImage: "profile3", isFollowBack: false),
            UserModel(name: "Zain Dorwart", isVerified: false, profileImage: "profile4", isFollowBack: false),
            UserModel(name: "Marcus Culhane", isVerified: true, profileImage: "profile5", isFollowBack: false),
            UserModel(name: "Cristofer Torff", isVerified: false, profileImage: "profile6", isFollowBack: true),
            UserModel(name: "Kierra Westervelt", isVerified: true, profileImage: "profile1", isFollowBack: false),
            UserModel(name: "Adison Dias", isVerified: false, profileImage: "profile2", isFollowBack: true)
        ]
        
        following = [
            UserModel(name: "Zain Denwart", isVerified: false, profileImage: "profile3", isFollowBack: false),
            UserModel(name: "Ryan Dias", isVerified: false, profileImage: "profile2", isFollowBack: false),
            UserModel(name: "Anika Torff", isVerified: true, profileImage: "profile3", isFollowBack: false),
            UserModel(name: "Zain Dorwart", isVerified: false, profileImage: "profile4", isFollowBack: false),
            UserModel(name: "Marcus Culhane", isVerified: true, profileImage: "profile5", isFollowBack: false),
            UserModel(name: "Cristofer Torff", isVerified: false, profileImage: "profile6", isFollowBack: true),
            UserModel(name: "Kierra Westervelt", isVerified: true, profileImage: "profile1", isFollowBack: false),
            UserModel(name: "Adison Dias", isVerified: false, profileImage: "profile2", isFollowBack: false)
        ]
    }
    
    func remove(user: UserModel) {
        if selectedTab == .followers {
            followers.removeAll { $0.id == user.id }
        } else {
            following.removeAll { $0.id == user.id }
        }
    }
}
