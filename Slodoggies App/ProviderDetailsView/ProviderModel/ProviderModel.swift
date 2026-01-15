//
//  ProviderModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import Foundation

struct ProviderModel: Identifiable {
    let id: UUID
    let name: String
    let rating: Double
    let address: String
    let phone: String
    let website: String
    let description: String
    var isFollowing: Bool
    let services: [Service]
    let reviews: [Review]
    let galleryImages: [String]
}

struct Service: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let price: Double
    let photos: [String]
}

struct Review: Identifiable {
    let id: UUID
    let reviewerName: String
    let rating: Int
    let comment: String
    let timeAgo: String
}

//import Foundation
//
//// MARK: - Base Response
//struct ServiceDetailsResponse: Codable {
//    let success: Bool
//    let code: Int
//    let message: String
//    let data: ServiceDetailsData
//}
//
//// MARK: - Main Data Object
//struct ServiceDetailsData: Codable {
//    let businessName: String?
//    let profileImage: String?
//    let rating: Int?
//    let milesAway: String?
//    let businessDescription: String?
//    let category: String?
//    let phone: String?
//    let providerName: String?
//    let website: String?
//    let address: String?
//    let verificationStatus: Bool?
//    let services: [Service]?
//    let ratingsAndReviews: RatingsAndReviews?
//
//    enum CodingKeys: String, CodingKey {
//        case businessName
//        case profileImage
//        case rating
//        case milesAway
//        case businessDescription
//        case category
//        case phone
//        case providerName = "provider_name"
//        case website
//        case address
//        case verificationStatus = "verificationstatus"
//        case services
//        case ratingsAndReviews
//    }
//}
//
//// MARK: - Service (empty array currently)
//struct Service: Codable {
//    // Add properties when API provides service fields
//}
//
//// MARK: - Ratings & Reviews
//struct RatingsAndReviews: Codable {
//    let serviceId: Int?
//    let averageRating: Int?
//    let totalReviews: Int?
//    let ratingDistribution: RatingDistribution?
//    let reviews: [Review]?
//}
//
//// MARK: - Rating Distribution (Dynamic Keys)
//struct RatingDistribution: Codable {
//    let five: Int?
//    let four: Int?
//    let three: Int?
//    let two: Int?
//    let one: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case five = "5"
//        case four = "4"
//        case three = "3"
//        case two = "2"
//        case one = "1"
//    }
//}
//
//// MARK: - Review (empty array currently)
//struct Review: Codable {
//    // Add properties when API provides review fields
//}
