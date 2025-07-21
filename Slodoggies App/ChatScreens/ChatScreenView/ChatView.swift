//
//  ChatView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/07/25.
//
import SwiftUI

struct GroupChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                }
                Text("Event Community 1")
                    .font(.headline)
                Spacer()
                Label("20", systemImage: "person.3.fill")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                }
            }
            .padding()
            .background(Color.white)
            .shadow(color: .gray.opacity(0.1), radius: 1)

            Divider()

            // Chat List
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.messages) { message in
                            ChatBubbleView(message: message, isCurrentUser: message.userId == viewModel.currentUserId)
                        }
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        withAnimation {
                            proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                        }
                    }
                    .padding(.top)
                }
            }

            Divider()

            // Input Field
            HStack {
                TextField("Type something", text: $viewModel.newMessage)
                    .padding(12)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Capsule())

                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .rotationEffect(.degrees(45))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.teal)
                        .clipShape(Circle())
                }
            }
            .padding()
            .background(Color.white)
        }
        .background(Color.white.edgesIgnoringSafeArea(.bottom))
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
