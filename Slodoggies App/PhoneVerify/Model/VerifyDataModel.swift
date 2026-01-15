//
//  Welcome.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 11/11/25.
//

// MARK: - Welcome
struct VerifyDataModel: Hashable, Codable {
    let user: Details?
    let token: String?
}

// MARK: - User
struct Details: Hashable, Codable {
    let name, email: String?
    let phone: String?
    let deviceType, fcmToken, userType, updatedAt: String?
    let createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case name, email, phone
        case deviceType = "device_type"
        case fcmToken = "fcm_token"
        case userType = "user_type"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
