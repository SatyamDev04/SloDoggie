//
//  AdCard.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import SwiftUI
import AVKit

struct AdCard: View {

    let ad: HomeItem

    @State private var currentIndex = 0
    @State private var isLiked = false
    @State private var likeCount = 0

    var onCommentTap: () -> Void
    @Binding var isMenuVisible: Bool
    var onReportTap: () -> Void
    var onShareTap: () -> Void
    var onReportPostTap: () -> Void
    
    let onLikeTap: (_ isCurrentlyLiked: Bool) -> Void

    @State private var playingIndex: Int? = nil
    @State private var players: [Int: AVPlayer] = [:]
    @EnvironmentObject private var coordinator: Coordinator

    // MARK: - Derived Data
    private var mediaItems: [HPostMedia] {
        ad.postMedia ?? []
    }

    private var authorName: String {
        ad.author?.name ?? "Unknown"
    }

    private var title: String {
        ad.content?.title ?? ""
    }

    private var description: String {
        ad.content?.description ?? ""
    }
    private var timeAgo: String {
        ad.author?.time ?? ""
    }
    
    private var commentCount: Int {
        intValue(ad.engagement?.comments)
    }

    private var shareCount: Int {
        intValue(ad.engagement?.shares)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // MARK: - Header
            HStack {
                Button {
                    coordinator.push(.busiProfileView("Home",ad.userID ?? "", hideSponsoredButton: true))
                } label: {
                    HStack(spacing: 8) {
//                        AsyncImage(url: URL(string: ad.media?.parentImageURL ?? "")) { img in
//                            img.resizable()
//                        } placeholder: {
//                           // Circle().fill(Color.gray.opacity(0.3))
//                            Image("NoUserFound")   // 👈 your asset image
//                                       .resizable()
//                                       .scaledToFill()
//                        }
//                        .frame(width: 40, height: 40)
//                        .clipShape(Circle())
//                        .overlay(
//                            Circle().stroke(Color.white, lineWidth: 2)
//                        )
                        
                        if let userImage = ad.media?.parentImageURL,
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
                        }
                        
                        VStack(alignment: .leading) {
                            Text(authorName)
                                .font(.custom("Outfit-Medium", size: 13))
                            Text(timeAgo)
                                .font(.custom("Outfit-Regular", size: 11))
                                .foregroundColor(.gray)
                        }
                    }
                }
                Spacer()

                Button {
                    withAnimation { isMenuVisible.toggle() }
                } label: {
                    Image("ThreeDots")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 0)
                }
            }
            .padding(.horizontal)

            // MARK: - Text
            if !title.isEmpty {
                Text(title)
                    .font(.custom("Outfit-Regular", size: 13))
                    .padding(.horizontal)
            }
            
            // MARK: - Text
            if !description.isEmpty {
                Text(description)
                    .font(.custom("Outfit-Regular", size: 13))
                    .padding(.horizontal)
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
                  
                }

            }

            // MARK: - Sponsored CTA

                            Button(action: {
                            let userType = UserDefaults.standard.string(forKey: "userType")
                            print(userType, "userType")
            
                            if userType == "Professional" {
                                coordinator.push(.adsDashboardView)
                            } else {
                                if let userId = Int(ad.userID ?? "") {
                                    coordinator.push(.providerProfileView(userId))
                                }
                            }
            
                            }) {
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color(hex: "#258694"))
                                        .frame(height: 50)
            
                                    Text("Sponsored")
                                        .font(.custom("Outfit-Medium", size: 16))
                                        .foregroundColor(.white)
                                        .padding(.leading, 10)
                                }
                            }
                             // .frame(width: 20, height: 6)


            // MARK: - Actions
            HStack(spacing: 10) {

                Button {
                    onLikeTap(ad.itemsuccess?.isLiked ?? false)
                } label: {
                    Label {
                        Text("\(ad.engagement?.likesCount ?? 0)")
                    } icon: {
                        Image((ad.itemsuccess?.isLiked ?? false)
                              ? "PawLiked"
                              : "PawUnliked")
                    }
                }

                Button(action: onCommentTap) {
                    Label("\(commentCount)", image: "Comment")
                }

                Button(action: onShareTap) {
                    Label("\(shareCount)", image: "Share")
                }

                Spacer()
            }
            .padding(10)
            
            .font(.custom("Outfit-Regular", size: 14))
               .foregroundColor(Color.black)
               .font(.subheadline)
        }
        .padding(.top,10)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 6)
        .padding(.horizontal)

        // MARK: - Menu Overlay
        .overlay(alignment: .topTrailing) {
            if isMenuVisible {
                menuOverlay
            }
        }
    }

    private var menuOverlay: some View {
        VStack(alignment: .leading) {
            Button {
                isMenuVisible = false
                onReportPostTap()
            } label: {
                Label("Report Post", image: "reportPostIcon")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .frame(width: 160)
        .padding(.trailing, 16)
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
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // Show as half-screen (iOS 15+)
        if let sheet = activityVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()] // half + full
            sheet.prefersGrabberVisible = true
            sheet.selectedDetentIdentifier = .medium // start at half screen
        }
        
        rootVC.present(activityVC, animated: true)
    }

// #Preview {
//    AdCard(ad: AdModel(image: "dog_ad", title: "Summer Special: 20% Off Grooming!", subtitle: "Limited Time Offer", likes: 200, comments: 100, shares: 10), isMenuVisible: .constant(true))
// }
