//
//  CreateGroup&EventView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 29/07/25.
//

import SwiftUI

struct CreatePostScreen: View {
    @StateObject private var viewModel = CreatePostViewModel()
    
    var body: some View {
        VStack {
            // Toggle
            HStack(spacing: 10){
                Button(action: {
                    // coordinator.pop()
                }){
                    Image("Back")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text("New post")
                    .font(.custom("Outfit-Medium", size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: "#221B22"))
                    //.padding(.leading, 100)
            }
            .padding(.leading, -180)
            .frame(alignment: .leading)
            
            ScrollView {
            HStack(spacing: 0) {
                Button(action: { viewModel.selectedTab = .post }) {
                    Text("Post")
                        .foregroundColor(viewModel.selectedTab == .post ? .white : .black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.selectedTab == .post ? Color(Color(hex: "#258694")) : Color.white)
                        .cornerRadius(6)
                }
                Button(action: { viewModel.selectedTab = .event }) {
                    Text("Event")
                        .foregroundColor(viewModel.selectedTab == .event ? .white : .black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.selectedTab == .event ? Color(hex: "#258694") : Color.white)
                        .cornerRadius(6)
                }
            }
           // .padding()
            .frame(height: 24)
            .padding(.horizontal)
       
                if viewModel.selectedTab == .post {
                    PostFormView()
                } else {
                    EventFormView()
                }
            }
            .padding(.top)
        }
        //.padding(.top)
      }
    }


  #Preview {
      CreatePostScreen()
  }
