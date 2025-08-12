//
//  ChatBubbleView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/07/25.
//

import SwiftUI
import SwiftUICore

struct ChatBubbleView: View {
    let message: ChatMessage
    let isCurrentUser: Bool
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isCurrentUser {
                Spacer() // Push current user's message to right
            }
            
            if !isCurrentUser {
                Image(message.avatar)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            
            if message.isCard {
                VStack(alignment: .leading, spacing: 10) {
                    HStack{
                        Image(message.avatar)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        
                        Text(message.cardTitle)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    
                        Text(message.cardSubtitle)
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.8))
                    
                    Image("Frame 5")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 220, height: 200)
                        .clipped()
                        .cornerRadius(8)
                }
                .padding(8)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "#258694"), lineWidth: 8)
                )
                .frame(maxWidth: 240, alignment: .leading)
            } else {
                Text(message.message)
                    .padding(12)
                    .background(isCurrentUser ? Color(hex: "#258694") : Color(red: 0/255, green: 99/255, blue: 121/255, opacity: 0.1))
                    .foregroundColor(isCurrentUser ? .white : .black)
                    .clipShape(ChatBubbleShape(isCurrentUser: isCurrentUser))
                    .frame(maxWidth: 240, alignment: isCurrentUser ? .trailing : .leading)
            }
            
            if !isCurrentUser {
                Spacer() // Push other user's message to left
            }
         }
        .padding(.horizontal)
     }
   }

struct ChatBubbleShape: Shape {
    var isCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let corners: UIRectCorner = isCurrentUser
            ? [.topLeft, .topRight, .bottomLeft] // sender (you)
            : [.topLeft, .topRight, .bottomRight] // receiver
        
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: 16, height: 16)
        )
        return Path(path.cgPath)
     }
  }
