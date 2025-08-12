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
        HStack(spacing: 20){
            Button(action: {
                 coordinator.pop()
            }){
                Image("Back")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            Text("Notifications")
                .font(.custom("Outfit-Medium", size: 20))
                .fontWeight(.medium)
                .foregroundColor(Color(hex: " #221B22"))
            //.padding(.leading, 100)
        }
        
            .padding()
            .padding(.leading, -180)
            .padding(.horizontal,25)
        //.padding(.bottom,2)
        
        Divider()
            .frame(height: 2)
            .background(Color(hex: "#656565"))
        
        List {
            Section(header: Text("Today").font(.headline)) {
                ForEach(viewModel.notificationsToday) { notification in
                    NotificationRowView(notification: notification)
                        .padding(.vertical, 4)
                }
            }
        }
        .listStyle(.plain)
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
                HStack {
                    Text(notification.username)
                        .font(.custom("Outfit-Medium", size: 14))
                        .foregroundColor(.primary) +
                    Text(" \(messageText)")
                        .font(.custom("Outfit-Regular", size: 14))
                        .foregroundColor(Color(hex: "#949494"))
                }
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
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
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
