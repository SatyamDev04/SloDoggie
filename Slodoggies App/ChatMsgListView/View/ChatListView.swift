//
//  ChatListView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 11/08/25.
//

import SwiftUI

struct ChatListView: View {
    @StateObject private var viewModel = ChatListViewModel()
    
    var body: some View {
        HStack(spacing: 20){
            Button(action: {
                // coordinator.pop()
            }){
                Image("Back")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            Text("Messages")
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
        VStack{
            List(viewModel.chats) { chat in
                HStack(spacing: 12) {
                    // Profile Image
                    Image(chat.profileImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                    
                    // Name & Message
                    VStack(alignment: .leading, spacing: 4) {
                        Text(chat.name)
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(chat.message)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    // Time
                    Text(chat.time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
        }
        .listStyle(PlainListStyle())
    }
}

#Preview {
    ChatListView()
}
