//
//  EventModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import Foundation
import SDWebImageSwiftUI

// MARK: - Discover Events API Models

struct DiscoverEventsResponse: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: DiscoverEventsData
}

struct DiscoverEventsData: Codable {
    let page: Int
    let limit: Int
    let total: Int
    let items: [DiscoverEventItem]
}

struct DiscoverEventItem: Codable {
    let postId: String
    let userId: String
    let groupId: String
    let alreadyJoined: Bool
    let type: String
    let author: EventAuthor
    let content: EventContent
    let media: EventMedia
    let postMedia: [HPostMedia]
    var engagement: HEngagement?
    var itemsuccess: ItemSuccessE?
    let createdAt: String
}

struct EventAuthor: Codable {
    let userId: Int
    let name: String
    let badge: String
    let time: String
    let author_type: String
}

struct EventContent: Codable {
    let title: String
    let description: String
    let location: String
    let startTime: String
    let endTime: String
}

struct EventMedia: Codable {
    let imageUrl: String?
    let parentImageUrl: String?
}

struct EventPostMedia: Codable {
    let mediaUrl: String
    let type: String
    let thumbnailUrl: String?
}

struct EventEngagement: Codable {
    var likes: Comments?
    let shares: String
}
struct ItemSuccessE: Codable {
    var isLiked: Bool?
    let isSave: Bool?
    let userFollowMe: Bool?
    let iAmFollowing: Bool?
}


//MARK:- Trending Hashtag model
import Foundation

// MARK: - Main Response
struct TrendingHashtagResponse: Codable {
    let success: Bool?
    let code: Int?
    let message: String?
    let data: [TrendingHashtag]?
}

// MARK: - Hashtag Model
struct TrendingHashtag: Codable {
    let hashtag: String?
    let count: Int?

    private enum CodingKeys: String, CodingKey {
        case hashtag
        case count
    }
}


//MARK:- Pet Places Response model
import Foundation

// MARK: - Main Response
struct PetPlacesResponse: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: PetPlacesData
}

// MARK: - Data Wrapper
struct PetPlacesData: Codable {
    let page: Int
    let limit: Int
    let total: Int
    let petPlaces: [PetPlace]
}

// MARK: - Pet Place Model
struct PetPlace: Codable, Identifiable {
    
    // SwiftUI requires a unique id
    let id: String
    let image: String?
    let title: String
    let overview: String
    let location: String
    let distance: String

    enum CodingKeys: String, CodingKey {
        case id = "placeId"
        case image
        case title
        case overview
        case location
        case distance
    }
}
