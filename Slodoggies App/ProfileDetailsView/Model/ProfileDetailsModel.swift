//
//  DetailsModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import Foundation

struct PetDetails: Identifiable {
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

struct SelectedPetDetails: Identifiable {
    let id: UUID = UUID() // or use your own unique ID
    let image: String
    let status: Int
}

struct UserDetails {
    var name: String
    var tag: String
    var bio: String
    var image: String
}

struct GalleryItemDetails: Identifiable {
    let id: UUID
    let image: String
    let isVideo: Bool
}


// MARK: - Welcome
struct OwnerProfileDetail: Codable {
    let pets: [PetsDetailData]?
    let owner: OwnerDetails?
    let postCount, followerCount, followingCount: String?

    enum CodingKeys: String, CodingKey {
        case pets, owner
        case postCount = "post_count"
        case followerCount = "follower_count"
        case followingCount = "following_count"
    }
}

// MARK: - Owner
struct Owner: Codable, Hashable {
    let id, userID: Int?
    let name, email, phone, address: String?
    let latitude, longitude: String?
    let image: String?
    let bio, parentType: String?
    let userStatus: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name, email, phone, address, latitude, longitude, image, bio
        case parentType = "parent_type"
        case userStatus = "user_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
