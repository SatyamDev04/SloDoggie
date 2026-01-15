//
//  FaqModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 15/07/25.
//

import Foundation

//struct FAQItem: Identifiable {
//    let id = UUID()
//    let question: String
//    let answer: String
//}

import Foundation

// MARK: - Main Response
struct FAQResponse: Codable {
    let success: Bool
    let code: Int
    let message: String
    let data: [FAQItem]
}

// MARK: - FAQ Item
struct FAQItem: Codable, Identifiable {
    
    // SwiftUI requires a unique id
    let id = UUID()
    
    let question: String
    let answer: String

    // Prevent Codable error due to UUID
    enum CodingKeys: String, CodingKey {
        case question
        case answer
    }
}
