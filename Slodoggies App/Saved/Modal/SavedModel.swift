//
//  SavedModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 16/07/25.
//

//import Foundation
//
//enum MediaType {
//    case image
//    case video
//}
//
//struct MediaItem: Identifiable {
//    let id = UUID()
//    let mediaType: MediaType
//    let thumbnail: String
//    let videoURL: String?   // ✅ MUST be optional
//}
//
//
//struct SavedList: Codable {
//    let page: String?
//    let limit: String?
//    let totalCount, totalPage: Int?
//    let data: [PostList]?
//
//    enum CodingKeys: String, CodingKey {
//        case page, limit
//        case totalCount = "total_count"
//        case totalPage = "total_page"
//        case data
//    }
//}
//
//// MARK: - WelcomeElement
//struct PostList: Codable {
//    let id, userID, postID: Int?
//    let createdAt, updatedAt: String?
//    let getPost: PostDetails?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case userID = "user_id"
//        case postID = "post_id"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case getPost = "get_post"
//    }
//}
//
//// MARK: - GetPost
//struct PostDetails: Codable {
//    let id, userID, petID: Int?
//    let postTitle, address, latitude, longitude: String?
//    let city, state, zipCode, postType: String?
//    let createdAt, updatedAt: String?
//    let getPostMedia: [GetPostMedia]?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case userID = "user_id"
//        case petID = "pet_id"
//        case postTitle = "post_title"
//        case address, latitude, longitude, city, state
//        case zipCode = "zip_code"
//        case postType = "post_type"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case getPostMedia = "get_post_media"
//    }
//}
//
// MARK: - GetPostMedia
struct GetPostMedia: Codable {
    let id, postID: Int?
    let mediaPath: String?
    let mediaType: String?

    enum CodingKeys: String, CodingKey {
        case id
        case postID = "post_id"
        case mediaPath = "media_path"
        case mediaType = "media_type"
    }
}
//
//// MARK:- Saved Posts Model
//struct SavedPostsResponse: Codable {
//    let success: Bool
//    let code: Int
//    let message: String
//    let data: SavedPostsData
//}
//struct SavedPostsData: Codable,Identifiable {
//    var id: String
//    let page: String
//    let limit: String
//    let totalPage: Int
//    let items: [SavedPostItem]
//}
//
//struct SavedPostItem: Codable, Identifiable {
//    
//    // SwiftUI requirement
//    var id: String { postId }
//    
//    let userId: String
//    let postId: String
//    let type: String
//    let author: PostAuthor
//    let content: PostContent
//    let media: PostMediaInfo
//    let postMedia: [PostMedia]
//    let engagement: PostEngagement
//    let itemsuccess: PostItemStatus
//    let createdAt: String
//}
//struct PostAuthor: Codable {
//    let userId: String
//    let name: String
//    let petName: String
//    let badge: String
//    let time: String
//}
//struct PostContentData: Codable {
//    let title: String
//    let description: String
//    let hashtags: String
//}
//struct PostMediaInfo: Codable {
//    let petImageUrl: String
//    let parentImageUrl: String
//}
//struct PostMediaData: Codable, Identifiable {
//    
//    var id: String { mediaUrl }
//    
//    let mediaUrl: String
//    let type: String
//    let thumbnailUrl: String?
//}
//struct PostEngagement: Codable {
//    let likes: String
//    let comments: String
//    let shares: String
//}
//struct PostItemStatus: Codable {
//    let isLiked: Bool
//    let isSave: Bool
//    let userFollowMe: Bool
//    let iAmFollowing: Bool
//}

import SwiftUI


struct SavedPostsData: Codable {
    let page: Int
    let limit: Int
    let totalPage: Int
    let items: [SavedPostItem]
}

struct SavedPostItem: Codable, Identifiable {
    var id: String { postId }

    let userId: String
    let postId: String
    let type: String
    let author: PostAuthor
    let content: PostContentSaved
    let media: PostMediaInfo
    let postMedia: [PostMediaData]
    let engagement: PostEngagement
    let itemsuccess: PostItemStatus
    let createdAt: String
}

struct PostAuthor: Codable {
    let userId: String
    let name: String
    let petName: String
    let badge: String
    let time: String
}

struct PostContentSaved: Codable {
    let title: String
    let description: String
    let hashtags: String
}

struct PostMediaInfo: Codable {
    let petImageUrl: String
    let parentImageUrl: String
}

struct PostMediaData: Codable, Identifiable {
    var id: String { mediaUrl }

    let mediaUrl: String
    let type: String
    let thumbnailUrl: String?
}

struct PostEngagement: Codable {
    let likes: String
    let comments: String
    let shares: String
}

struct PostItemStatus: Codable {
    let isLiked: Bool
    let isSave: Bool
    let userFollowMe: Bool
    let iAmFollowing: Bool
}
enum MediaType {
    case image
    case video
}

struct MediaItem: Identifiable {
    let id = UUID()
    let mediaType: MediaType
    let thumbnail: String
    let videoURL: String?
}
