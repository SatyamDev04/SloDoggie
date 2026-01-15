//
//  BusiProfileViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 27/08/25.
//

import Foundation
 
struct BusiPet: Identifiable {
    let id: UUID
    var name: String
    var breed: String
    var age: String
    var bio: String
    var image: String // URL or asset name
    var posts: Int
    var followers: Int
    var following: Int
}
 
struct BusiSelectedPet: Identifiable {
    let id: UUID = UUID() // or use your own unique ID
    let image: String
    let status: Int
}
 
// MARK: - DataClass
struct BusiUser: Codable {
    let id, userID: Int?
    let providerName, businessName, email, phone: String?
    let bio: String?
    let category: [String]?
    let address, city, state, zipCode: String?
    let latitude, longitude, websiteURL: String?
    let businessLogo: String?
    let availableDays: [String]?
    let availableTime: String?
    let verificationDocs: [String]?
    let userStatus: Int?
    let createdAt, updatedAt, postCount, followerCount: String?
    let followingCount: String?
 
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case providerName = "provider_name"
        case businessName = "business_name"
        case email, phone, bio, category, address, city, state
        case zipCode = "zip_code"
        case latitude, longitude
        case websiteURL = "website_url"
        case businessLogo = "business_logo"
        case availableDays = "available_days"
        case availableTime = "available_time"
        case verificationDocs = "verification_docs"
        case userStatus = "user_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case postCount = "post_count"
        case followerCount = "follower_count"
        case followingCount = "following_count"
    }
}
 
// MARK: - DataClass
struct GalleyResponse: Codable {
    let page, limit, totalItems, totalPage: Int?
    let data: [BusiGalleryItem]?
 
    enum CodingKeys: String, CodingKey {
        case page, limit
        case totalItems = "total_items"
        case totalPage = "total_page"
        case data
    }
}
 
// MARK: - Datum
struct BusiGalleryItem: Codable {
    let id, userID: Int?
    let petID: Int?
    let postTitle, address, latitude, longitude: String?
    let city, state, zipCode: String?
    let postType, createdAt, updatedAt: String?
    let media: [MediaGallery]?
    let type: String?
 
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
        case media, type
    }
}
 
// MARK: - Media
struct MediaGallery: Codable {
    let url: String?
    let type: String?
}
