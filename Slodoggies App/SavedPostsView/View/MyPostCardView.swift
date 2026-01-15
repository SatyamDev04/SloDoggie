//
//  MyPostCardView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 30/12/25.
//


import SwiftUI
import AVKit

struct MyPostCardView: View {
    
    // MARK: - Input
    let item: MyPostItem
  
    let index: Int
    @Binding var isMenuVisible: Bool
    var onCommentTap: () -> Void = {}
    var onReportTap: () -> Void = {}
    var onShareTap: () -> Void = {}
    var onReportPostTap: () -> Void = {}
    var onFollowTap: () -> Void = {}
    var onSaveTap: () -> Void = {}
    
    var onEditTap: () -> Void = {}
    var onDeleteTap: () -> Void = {}
    
    @EnvironmentObject private var tabRouter: TabRouter
    
    let onLikeTap: (_ isCurrentlyLiked: Bool) -> Void
    
    // MARK: - State
    @State private var currentIndex = 0
    @State private var isLiked = false
    @State private var isBookmarked = false
    
    @State private var playingIndex: Int? = nil
    @State private var players: [Int: AVPlayer] = [:]
    
    @EnvironmentObject private var coordinator: Coordinator
    
    // MARK: - Media
    private var mediaItems: [GetPostMedia] {
        item.getPostMedia ?? []
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // MARK: - Top Bar
            HStack(alignment: .top) {
                
                Button {
                    coordinator.push(.profileDetailsView("\(item.userID ?? 0)",item.getPetDetail?.pet_name ?? ""))
                } label: {
                    ZStack(alignment: .bottomTrailing) {
                        
                        // 👤 USER IMAGE (MAIN)
                        if let userImage = item.getUserDetail?.image,
                           !userImage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            
                            Image.loadImage(
                                userImage,
                                width: 40,
                                height: 40,
                                cornerRadius: 20,
                                contentMode: .fill
                            )
                            .clipShape(Circle())
                            
                        } else {
                            Image("NoUserFound")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .offset(x: 15, y: 15)
                        }
                            
                        
                        // 🐶 PET IMAGE (OVERLAY – SAME SIZE AS YOUR DESIGN)
                        if let petImage = item.getPetDetail?.pet_image,
                           !petImage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            
                            Image.loadImage(
                                petImage,
                                width: 40,
                                height: 40,
                                cornerRadius: 20,
                                contentMode: .fill
                            )
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2)
                            )
                            .offset(x: 25, y: 10)
                            
                        } else {
                            Image("NoUserFound")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 2)
                                )
                                .offset(x: 15, y: 15)
                        }
                    }
                    .frame(width: 50, height: 50)
                    
                }
                .buttonStyle(.plain)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.getUserDetail?.name ?? "")
                        .font(.custom("Outfit-Medium", size: 12))
                        .foregroundColor(.black)
                    
                    Text(item.createdAt ?? "")
                        .font(.custom("Outfit-Regular", size: 12))
                        .foregroundColor(.gray)
                   
                }
                .padding(.horizontal)
                  
                Spacer()
                
                Button {
                        withAnimation { isMenuVisible.toggle() }
                    
                } label: {
                    Image("ThreeDots")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.top, 20)
                }
            }
            .padding(.horizontal, 10)
            
            
            VStack(alignment: .leading,spacing: 10) {
                Text(item.postTitle ?? "")
                    .font(.custom("Outfit-Regular", size: 14))
                    .foregroundColor(.black)

                Text(item.address ?? "")
                    .font(.custom("Outfit-Regular", size: 14))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 20)
            .padding(.top, 5)

            
            // MARK: - Media Slider
            if !mediaItems.isEmpty {
                ZStack(alignment: .bottom) {
                    TabView(selection: $currentIndex) {
                        ForEach(mediaItems.indices, id: \.self) { index in
                            
                            let media = mediaItems[index]
                            let mediaURL = media.mediaPath ?? ""
                            
                            ZStack {
                                // 🎥 VIDEO
                                if media.mediaType == "video",
                                   let url = URL(string: mediaURL) {
                                    
                                    if playingIndex == index,
                                       let player = players[index] {
                                        VideoPlayer(player: player)
                                            .onAppear { player.play() }
                                    } else {
                                        Color.black.opacity(0.3)
                                        
                                        Image(systemName: "play.circle.fill")
                                            .resizable()
                                            .frame(width: 64, height: 64)
                                            .foregroundColor(.white)
                                    }
                                    
                                }
                                //  IMAGE
                                else {
                                    Image.loadImage(
                                        mediaURL,
                                        width: UIScreen.main.bounds.width,
                                        height: 320,
                                        cornerRadius: 0,
                                        contentMode: .fill
                                    )
                                }
                            }
                            .frame(height: 320)
                            .clipped()
                            .onTapGesture {
                                guard media.mediaType == "video",
                                      let url = URL(string: mediaURL) else { return }
                                
                                let player = AVPlayer(url: url)
                                players[index] = player
                                playingIndex = index
                                observeVideoEnd(player: player, index: index)
                            }
                            .tag(index)
                        }
                    }
                    .frame(height: 320)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            
            
            // MARK: - Actions
            HStack(spacing: 12) {
                
                Button {
                    onLikeTap(item.itemSuccess?.isLiked ?? false)
                } label: {
                    Label(
                        "\(item.getPostLikeCount ?? 0)",
                        image: (item.itemSuccess?.isLiked ?? false) ? "PawLiked" : "PawUnliked"
                    )
                }
                
                Button(action: onCommentTap) {
                    Label("\(item.getPostCommentCount ?? 0)", image: "Comment")
                }
                
                Button(action: onShareTap) {
                    Label("\(item.getPostShareCount ?? 0)", image: "Share")
                }
                
                Spacer()
                
                Button(action: onSaveTap) {
                    HStack(spacing: 6) {
                        Text("Save")
                            .foregroundColor(
                                (item.itemSuccess?.isSaved ?? false)
                                ? Color(hex: "#258694")
                                : .black
                            )
                        
                        Image(
                            (item.itemSuccess?.isSaved ?? false)
                            ? "savedfillicon"
                            : "savedIcon"
                        )
                        .resizable()
                        .frame(width: 25, height: 25)
                    }
                }
            }
            .padding(10)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.1), radius: 6)
        .padding(.horizontal)
        // MARK: - Menu Overlay
        .overlay(alignment: .topTrailing) {
            if isMenuVisible {
                menuOverlay
                
                
            }
        }
        
        .onTapGesture {
            isMenuVisible = false
        }
        
        .onAppear {
            isLiked = item.itemSuccess?.isLiked ?? false
            isBookmarked = item.itemSuccess?.isSaved ?? false
        }
        
    }
    
    // MARK: - Menu Overlay

    private var menuOverlay: some View {
        VStack(spacing: 0) {

            Button {
                isMenuVisible = false
                onEditTap()
            } label: {
                HStack(spacing: 12) {
                    Image("PencilIcons")
                        .resizable()
                        .frame(width: 20, height: 20)

                    Text("Edit")
                        .font(.custom("Outfit-Regular", size: 16))

                    Spacer()
                }
                .frame(maxWidth: .infinity, minHeight: 44)
                .contentShape(Rectangle())   // 🔥 full tap area
                .padding(.horizontal, 12)
            }

            Divider()

            Button {
                isMenuVisible = false
                onDeleteTap()
            } label: {
                HStack(spacing: 12) {
                    Image("deleteIcon")
                        .resizable()
                        .frame(width: 20, height: 20)

                    Text("Delete")
                        .font(.custom("Outfit-Regular", size: 16))
                        .foregroundColor(.red)

                    Spacer()
                }
                .frame(maxWidth: .infinity, minHeight: 44)
                .contentShape(Rectangle())   // 🔥 full tap area
                .padding(.horizontal, 12)
                               
            }
        }
        .frame(width: 140)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.trailing, 16)
        .position(
            x: UIScreen.main.bounds.width - 100,
            y: 100
        )
    }

    // MARK: - Helpers
    private func isVideoURL(_ url: String) -> Bool {
        ["mp4", "mov", "m4v"].contains { url.lowercased().hasSuffix($0) }
    }
    
    private func observeVideoEnd(player: AVPlayer, index: Int) {
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            players[index]?.seek(to: .zero)
            players.removeValue(forKey: index)
            playingIndex = nil
        }
    }
}
