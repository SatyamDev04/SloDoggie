//
//  PostCard.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import SwiftUI
import AVKit

struct PetPostCardView: View {

    // MARK: - Input
    var item: HomeItem
    @Binding var isMenuVisible: Bool

    var onCommentTap: () -> Void = {}
    var onReportTap: () -> Void = {}
    var onShareTap: () -> Void = {}
    var onReportPostTap: () -> Void = {}

    // MARK: - State
    @State private var currentIndex = 0
    @State private var isLiked = false
    @State private var isBookmarked = false
    @State private var isExpanded = false
   // @State private var isFollowing = false
    
    @Binding var showSavedPopup: Bool
    
    var onFollowTap: () -> Void = {}
    
    let onLikeTap: (_ isCurrentlyLiked: Bool) -> Void
    
    var onSaveTap: () -> Void = {}
    
    @State private var playingIndex: Int? = nil
    @State private var players: [Int: AVPlayer] = [:]

    @EnvironmentObject private var coordinator: Coordinator

    // MARK: - Derived API Data
    private var mediaItems: [HPostMedia] {
        item.postMedia ?? []
    }

    private var likeCount: Int {
        intValue(item.engagement?.likes)
    }

    private var commentCount: Int {
        intValue(item.engagement?.comments)
    }

    private var shareCount: Int {
        intValue(item.engagement?.shares)
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // MARK: - Top Bar
            HStack(alignment: .top) {
                
                // Profile Images
                ZStack {
                    // 👤 USER IMAGE (MAIN)
                    Group {
                        if let userImage = item.media?.parentImageURL,
                           !userImage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            
                            Image.loadImage(
                                userImage,
                                width: 40,
                                height: 40,
                                cornerRadius: 20,
                                contentMode: .fill
                            )
                           // .clipShape(Circle())
                            
                        } else {
                            Image("NoUserFound")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                    }
                    .onTapGesture {
                        if item.author?.authorType == .owner{
                            coordinator.push(.profileDetailsView(item.userID ?? "",item.author?.petName ?? ""))
                        }else{
                            coordinator.push(.busiProfileView("Home", item.userID ?? "", hideSponsoredButton: true))
                        }
                    }
                    Group{
                        if item.author?.petName != ""{
                            // 🐶 PET IMAGE (OVERLAY – SAME SIZE AS YOUR DESIGN)
                            
                            if let petImage = item.media?.petImageURL,
                               !petImage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                
                                Image.loadImage(
                                    petImage,
                                    width: 40,
                                    height: 40,
                                    cornerRadius: 20,
                                    contentMode: .fill
                                )
                                //.clipShape(Circle())
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
                    }
                    .onTapGesture {
                        coordinator.push(.profileDetailsView(item.userID ?? "",item.author?.petName ?? ""))
                    }
                }
                .frame(width: 50, height: 50)

               // Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(item.author?.name ?? "")
                            .font(.custom("Outfit-Medium", size: 12))
                        
                        if item.author?.petName != ""{
                            Text("with")
                                .font(.custom("Outfit-Medium", size: 12))
                            Text(item.author?.petName ?? "")
                                .font(.custom("Outfit-Medium", size: 12))
                        }
                    }
                    
                    HStack(spacing: 6) {
                        if let badge = item.author?.badge {
                            Text(badge.rawValue)
                                .font(.custom("Outfit-Medium", size: 8))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.teal.opacity(0.2))
                                .cornerRadius(6)
                        }
                        
                        Text(item.author?.time ?? "")
                            .font(.custom("Outfit-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                if ((item.userID ?? "") != UserDetail.shared.getUserId()) {
                    Button {
                        onFollowTap()
                    } label: {
                        Text((item.itemsuccess?.iAmFollowing ?? false) ? "Following" : "Follow")
                            .font(.custom("Outfit-Regular", size: 12))
                            .frame(width: 70, height: 26)
                            .background((item.itemsuccess?.iAmFollowing ?? false) ? Color.clear : Color(hex: "#258694"))
                            .foregroundColor((item.itemsuccess?.iAmFollowing ?? false) ? Color(hex: "#258694") : .white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color(hex: "#258694"), lineWidth: 1)
                            )
                    }
                    .cornerRadius(6)
                }
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
            .padding(10)

            // MARK: - Post Text
            if let description = item.content?.title {
                VStack(alignment: .leading, spacing: 4) {
                    Text(description)
                        .font(.custom("Outfit-Regular", size: 13))
                        .lineLimit(isExpanded ? nil : 2)

                    Text(item.content?.hashtags ?? "")
                        .font(.custom("Outfit-Regular", size: 13))
                        .foregroundColor(Color(hex: "#258694"))
                }
                .padding(.horizontal, 10)
            }

            // MARK: - Media Slider
            if !mediaItems.isEmpty {
                ZStack(alignment: .bottom) {

                    TabView(selection: $currentIndex) {
                        ForEach(mediaItems.indices, id: \.self) { index in
                            let mediaURL = mediaItems[index].mediaURL ?? ""
                            let thumbnailURL = mediaItems[index].thumbnailURL ?? ""

                            ZStack {
                                if isVideoURL(mediaURL),
                                   let url = URL(string: mediaURL) {

                                    if playingIndex == index,
                                       let player = players[index] {

                                        VideoPlayer(player: player)
                                            .onAppear { player.play() }

                                    } else {
                                        AsyncImage(url: URL(string: thumbnailURL)) { image in
                                            image.resizable().scaledToFill()
                                        } placeholder: {
                                            Color.black.opacity(0.3)
                                        }
                                        // ▶️ PLAY BUTTON
                                        Image(systemName: "play.circle.fill")
                                            .resizable()
                                            .frame(width: 64, height: 64)
                                            .foregroundColor(.white)
                                            .shadow(radius: 6)
                                    }
                                } else {
                                    AsyncImage(url: URL(string: mediaURL)) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Color.gray.opacity(0.2)
                                    }
                                    
                                }
                                
                            }
                            .frame(height: 320)
                            .clipped()

                            .onTapGesture {
                                guard isVideoURL(mediaURL),
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
                    .onChange(of: currentIndex) { _ in
                        stopAllVideos()
                    }

                    HStack(spacing: 6) {
                        ForEach(mediaItems.indices, id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? Color(hex: "#258694") : .white)
                                .frame(width: 6, height: 6)
                        }
                    }
                    .padding(.bottom, 12)
                }
            }

            // MARK: - Actions
            HStack(spacing: 10) {

                Button {
                    onLikeTap(item.itemsuccess?.isLiked ?? false)
                } label: {
                    Label(
                        "\(likeCount)",
                        image: (item.itemsuccess?.isLiked ?? false) ? "PawLiked" : "PawUnliked"
                    )
                }
                
                
                Button(action: onCommentTap) {
                    Label("\(commentCount)", image: "Comment")
                }

                Button(action: onShareTap) {
                    Label("\(shareCount)", image: "Share")
                }

                Spacer()

                Button(action: {
                    onSaveTap()
                    if ((item.itemsuccess?.isSave ?? false) == false) {
                        showSavedPopup = true
                    }
                }) {
                    HStack(spacing: 6) {
                                          Text("Save")
                                              .foregroundColor((item.itemsuccess?.isSave ?? false) ? Color(hex: "#258694") : .black)
                                          Image((item.itemsuccess?.isSave ?? false) ? "savedfillicon" : "savedIcon")
                                              .resizable()
                                              .frame(width: 25, height: 25)
                                      }                }
            }
            .padding(10)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.1), radius: 6)
        .padding(.horizontal)
        .overlay(menuOverlay)
        .onAppear {
            isLiked = item.itemsuccess?.isLiked ?? false
            isBookmarked = item.itemsuccess?.isSave ?? false
           // isFollowing = item.itemsuccess?.iAmFollowing ?? false
        }
    }

    // MARK: - Menu Overlay
    private var menuOverlay: some View {
        Group {
            if isMenuVisible {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture { isMenuVisible = false }

                VStack {
                    Button {
                        isMenuVisible = false
                        onReportPostTap()
                    } label: {
                        HStack {
                            Image("reportPostIcon")
                                .resizable()
                                .frame(width: 18, height: 18)
                            Text("Report Post")
                                .font(.custom("Outfit-Regular", size: 16))
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                .position(x: UIScreen.main.bounds.width - 80, y: 70)
            }
        }
    }

    // MARK: - Helpers
    private func stopAllVideos() {
        players.values.forEach { $0.pause() }
        players.removeAll()
        playingIndex = nil
    }

    private func isVideoURL(_ url: String) -> Bool {
        ["mp4", "mov", "m4v", "avi", "webm"].contains {
            url.lowercased().hasSuffix($0)
        }
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


    private func intValue(_ value: Comments?) -> Int {
        switch value {
        case .integer(let v): return v
        case .string(let v): return Int(v) ?? 0
        default: return 0
        }
    }
}




private func presentShareSheet(items: [Any]) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return
        }
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // Show as half-screen (iOS 15+)
        if let sheet = activityVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()] // half + full
            sheet.prefersGrabberVisible = true
            sheet.selectedDetentIdentifier = .medium // start at half screen
        }
        
        rootVC.present(activityVC, animated: true)
    }









//  #Preview {
//      PetPostCardView(isMenuVisible: .constant(true))
//  }

