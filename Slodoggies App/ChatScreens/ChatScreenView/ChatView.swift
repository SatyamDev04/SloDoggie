//
//  ChatView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/07/25.
//
import SwiftUI

struct GroupChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var showMenu = false
    @State private var showDeletePopup = false
    @State private var showReportPopup = false
    @State private var isBlocked = false
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                HStack(spacing: 12) {
                    Image("ChatProfile")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Jane Cooper")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        HStack(spacing: 12) {
                            Image("OnlineDot")
                                .resizable()
                                .frame(width: 8, height: 8)
                                .clipShape(Circle())
                            Text("Active Now")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            showMenu.toggle()
                        }
                    }) {
                        Image("ThreeDots")
                            .scaledToFill()
                            .font(.title3)
                            .foregroundColor(.black)
                            .frame(width: 12, height: 16)
                    }
                }
                .padding()
                .background(Color.white)
                .shadow(color: .gray.opacity(0.1), radius: 1)
                
                Divider()
                
                // Chat list
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                ChatBubbleView(message: message, isCurrentUser: message.userId == viewModel.currentUserId)
                            }
                        }
                        .onChange(of: viewModel.messages.count) { _ in
                            withAnimation {
                                proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                
                Divider()
                
                // Input bar
                // INPUT OR UNBLOCK BUTTON
                if isBlocked {
                    Button(action: {
                        isBlocked = false
                    }) {
                        Text("Unblock ‘Jane’")
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.teal)
                            .cornerRadius(8)
                    }
                    .padding(.vertical, 12)
                } else {
                    HStack(spacing: 8) {
                        HStack {
                            Button(action: {
                                print("Attachment tapped")
                            }) {
                                Image("paperclip")
                                    .foregroundColor(.gray)
                            }
                            
                            TextField("Type something", text: $viewModel.newMessage)
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .frame(height: 50)
                        .background(Color(red: 0/255, green: 99/255, blue: 121/255, opacity: 0.1))
                        .cornerRadius(10)
                        
                        Button(action: {
                            viewModel.sendMessage()
                        }) {
                            Image("sendmsg")
                                .foregroundColor(.white)
                                .padding(2)
                                .frame(height: 50)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.white)
                }
            }
            
            // Popup menu
            .overlay(alignment: .topTrailing) {
                if showMenu {
                    VStack(alignment: .leading, spacing: 12) {
                        Button(action: {
                            showMenu = false
                            showDeletePopup = true // 3️⃣ Show popup when delete tapped
                        }) {
                            Label("Delete", image: "delete")
                                .foregroundColor(.black)
                        }
                        Button(action: {
                            print("Report tapped")
                            showMenu = false
                            showReportPopup = true
                        }) {
                            Label("Report User", image: "report")
                                .foregroundColor(.black)
                        }
                        Button(action: {
                            print("Block tapped")
                            showMenu = false
                            isBlocked = true}) {
                                Label("Block User", image: "block")
                                    .foregroundColor(.black)
                                
                            }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .frame(width: 160, alignment: .leading)
                    .position(x: UIScreen.main.bounds.width - 90, y: 120)
                }
            }
        }
        .overlay {
            if showDeletePopup {
                DeleteChatPopUpView(isPresented: $showDeletePopup)
                    .transition(.opacity)
                    .ignoresSafeArea()
            }
        }
        .overlay {
            if showReportPopup {
                ReportUserBottomSheetView(isPresented: $showReportPopup)
                    .transition(.opacity)
            }
        }
    }
}


#Preview {
    GroupChatView()
}

struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                GroupChatView()
            }
        }
    }
}
