//
//  MessageBubbleView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 19/08/25.
//

import SwiftUI

struct MessageBubble: View {
    let message: GroupChatMessage
    
    var body: some View {
        HStack {
            if message.isCurrentUser {
                Spacer(minLength: 40) // push to right
                Text(message.message)
                    .padding(10)
                    .font(.custom("Outfit-Regular", size: 14))
                    .background(Color(hex: "#258694"))
                    .foregroundColor(.white)
                    .clipShape(GroupChatBubbleShape(isCurrentUser: true))
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    Image(message.profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Text(message.message)
                        .padding(10)
                        .font(.custom("Outfit-Regular", size: 14))
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .clipShape(GroupChatBubbleShape(isCurrentUser: false))
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

struct GroupChatBubbleShape: Shape {
    var isCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: isCurrentUser
                ? [.topLeft, .topRight, .bottomLeft]   // self messages (right side)
                : [.topLeft, .topRight, .bottomRight], // other messages (left side)
            cornerRadii: CGSize(width: 16, height: 16)
        )
        return Path(path.cgPath)
    }
}
