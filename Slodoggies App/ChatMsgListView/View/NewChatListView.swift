//
//  NewChatListView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 27/10/25.
//

import SwiftUI

struct NewChatListView: View {
    @StateObject private var viewModel = NewChatListViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            HStack(spacing: 20) {
                Button(action: {
                    coordinator.pop()
                }) {
                    Image("Back")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
                Text("New Message")
                    .font(.custom("Outfit-Medium", size: 20))
                    .foregroundColor(Color(hex: "#221B22"))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            
            Divider()
                .frame(height: 2)
                .background(Color(hex: "#258694"))
                .padding(.bottom, 8)
            
            // MARK: - Search Bar
            HStack(spacing: 10) {
                Image("Search")
                    .resizable()
                    .frame(width: 18, height: 18)
                
                TextField("Search", text: $viewModel.searchText)
                    .font(.custom("Outfit-Regular", size: 14))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 12)
            .frame(height: 42)
            .background(Color(hex: "#F4F4F4"))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            // MARK: - Chat List
            List {
                ForEach(viewModel.filteredUsers) { user in
                    HStack(spacing: 12) {
                        Image(user.profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 42, height: 42)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(user.name)
                                    .font(.custom("Outfit-Medium", size: 15))
                                    .foregroundColor(Color(hex: "#221B22"))
                                
                                if user.isVerified {
                                    Image("BlueTickIcon")
                                        .resizable()
                                        .frame(width: 14, height: 14)
                                }
                            }
                        }
                        Spacer()
                        
                        // Arrow button should not navigate to chat
                        Button(action: {
                            print("Arrow tapped") // Do nothing or open menu if needed
                        }) {
                            
                        }
                        .buttonStyle(BorderlessButtonStyle()) // Prevents triggering parent tap
                    }
                    .padding(.vertical, 6)
                    .contentShape(Rectangle()) // Make whole row tappable
                    .onTapGesture {
                        // Only triggers when tapping outside the arrow
                        coordinator.push(.chatView)
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NewChatListView()
        .environmentObject(Coordinator())
}
