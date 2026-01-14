//
//  FollowersModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import Foundation

struct UserModel: Identifiable {
    let id: UUID = UUID()
    let name: String
    let isVerified: Bool
    let profileImage: String // URL or asset name
    var isFollowBack: Bool
}
// MARK: - Welcome
struct FollowersListResponse: Codable {
    let page: String?
    let limit,totalFollowers,totalFollowing, totalPage: Int?
    let data: [FollowersList]?

    enum CodingKeys: String, CodingKey {
        case page, limit
        case totalFollowers = "total_followers"
        case totalFollowing = "total_following"
        case totalPage = "total_page"
        case data
    }
}

// MARK: - Datum
struct FollowersList: Codable {
    let id: Int?
    let name: String?
    let profilePic: String?
    let isFollowing: Bool?
    let isFollowingMe: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name
        case profilePic = "profile_pic"
        case isFollowing = "is_following"
        case isFollowingMe = "is_following_me"
    }
}
