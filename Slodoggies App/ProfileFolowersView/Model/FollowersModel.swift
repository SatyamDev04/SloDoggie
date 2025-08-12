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
