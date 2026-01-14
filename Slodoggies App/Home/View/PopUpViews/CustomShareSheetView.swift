//
//  CustomShareSheetView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 09/10/25.
//

import SwiftUI

struct ShareUser: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let image: String

    // Use identity (id) for equality & hashing:
    static func == (lhs: ShareUser, rhs: ShareUser) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct CustomShareSheetView: View {
    @Binding var isPresented: Bool
    
    let users: [ShareUser] = [
        ShareUser(name: "Jack", image: "user1"),
        ShareUser(name: "Simmi", image: "user3"),
        ShareUser(name: "Rossy", image: "user5"),
        ShareUser(name: "Tommy", image: "user6"),
        ShareUser(name: "Jack", image: "user1"),
        ShareUser(name: "Simmi", image: "user3"),
        ShareUser(name: "Rossy", image: "user5"),
        ShareUser(name: "Tommy", image: "user6")
    ]
    @State private var selectedUsers: Set<ShareUser> = []
    var onCancel: (() -> Void)
    
    let shareApps: [(name: String, icon: String)] = [
        ("Copy url", "copyIcon"),
        ("WhatsApp", "whatsupIcon"),
        ("Instagram", "instaIcon"),
        ("Telegram", "telegramIcon"),
        ("Facebook", "facebookIcon"),
        ("X", "twiterIcon"),
        ("Messages", "messageIcon"),
        ("More", "moreIcon")
    ]
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { onCancel() }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        onCancel()
                    }) {
                        Image("crossIcon")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.blue)
                    }
                    .padding(.trailing, 20)
                }
                
                VStack(spacing: 16) {
                    HStack{
                        Text("Share with friends!")
                            .font(.headline)
                            .padding(.top)
                        Spacer()
                    }
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color(hex: "#258694"))
                    
                    // Top users grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                        ForEach(users) { user in
                            VStack(spacing: 6) {
                                ZStack(alignment: .topTrailing) {
                                    Image(user.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(selectedUsers.contains(user) ? Color.teal : Color.clear, lineWidth: 2)
                                        )
                                    
                                    if selectedUsers.contains(user) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.teal)
                                            .offset(x: 5, y: -5)
                                    }
                                }
                                
                                Text(user.name)
                                    .font(.caption)
                            }
                            .onTapGesture {
                                if selectedUsers.contains(user) {
                                    selectedUsers.remove(user)
                                } else {
                                    selectedUsers.insert(user)
                                }
                            }
                        }
                    }
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color(hex: "#258694"))
                    
                    // Share apps grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                        ForEach(shareApps, id: \.name) { app in
                            VStack(spacing: 8) {
                                Image(app.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding(10)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(Circle())
                                
                                Text(app.name)
                                    .font(.caption)
                            }
                        }
                    }
                    
                    Button(action: {
                        onCancel()
                        isPresented = false
                        print("Send tapped, selected users: \(selectedUsers)")
                    }) {
                        Text("Send")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 28)
                            .padding()
                            .background(Color(hex: "#258694"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 10)
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 8)
                .padding(10)
            }
        }
        .padding(.bottom, -20)
    }
}

#Preview {
    CustomShareSheetView(isPresented: .constant(true), onCancel: {})
}
