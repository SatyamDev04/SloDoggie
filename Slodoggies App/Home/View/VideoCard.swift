//
//  VideoCard.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import SwiftUI

struct VideoCard: View {
    let video: VideoModel
    let images = ["Post1", "Post1", "Post1"] // Your image asset names
    @State private var currentIndex = 0
    @State private var isLiked = false
    @State private var likeCount = 120
    @State private var isBookmarked = false
    @State private var readMoreTapped = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // MARK: - Top Bar
            HStack(alignment: .top) {
                // Profile image
                ZStack {
                   Image("Lady")
                       .resizable()
                       .aspectRatio(contentMode: .fill)
                       .frame(width: 50, height: 50)
                       .clipShape(Circle())

                   Image("Dog")
                       .resizable()
                       .aspectRatio(contentMode: .fill)
                       .frame(width: 50, height: 50)
                       .clipShape(Circle())
                       .overlay(Circle().stroke(Color.white, lineWidth: 2))
                       .offset(x: 25,y: 10)
               }
               .frame(width: 50, height: 50)
                
                Spacer()
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Lydia Vaccaro")
                            .font(.custom("Outfit-Medium", size: 12))
                        Text("with")
                            .font(.custom("Outfit-Medium", size: 12))
                        Text("Wixx")
                            .font(.custom("Outfit-Medium", size: 12))
                    }
                    .font(.subheadline)

                    HStack(spacing: 6) {
                        Text("Pet Mom")
                            .font(.custom("Outfit-Medium", size: 8))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.teal.opacity(0.2))
                            .foregroundColor(.teal)
                            .cornerRadius(6)

                        Text("5 Min.")
                            .font(.custom("Outfit-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                }

                Button("Follow") {
                }
                .font(.custom("Outfit-Regular", size: 12))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(hex: "#258694"))
                .foregroundColor(.white)
                .cornerRadius(6)

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
                Text("🐶 Say hello to Jimmi! Three years of cuddles, chaos, and unconditional love. Here’s to more adventures with my favorite fur companion! 🐾 #JimmiTheDog #LifeWithPets #SloDoggiesLove #PetParentGoals #DogVibesOnly")
                    .font(.custom("Outfit-Regular", size: 13))
                    .lineLimit(readMoreTapped ? nil : 2) 

                   if !readMoreTapped {
                       Button("Read More") {
                           readMoreTapped = true
                       }
                       .font(.custom("Outfit-Regular", size: 13))
                       .foregroundColor(Color(hex: "#258694"))
                   }
            }
            .padding(.horizontal, 10)

            ZStack(alignment: .bottom) {
                TabView(selection: $currentIndex) {
                    ForEach(0..<images.count, id: \.self) { index in
                        ZStack {
                            Image(images[index])
                                .resizable()
                                .scaledToFill()
                                .frame(height: 350)
                                .clipped()

                            // Center Play Button
                            Image("PlayButton")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .shadow(radius: 4)
                        }
                        .tag(index)
                    }
                }
                .frame(height: 350)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                // Video progress bar (dummy progress)
                Rectangle()
                    .fill(Color.white.opacity(0.7))
                    .frame(height: 4)
                    .overlay(
                        GeometryReader { geometry in
                            // Dummy progress value, you can replace with actual video progress
                            let progress: CGFloat = 0.4
                            Rectangle()
                                .fill(Color(hex: "#258694"))
                                .frame(width: geometry.size.width * progress)
                        }
                    )
            
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
                .padding(.bottom, 10)
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
    VideoCard(video: VideoModel(title: "Say hello to Jimmi!", description: "Three years of cuddles...", tags: ["#LifeWithPets", "#SloDoggiesLove"], thumbnail: "video_dog", likes: 200, comments: 100, shares: 15))
}
