//
//  HomeDataModel.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import SwiftUI
import Foundation
 
// MARK: - DataClass
struct HomeModel: Codable {
    let page, limit: Int?
    let totalPage: Int?
    let items: [HomeItem]?
}
 
// MARK: - Item
struct HomeItem: Codable {
    let userID, postID: String?
    let userType: RType?
    let type: ItemType?
    let userPost: Bool?
    let author: HomeAuthor?
    let content: Contentss?
    let media: HMedia?
    let postMedia: [HPostMedia]?
    var engagement: HEngagement?
    var itemsuccess: Itemsuccess?
    let createdAt: String?
    let sponsored: Bool?
    let groupID: String?
    let alreadyJoined: Bool?
    var commentCount: Int?
 
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case postID = "postId"
        case userType = "user_type"
        case type
        case userPost = "user_post"
        case author, content, media, postMedia, engagement, itemsuccess, createdAt, sponsored
        case groupID = "groupId"
        case alreadyJoined
        case  commentCount
    }
}
 
// MARK: - Author
struct HomeAuthor: Codable {
    let userID, name, time: String?
    let authorType: RType?
    let petName: String?
    let badge: Badge?
 
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case name, time
        case authorType = "author_type"
        case petName, badge
    }
}
 
enum RType: String, Codable {
    case owner = "Owner"
    case professional = "Professional"
}
 
enum Badge: String, Codable {
    case eventHost = "EventHost"
    case petOwner = "PetOwner"
}
 
// MARK: - Content
struct Contentss: Codable {
    let title, description, hashtags, location: String?
    let startTime, endTime: String?
}
 
// MARK: - Engagement
struct HEngagement: Codable {
    var likes, comments, shares: Comments?
}
 
extension HEngagement {
    var likesCount: Int {
        switch likes {
        case .integer(let v):
            return v
        case .string(let s):
            return Int(s) ?? 0
        default:
            return 0
        }
    }
}
 
enum Comments: Codable {
    case integer(Int)
    case string(String)
 
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Comments.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Comments"))
    }
 
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
 
// MARK: - Itemsuccess
struct Itemsuccess: Codable {
    var isLiked, isSave, userFollowMe, iAmFollowing: Bool?
    var intrested: Bool?
}
 
// MARK: - Media
struct HMedia: Codable {
    let parentImageURL: String?
    let petImageURL: String?
 
    enum CodingKeys: String, CodingKey {
        case parentImageURL = "parentImageUrl"
        case petImageURL = "petImageUrl"
    }
}
 
// MARK: - PostMedia
struct HPostMedia: Codable {
    let mediaURL: String?
    let type: PostMediaType?
    let thumbnailURL: String?
 
    enum CodingKeys: String, CodingKey {
        case mediaURL = "mediaUrl"
        case type
        case thumbnailURL = "thumbnailUrl"
    }
}
 
enum PostMediaType: String, Codable {
    case image = "image"
    case video = "video"
}
 
enum ItemType: String, Codable {
    case community = "community"
    case normal = "normal"
    case sponsored = "sponsored"
}


// Model for my Post


// MARK: - DataClass
struct MyPostModel: Codable {
    let totalPage: Int?
    let data: [MyPostItem]?
    let totalPosts, limit, page: Int?

    enum CodingKeys: String, CodingKey {
        case totalPage = "total_page"
        case data
        case totalPosts = "total_posts"
        case limit, page
    }
}

// MARK: - Datum
struct MyPostItem: Codable {
    let zipCode: String?
    let type: ItemType?
    let getPostMedia: [GetPostMedia]?
    let longitude: String?
    var getPostLikeCount: Int?
    let postType: String?
    var itemSuccess: ItemSuccess?
    let createdAt, updatedAt: String?
    let state: String?
    let latitude, time: String?
    let getPetDetail: getPetDetails?
    let getPostCommentCount: Int?
    let city: String?
    let getSavedPostCount: Int?
    let getUserDetail: GetUserDetail?
    let userID, id: Int?
    var postTitle: String?
    let getPostShareCount: Int?
    let address: String?
    let petID: Int?

    enum CodingKeys: String, CodingKey {
        case zipCode = "zip_code"
        case getPostMedia = "get_post_media"
        case longitude
        case getPostLikeCount = "get_post_like_count"
        case postType = "post_type"
        case itemSuccess
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case state, latitude, time
        case getPetDetail = "get_pet_detail"
        case getPostCommentCount = "get_post_comment_count"
        case city
        case getSavedPostCount = "get_saved_post_count"
        case getUserDetail = "get_user_detail"
        case userID = "user_id"
        case id
        case postTitle = "post_title"
        case getPostShareCount = "get_post_share_count"
        case address
        case petID = "pet_id"
        case type
        
        
    }
}

// MARK: - GetPostMedia
//struct GetPostMedia: Codable {
//    let mediaType: String?
//    let mediaPath: String?
//    let postID, id: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case mediaType = "media_type"
//        case mediaPath = "media_path"
//        case postID = "post_id"
//        case id
//    }
//}

// MARK: - GetUserDetail
struct getPetDetails: Codable {
    let id: Int?
    let pet_name: String?
    let pet_image: String?
}

// MARK: - ItemSuccess
//struct ItemSuccess: Codable {
//    let isSaved, isLiked: Bool?
//}

