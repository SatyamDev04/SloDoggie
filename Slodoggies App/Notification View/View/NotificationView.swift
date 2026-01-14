//
//  NotificationView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 28/07/25.
//

import SwiftUI

struct NotificationView: View {
    @StateObject private var viewModel = NotificationViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack(spacing: 20) {
                Button(action: {
                    coordinator.pop()
                }) {
                    Image("Back")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                Text("Notifications")
                    .font(.custom("Outfit-Medium", size: 20))
                    .foregroundColor(Color(hex: "#221B22"))
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            
            Divider()
                .frame(height: 2)
                .background(Color(hex: "#258694"))
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 🔹 Today Section Title
                    Text("Today")
                        .font(.custom("Outfit-Medium", size: 16))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 16)
                        //.padding(.leading, 10)
                    Divider()
                        .frame(height: 1)
                        .background(Color(hex: "#258694"))
                        .padding(.leading)
                        .padding(.trailing)
                    // 🔹 Special Event Saved Notification
                    HStack(alignment: .top, spacing: 12) {
                        Image("CongratulationIcon") // replace with your icon
                            .resizable()
                            .frame(width: 38, height: 38)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Event Saved")
                                .font(.custom("Outfit-Medium", size: 14))
                                .foregroundColor(.primary)
                            Text("You’ve marked this event as Interested — we’ll keep you updated!")
                                .font(.custom("Outfit-Regular", size: 14))
                                .foregroundColor(Color(hex: "#949494"))
                            Text(" 🐾")
                                .font(.custom("Outfit-Regular", size: 12))
                                .foregroundColor(Color(hex: "#9D9D9D"))
                            Text("Just Now")
                                .font(.custom("Outfit-Regular", size: 12))
                                .foregroundColor(Color(hex: "#9D9D9D"))
                                .padding(.trailing, 4)
                        }
                       
                       // Spacer()
                        
                        Button(action: {
                            coordinator.push(.groupChatView)
                        }) {
                            Text("Join Chat")
                                .font(.custom("Outfit-Medium", size: 12))
                                .foregroundColor(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(Color(hex: "#258694"))
                                .cornerRadius(6)
                        }
                    }
                    //.padding()
                    //.background(Color.white)
                    .cornerRadius(6)
                    .padding(.horizontal, 16)
                    
                    // 🔹 Notification List
                    VStack(spacing: 12) {
                        ForEach(viewModel.notificationsToday) { notification in
                            NotificationRowView(notification: notification)
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.top, 12)
            }
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .bottom)
    }
}

struct NotificationRowView: View {
    let notification: NotificationItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(notification.profileImageURL)
                .resizable()
                .scaledToFill()
                .frame(width: 38, height: 38)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                (
                    Text(notification.username)
                        .font(.custom("Outfit-Medium", size: 14))
                        .foregroundColor(.primary)
                    +
                    Text(" \(messageText)")
                        .font(.custom("Outfit-Regular", size: 14))
                        .foregroundColor(Color(hex: "#949494"))
                )
                
                Text(notification.time)
                    .font(.custom("Outfit-Regular", size: 12))
                    .foregroundColor(Color(hex: "#9D9D9D"))
            }
            
            Spacer()
            
            switch notification.type {
            case .like(let imageURL):
                Image(imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .cornerRadius(6)
            case .followBackNeeded:
                Button(action: {
                    // Follow back logic
                }) {
                    Text("Follow back")
                        .font(.custom("Outfit-Medium", size: 12))
                        .foregroundColor(.white)
                        .frame(width: 103, height: 24)
                        .background(Color(hex: "#258694"))
                        .cornerRadius(6)
                }
            case .follow:
                EmptyView()
            }
        }
    }
    
    private var messageText: String {
        switch notification.type {
        case .like:
            return "liked your post."
        case .followBackNeeded, .follow:
            return "started following you."
        }
    }
}



#Preview {
    NotificationView()
}
