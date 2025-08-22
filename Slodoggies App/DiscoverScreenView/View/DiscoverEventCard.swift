//
//  DiscoverEventModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI

struct DiscoverEventCard: View {
    let event: DiscoverEventModel
    let images = ["Post1", "Post1", "Post1"] // Your image asset names
    @State private var currentIndex = 0
    @State private var isLiked = false
    @State private var likeCount = 200
    @State private var isBookmarked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // MARK: - Profile Row
            HStack {
                Image("Lady") // Profile picture
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Lydia Vaccaro")
                        .font(.custom("Outfit-Medium", size: 14))
                    Text("5 Min.")
                        .font(.custom("Outfit-Regular", size: 12))
                        .foregroundColor(.gray)
                }
                
//                Spacer()
                
                Button(action: {}) {
                    Text("Following")
                        .font(.custom("Outfit-Regular", size: 12))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .foregroundColor(Color(hex: "#258694"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(hex: "#258694"), lineWidth: 1)
                        )
                }

            }
            .padding(10)
            
            VStack(alignment: .leading,spacing: 6){
                HStack{
                    Text("Event Title")
                        .font(.custom("Outfit-Medium", size: 14))
                    Spacer()
                    Label("May 25, 4:00 PM", image: "CalenderIcon")
                        .font(.custom("Outfit-Regular", size: 14))
                }
                HStack{
                    Text("Lorem ipsum dolor sit amet…")
                        .font(.custom("Outfit-Regular", size: 13))
                        .foregroundColor(Color(hex: "#949494"))
                    Spacer()
                    Label("30 Mins.", image: "ClockIcon")
                        .font(.custom("Outfit-Regular", size: 14))
                }
                
                Label("San Luis Obispo County", image: "LocationPin")
                    .font(.custom("Outfit-Regular", size: 13))
            }
            .padding(.horizontal)
           
            
            ZStack(alignment: .bottom) {
                TabView(selection: $currentIndex) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(images[index])
                            .resizable()
                            .scaledToFill()
                            .clipped()
//                            .cornerRadius(10)
                            .tag(index)
                    }
                }
                .frame(height: 350)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                HStack(spacing: 6) {
                    ForEach(0..<images.count, id: \.self) { index in
                        if currentIndex == index {
                            Rectangle()
                                .fill(Color(hex: "#258694"))
                                .frame(width: 20, height: 6)
                                .cornerRadius(3)
                        } else {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 6, height: 6)
                        }
                    }
                }
                .padding(.bottom, 60)
                ZStack(alignment: .trailing) {
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: 50)

                    HStack(spacing: 8) {
                        Text("Join Community")
                            .font(.custom("Outfit-Medium", size: 16))
                            .foregroundColor(.white)

                        Image("joinCommunity") // Profile picture
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 28, height: 28)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 12)
                }
//                    .frame(width: 20, height: 6)
            }
//                    .frame(width: 20, height: 6)
        
//            // MARK: - Image with Overlay Button
//            ZStack(alignment: .bottom) {
//                TabView(selection: $currentIndex) {
//                    ForEach(0..<images.count, id: \.self) { index in
//                        Image(images[index])
//                            .resizable()
//                            .scaledToFill()
//                            .frame(height: 300)
//                            .clipped()
//                            .tag(index)
//                    }
//                }
//                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                .cornerRadius(10)
//                .padding(.horizontal)
//
//                Button(action: {}) {
//                    Text("Join Community")
//                        .font(.custom("Outfit-Medium", size: 14))
//                        .foregroundColor(.white)
//                        .padding(.vertical, 8)
//                        .padding(.horizontal, 20)
//                        .background(Color.black.opacity(0.8))
//                        .clipShape(Capsule())
//                }
//                .padding(.bottom, 16)
//            }
//
            // MARK: - Action Bar
            HStack(spacing: 10) {
                Button(action: {
                    isLiked.toggle()
                    likeCount += isLiked ? 1 : -1
                }) {
                    Label("\(likeCount)", image: isLiked ? "PawLiked" : "PawUnliked")
                }
                
                Button(action: {
                    print("Share tapped")
                }) {
                    Label("10", image: "Share")
                }
                
                Spacer()
                
                Button(action: {
                    isBookmarked.toggle()
                }) {
                    Image(isBookmarked ? "BookMarkTapped" : "bookmarkUntap")
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            .font(.custom("Outfit-Regular", size: 14))
            .foregroundColor(.black)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 4)
        .padding(.horizontal)
    }
}
#Preview {
    DiscoverEventCard(event: DiscoverEventModel(title: "Event Title", time: "May 25, 4:00 PM", duration: "30 Mins.", location: "San Luis Obispo County", image: "event_dog", likes: 200, shares: 10))
}
