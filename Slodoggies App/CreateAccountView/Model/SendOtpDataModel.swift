//
//  Welcome.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 11/11/25.
//


// MARK: - Welcome
struct SendOtpDataModel: Codable {
    let otp: Int?
    let emailOrPhone: String?
}

struct profileDetails: Hashable,Codable {
    var email_Phone: String?
    var fullName: String?
    var password: String?
    var otp: Int?
}
