//
//  CommentModel.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 06/01/26.
//


import SwiftUI
import Combine

// MARK: - Models
struct CommentModel: Codable {
    let limit, page: Int?
    let data: [CommentsData]?
    let totalCount, totalPage: Int?
    
    enum CodingKeys: String, CodingKey {
        case limit, page, data
        case totalCount = "total_count"
        case totalPage = "total_page"
    }
}

struct CommentsData: Codable, Identifiable {
    let id: Int?
    let content: String?
    let user: UserCommentData?
    let createdAt: String?
    var isLikedByCurrentUser: Bool?
    var likeCount: Int?
    var replies: [CommentReply] = []
    
    enum CodingKeys: String, CodingKey {
        case id, content, user
        case createdAt = "created_at"
        case isLikedByCurrentUser, replies
        case likeCount = "like_count"
    }
}

struct UserCommentData: Codable {
    let id: Int?
    let name: String?
    let image: String?
}

struct CommentReply: Codable, Identifiable {
    let id: Int?
    let content: String?
    let createdAt: String?
    let user: CommentUser?
    var likeCount: Int?
    var isLikedByCurrentUser: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, content, user
        case createdAt = "created_at"
        case likeCount = "like_count"
        case isLikedByCurrentUser
    }
}

struct CommentUser: Codable, Identifiable {
    let id: Int?
    let name: String?
    let image: String?
}

enum InputMode {
    case newComment
    case edit(commentId: String)
    case reply(parentCommentId: Int, replyToUser: String)
}
