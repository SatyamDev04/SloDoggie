//
//  Welcome.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 13/11/25.
//


// MARK: - Welcome
struct OwnerDetails: Codable, Hashable {
    let id: Int?
    let userType, name, email, image, bio: String?
    let phone, forgotOtp, emailVerifiedAt: String?
    let deviceType, fcmToken: String?
    let userStatus: Int?
    let createdAt, updatedAt: String?
    let deletedAt: String?
    let parentType: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userType = "user_type"
        case name, email, phone, image, bio
        case forgotOtp = "forgot_otp"
        case emailVerifiedAt = "email_verified_at"
        case deviceType = "device_type"
        case fcmToken = "fcm_token"
        case userStatus = "user_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case parentType = "parent_type"
    }
}
