//
//  BusiServiceModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//
import Foundation

struct BusiServiceModel: Identifiable {
    let id: UUID
    let name: String
    let rating: Double
    let address: String
    let phone: String
    let website: String
    let description: String
    var isFollowing: Bool
    let services: [BusiService]
    let reviews: [BusiServiceReview]
    let galleryImages: [String] // image URLs or asset names
}

struct BusiService: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let price: Double
    let photos: [String]
}

struct BusiServiceReview: Identifiable {
    let id: UUID
    let reviewerName: String
    let rating: Int
    let comment: String
    let timeAgo: String
    var reply: ReviewReply? = nil
    let canReply: Bool
}

struct ReviewReply: Equatable {
    var authorName: String
    var role: String        // e.g. "Provider"
    var time: String        // e.g. "Just now"
    var text: String
}

// New Model

// MARK: - DataClass
struct BusinessServiceModel: Codable {
    let businessName, userType: String?
    let profileImage: String?
    let rating: String?
    let milesAway, businessDescription: String?
    let category: [String]?
    let phone, providerName, website, address: String?
    let verificationstatus: Bool?
    var services: [BusinessService]?
    let ratingsAndReviews: RatingsAndReviews?

    enum CodingKeys: String, CodingKey {
        case businessName
        case userType = "user_type"
        case profileImage, rating, milesAway, businessDescription, category, phone
        case providerName = "provider_name"
        case website, address, verificationstatus, services, ratingsAndReviews
    }
}

// MARK: - RatingsAndReviews
struct RatingsAndReviews: Codable {
    let serviceID: Int?
    let averageRating: String?
    let totalReviews: Int?
    let ratingDistribution: [String: Int]?
    let reviews: [BusinessReview]?

    enum CodingKeys: String, CodingKey {
        case serviceID = "serviceId"
        case averageRating, totalReviews, ratingDistribution, reviews
    }
}

// MARK: - Review
struct BusinessReview: Codable {
    let reviewID: Int?
    let user: BusinessUser?
    let rating: Int?
    let timeAgo, comment: String?
    let replies: [businessReply]?
    let canReply: Bool?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case reviewID = "reviewId"
        case user, rating, timeAgo, comment, replies, canReply, createdAt
    }
}

// MARK: - Reply
struct businessReply: Codable {
    let replyID: Int?
    let user: BusinessUser?
    let timeAgo, comment, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case replyID = "replyId"
        case user, timeAgo, comment, createdAt
    }
}

// MARK: - User
struct BusinessUser: Codable {
    let userID: Int?
    let name: String?
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case name, profileImage
    }
}

// MARK: - Service
struct BusinessService: Codable {
    let serviceID: Int?
    let serviceTitle, price, currency, description: String?
    let media: [BusinessMedia]?

    enum CodingKeys: String, CodingKey {
        case serviceID = "serviceId"
        case serviceTitle, price, currency, description, media
    }
}

// MARK: - Media
struct BusinessMedia: Codable {
    let postID: Int?
    let mediaURL: String?
    let mediaType: BusinessMediaType?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case mediaURL = "mediaUrl"
        case mediaType
    }
}

enum BusinessMediaType: String, Codable {
    case image = "image"
}
