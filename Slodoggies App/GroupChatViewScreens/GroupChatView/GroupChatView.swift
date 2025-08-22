//
//  GroupChatView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 19/08/25.
//

import SwiftUI

struct GroupChatView: View {
    @StateObject private var viewModel = GroupChatViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @State private var showMenu = false
    
    var body: some View {
        VStack {
            // Header
            HStack(spacing: 12) {
                Button(action: {
                     coordinator.pop()
                }){
                    Image("Back")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Image("memberimage")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Event Community 1")
                        .font(.custom("Outfit-Regular", size: 15))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 12) {
                        Image("membericon")
                            .resizable()
                            .frame(width: 16, height: 16)
                            
                        Text("20 Members")
                            .font(.custom("Outfit-Regular", size: 12))
                            .foregroundColor(.black)
                            .padding(.leading, -6)
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
            

            
            // Messages
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.messages) { message in
                        MessageBubble(message: message)
                    }
                }
            }
            
            // Input Field
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
        .background(Color.white.ignoresSafeArea())
        // Popup menu
        .overlay(alignment: .topTrailing) {
            if showMenu {
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: {
                        showMenu = false
                        coordinator.push(.EventParticipants)
                    }) {
                        Text("View Profile")
                            .foregroundColor(.black)
                    }
                 
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                .frame(width: 160, alignment: .leading)
                .position(x: UIScreen.main.bounds.width - 50, y: 80)
            }
        }
     }
   }


 #Preview {
     GroupChatView()
 }

