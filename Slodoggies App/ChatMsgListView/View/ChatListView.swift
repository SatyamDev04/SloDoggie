//
//  ChatListView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 11/08/25.
//

import SwiftUI

struct ChatListView: View {
    @StateObject private var viewModel = ChatListViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        HStack(spacing: 20){
            Button(action: {
                 coordinator.pop()
            }){
                Image("Back")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            Text("Messages")
                .font(.custom("Outfit-Medium", size: 20))
                .foregroundColor(Color(hex: " #221B22"))
                 Spacer()
        }
        
            //.padding()
            .padding(.horizontal, 20)
        //.padding(.bottom,2)
        
        Divider()
            .frame(height: 2)
            .background(Color(hex: "#258694"))
        
        HStack {
            Image("Search")
                .foregroundColor(.gray)
            TextField("Search", text: $viewModel.query)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding()
        .frame(height: 42)
        .background(Color(hex: "#F4F4F4"))
        .cornerRadius(10)
        .padding(.horizontal)
        
        ZStack(alignment: .bottomTrailing) {
            VStack {
                List(viewModel.filteredChats) { chat in
                    Button(action: {
                        coordinator.push(.chatView)
                    }) {
                        VStack(spacing: 0) { // whole row is tappable
                            HStack(spacing: 12) {
                                Image(chat.profileImageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 48, height: 48)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(chat.name)
                                        .font(.custom("Outfit-Regular", size: 16))
                                        .foregroundColor(.black)
                                    Text(chat.message)
                                        .font(.custom("Outfit-Regular", size: 12))
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 6) {
                                    Text(chat.time)
                                        .font(.custom("Outfit-Regular", size: 12))
                                        .foregroundColor(Color(hex: "#9C9C9C"))
                                    
                                    if chat.unreadCount > 0 {
                                        Text("\(chat.unreadCount)")
                                            .font(.custom("Outfit-Regular", size: 10))
                                            .foregroundColor(.white)
                                            .padding(6)
                                            .background(Color(hex: "#258694"))
                                            .clipShape(Circle())
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            .contentShape(Rectangle()) // expands tap area to full HStack
                            
                            Divider()
                                .padding(.horizontal, 2)
                        }
                    }
                    .buttonStyle(PlainButtonStyle()) // removes blue highlight
                    .listRowSeparator(.hidden) // hide default list separator
                }
            }
            .listStyle(PlainListStyle())
            
            // MARK: - Floating Plus Button
            HStack {
                Spacer() // Push button to the right side
                Button(action: {
                     coordinator.push(.newChatListView)
                }) {
                    Image("newChat")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .shadow(color: .gray.opacity(0.4), radius: 6, x: 0, y: 4)
                }
            }
            .padding(.trailing, 24)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview {
    ChatListView()
}
