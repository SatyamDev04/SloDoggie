//
//  DiscoverView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI

struct DiscoverView: View {
    @StateObject private var viewModel = DiscoverViewModel()
    
    var body: some View {
            VStack(alignment: .leading, spacing: 12) {
            
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
                
                // 🔵 Hashtag Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.hashtags, id: \.self) { tag in
                            Text(tag)
                                .font(.custom("Outfit-Regular", size: 11))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .frame(height: 30)
                                .foregroundColor(Color(hex: "#258694"))
                                .background(Color(red: 229/255, green: 239/255, blue: 242/255))
                                .cornerRadius(5)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // ⚪ Category Buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Button(action: {
                                viewModel.selectCategory(category)
                            }) {
                                Text(category)
                                    .font(.custom("Outfit-Regular", size: 14))
                                    .padding(.horizontal, 16)
                                    .frame(height: 42)
                                    .background(
                                        viewModel.selectedCategory == category ?
                                        Color(hex: "#258694") : Color.white
                                    )
                                    .foregroundColor(
                                        viewModel.selectedCategory == category ?
                                            .white : Color(hex: "#949494")
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(hex: "#949494"), lineWidth: 1)
                                    )
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // 👤 User / Pet Results
                ScrollView {
                    if viewModel.selectedCategory == "Events" {
                        VStack(spacing: 20) {
                            ForEach(viewModel.events) { event in
                                DiscoverEventCard(event: event)
                            }
                        }
                    } else if viewModel.selectedCategory == "Pet Places" {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                            ForEach(viewModel.petPlaces) { place in
                                PetPlaceCard(place: place)
                            }
                        }
                        .padding(.horizontal)
                        
                    } else if viewModel.selectedCategory == "Activities" {
                           VStack(spacing: 20) {
                               // 👉 Instead of simple text, show PetPostCardView
                               ForEach(0..<3, id: \.self) { _ in
                                   ActivitiesCardView()
                               }
                           }
                    } else {
                        VStack(spacing: 12) {
                            ForEach(viewModel.results) { user in
                                HStack {
                                    Image(user.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 38, height: 38)
                                        .clipShape(Circle())
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(user.name)
                                            .font(.custom("Outfit-Regular", size: 14))
                                        
                                        if viewModel.selectedCategory != "Pets Near You" {
                                            Text(user.role)
                                                .font(.custom("Outfit-Regular", size: 10))
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .foregroundColor(Color(hex: "#258694"))
                                                .background(Color(red: 229/255, green: 239/255, blue: 242/255))
                                                .cornerRadius(10)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        viewModel.removeItem(user)
                                    }) {
                                        Image("cancelBtnIcon")
                                            .foregroundColor(.black)
                                            .frame(width: 18, height: 18)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom)
                                .padding(.trailing, 10)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .padding(.top)
      }
    }

  #Preview {
      DiscoverView()
  }
