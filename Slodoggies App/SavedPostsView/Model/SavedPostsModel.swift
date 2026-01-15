//
//  SavedPostsModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 08/09/25.
//

import Foundation

enum SavedFeedItemType {
    case post(SavedPostModel)
   
}

struct SavedPostModel: Identifiable {
    let id = UUID()
    let username: String
    let petName: String
    let time: String
    let text: String
    let image: String
    let likes: Int
    let comments: Int
    let shares: Int
    let tags: [String]
}

// MARK: - Welcome
struct SavedPostResponse: Codable {
    let page: String?
    let totalPosts, limit, totalPage: Int?
    let data: [SavedPostDataModel]?

    enum CodingKeys: String, CodingKey {
        case page, limit
        case totalPosts = "total_posts"
        case totalPage = "total_page"
        case data
    }
}

// MARK: - Datum
struct SavedPostDataModel: Codable{
    let id, userID: Int?
    let petID: Int?
    let postTitle, address, latitude, longitude: String?
    let city, state, zipCode, postType: String?
    let createdAt, updatedAt: String?
    let getPostLikeCount, getPostCommentCount, getPostShareCount, getSavedPostCount: Int?
    var itemSuccess: ItemSuccess?
    let getUserDetail: GetUserDetail?
    let getPetDetail: PetsDetailData?
    let getPostMedia: [GetPostMedia]?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case petID = "pet_id"
        case postTitle = "post_title"
        case address, latitude, longitude, city, state
        case zipCode = "zip_code"
        case postType = "post_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case getPostLikeCount = "get_post_like_count"
        case getPostCommentCount = "get_post_comment_count"
        case getPostShareCount = "get_post_share_count"
        case getSavedPostCount = "get_saved_post_count"
        case itemSuccess
        case getUserDetail = "get_user_detail"
        case getPetDetail = "get_pet_detail"
        case getPostMedia = "get_post_media"
    }
}

// MARK: - GetUserDetail
struct GetUserDetail: Codable {
    let id: Int?
    let name: String?
    let image: String?
}

// MARK: - ItemSuccess
struct ItemSuccess: Codable {
    var isLiked, isSaved: Bool?
}


struct EditPostModel: Codable {
    let id, userID, petID: Int?
    let postTitle, address, latitude, longitude: String?
    let city, state, zipCode, postType: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case petID = "pet_id"
        case postTitle = "post_title"
        case address, latitude, longitude, city, state
        case zipCode = "zip_code"
        case postType = "post_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
