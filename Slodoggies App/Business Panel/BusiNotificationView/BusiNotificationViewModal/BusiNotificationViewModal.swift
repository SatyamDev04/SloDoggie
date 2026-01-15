//
//  BusiNotificationViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 26/08/25.
//

import SwiftUI

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [BusiNotificationModel] = []
    
    init() {
        loadNotifications()
    }
    
    func loadNotifications() {
        notifications = [
            BusiNotificationModel(username: "_username", userImage: "user1", type: .review(rating: 5, message: "Great service!"), timeAgo: "17 Min."),
            BusiNotificationModel(username: "_username", userImage: "user2", type: .like(imageURL: "image"), timeAgo: "17 Min."),
            BusiNotificationModel(username: "_username", userImage: "user3", type: .follow, timeAgo: "17 Min."),
            BusiNotificationModel(username: "_username", userImage: "user1", type: .review(rating: 5, message: "Great service!"), timeAgo: "17 Min."),
            BusiNotificationModel(username: "_username", userImage: "user4", type: .follow, timeAgo: "17 Min."),
            BusiNotificationModel(username: "_username", userImage: "user5", type: .follow, timeAgo: "17 Min."),
            BusiNotificationModel(username: "_username", userImage: "user6", type: .like(imageURL: "image"), timeAgo: "17 Min."),
            BusiNotificationModel(username: "_username", userImage: "user7", type: .like(imageURL: "image"), timeAgo: "17 Min.")
        ]
    }
}

// MARK: - Row View
struct NotificationRow: View {
    let notification: BusiNotificationModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // User Profile Image (Left)
            Image(notification.userImage)
                .resizable()
                .scaledToFill()
                .frame(width: 42, height: 42)
                .clipShape(Circle())
            
            // Main Text
            VStack(alignment: .leading, spacing: 4) {
                switch notification.type {
                    
                case .like:
                    HStack {
                        Text(notification.username)
                            .font(.custom("Outfit-Medium", size: 14))
                            .lineLimit(1)
                        Text("liked your post.")
                    }
                    
                case .follow:
                    HStack {
                        Text(notification.username)
                            .font(.custom("Outfit-Medium", size: 14))
                            .lineLimit(1)
                        Text("started following you.")
                    }
                    
                case .review(let rating, let message):
                    HStack(spacing: 2) {
                        Text(notification.username)
                            .font(.custom("Outfit-Medium", size: 14))
                            .lineLimit(1)
                        // ⭐️ Smaller stars
                        HStack(spacing: 2) {
                            ForEach(0..<rating, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 14, height: 14) // 👈 small
                                    .foregroundColor(.yellow)
                            }
                        }
                        
                        Text("\"\(message)\"")
                            .font(.custom("Outfit-Regular", size: 14))
                            .lineLimit(1)
                        
                        Text(notification.timeAgo)
                            .font(.custom("Outfit-Regular", size: 10))
                            .foregroundColor(Color(hex: "#949494"))
                    }
                }
            }
            
            Spacer()
            
            // Right-side attachment (post preview image if like)
            switch notification.type {
            case .like(let postImage):
                Image(postImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .cornerRadius(6)
            
            default:
                EmptyView()
            }
        }
        .padding(.vertical, 6)
    }
}
