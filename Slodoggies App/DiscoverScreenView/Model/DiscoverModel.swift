//
//  DiscoverViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import Foundation

struct DiscoverModel: Identifiable {
    let id = UUID()
    let name: String
    let role: String
    let imageName: String
}

struct PetPlaceModel: Identifiable {
    let id = UUID()
    let name: String
    let place: String?
    let distance: String?
    let description: String?
    let imageName: String
}


// MARK:- Model For Pets Near You
import Foundation

struct PetsNearYouResponse: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: PetsNearYouData
}

struct PetsNearYouData: Codable {
    let page: Int
    let limit: Int
    let total: Int
    let pets: [PetNearYouAPIModel]
}

struct PetNearYouAPIModel: Codable {
    let petId: String
    let pet_owner_id: String
    let name: String
    let image: String?
    let distance: String?
}

//MARK:- Activities Data Model

import Foundation

// MARK: - Root Model
struct ActivitiesResponse: Codable {
    let success: Bool?
    let code: Int?
    let message: String?
    let data: ActivitiesData?
}

// MARK: - Data Section (Pagination + Items)
struct ActivitiesData: Codable {
    let page: Int?
    let limit: Int?
    let totalCount: Int?
    let items: [PostActivitiesItem]?
}

// MARK: - Single Post Item
struct PostActivitiesItem: Codable, Identifiable {
    let postId: String?
    let userId: String?
    let type: String?

    let author: Author?
    let content: PostContent?
    let media: ActivityMedia?
    let postMedia: [PostMedia]?
    var engagement: Engagement?
    var itemsuccess: ItemSuccessA?
    let createdAt: String?  // If needed convert to Date later
    var id: String { postId ?? UUID().uuidString }
}

// MARK: - Author
struct Author: Codable {
    let userId: Int?
    let name: String?
    let petName: String?
    let pet_type: String?
    let author_type : String?
}

// MARK: - Content
struct PostContent: Codable {
    let title: String?
    let time: String?
    let description: String?
    let hashtags: String?
}

// MARK: - Media (Profile Images)
struct ActivityMedia: Codable {
    let petImageUrl: String?
    let parentImageUrl: String?
}

// MARK: - Post Media (Images / Videos)
struct PostMedia: Codable {
    let mediaUrl: String?
    let type: String?
    let thumbnailUrl: String?
}

// MARK: - Engagement (Counts)
struct Engagement: Codable {
    var likes: Comments?
    let comments: Comments?
    let shares: Comments?
}

// MARK: - ItemSuccess (Flags)
struct ItemSuccessA: Codable {
    var isLiked: Bool?
    let isSave: Bool?
    let userFollowMe: Bool?
    let iAmFollowing: Bool?
}

