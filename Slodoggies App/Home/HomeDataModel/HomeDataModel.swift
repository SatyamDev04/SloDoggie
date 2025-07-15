//
//  HomeDataModel.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import Foundation

enum FeedItemType {
    case post(PostModel)
    case ad(AdModel)
    case event(EventModel)
    case video(VideoModel)
}

struct PostModel: Identifiable {
    let id = UUID()
    let username: String
    let petName: String
    let time: String
    let text: String
    let image: String
    let likes: Int
    let comments: Int
    let shares: Int
    let tags: [String]
}

struct AdModel: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let subtitle: String
    let likes: Int
    let comments: Int
    let shares: Int
}

struct EventModel: Identifiable {
    let id = UUID()
    let title: String
    let time: String
    let duration: String
    let location: String
    let image: String
    let likes: Int
    let shares: Int
}

struct VideoModel: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let tags: [String]
    let thumbnail: String
    let likes: Int
    let comments: Int
    let shares: Int
}

