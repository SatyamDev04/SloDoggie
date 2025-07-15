//
//  AdCard.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import SwiftUI

struct AdCard: View {
    let ad: AdModel
    let images = ["Post1", "Post1", "Post1"] // Your image asset names
    @State private var currentIndex = 0
    @State private var isLiked = false
    @State private var likeCount = 120
    @State private var isBookmarked = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // MARK: - Top Bar
            HStack(alignment: .top) {
                // Profile image
                Image("Lady") // Your human image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                   
                    Text("Nobisuke")
                        .font(.custom("Outfit-Medium", size: 12))
                    Text("5 Min.")
                        .font(.custom("Outfit-Regular", size: 12))
                        .foregroundColor(.gray)
                   
                    
                }
                .padding(5)
                
                Spacer()
                
                Button(action: {
                   
                }) {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.gray)
                }
                .padding(.top)

            }
            .padding(10)
            // MARK: - Text Content
            VStack(alignment: .leading, spacing: 4) {
                Text(ad.title)
                    .font(.custom("Outfit-Bold", size: 13))
                    .lineLimit(2)
                Text(ad.subtitle)
                    .font(.custom("Outfit-Regular", size: 13))
                    .lineLimit(2)
               
            }
            .padding(.horizontal, 10)

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
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(hex: "#258694"))
                        .frame(height: 50)

                    Text("Sponsored")
                        .font(.custom("Outfit-Medium", size: 16))
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                }
//                    .frame(width: 20, height: 6)
            }

            
            HStack(spacing: 10) {
                Button(action: {
                    isLiked.toggle()
                    likeCount += isLiked ? 1 : -1
                }) {
                    Label("\(likeCount)", image: isLiked ? "PawLiked" : "PawUnliked")
                }

                Button(action: {
                    print("Comment tapped")
                }) {
                    Label("20", image: "Comment")
                }
                Button(action: {
                    print("Share tapped")
                }) {
                    Label("10", image: "Share")
                }

                Spacer()

                Button(action: {
                    isBookmarked.toggle()
                    print("Export tapped")
                }) {
                    Image(isBookmarked ? "BookMarkTapped" : "bookmarkUntap")
                }
            }
            .padding(10)
            .font(.custom("Outfit-Regular", size: 14))
            .foregroundColor(Color.black)
            .font(.subheadline)

        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 4)
        .padding(.horizontal)
    }
}
#Preview {
    AdCard(ad: AdModel(image: "dog_ad", title: "Summer Special: 20% Off Grooming!", subtitle: "Limited Time Offer", likes: 200, comments: 100, shares: 10))
}
