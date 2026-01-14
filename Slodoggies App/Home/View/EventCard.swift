//
//  EventCard.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import SwiftUI
import AVKit

struct EventCard: View {
    
    let item: HomeItem
    
    @Binding var isMenuVisible: Bool
    
    let onCommentTap: () -> Void
    let onReportTap: () -> Void
    let onShareTap: () -> Void
    let onReportPostTap: () -> Void
    let onProfileTap: () -> Void
    let onJoinCommunityTap: () -> Void
    
    @Binding var showSavedPopup: Bool
   // @State private var isBookmarked = false
    
    @State private var currentIndex = 0
    @State private var isLiked = false
    @State private var likeCount = 0
    @State private var isInterested = false
   // @State private var isFollowing = false
    
    var onFollowTap: () -> Void = {}
    
    let onLikeTap: (_ isCurrentlyLiked: Bool) -> Void
    
    var onSaveTap: () -> Void = {}
    
    
    private var shareCount: Int {
        intValue(item.engagement?.shares)
    }
    
    @State private var playingIndex: Int? = nil
    @State private var players: [Int: AVPlayer] = [:]
    
    // MARK: - Derived Data
    private var mediaItems: [HPostMedia] { item.postMedia ?? [] }
    private var authorName: String { item.author?.name ?? "Unknown" }
    private var timeAgo: String { item.author?.time ?? "" }
    private var title: String { item.content?.title ?? "" }
    private var description: String { item.content?.description ?? "" }
    private var location: String { item.content?.location ?? "" }
    private var startTime: String { item.content?.startTime ?? "" }
    private var endTime: String { item.content?.endTime ?? "" }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // MARK: - Profile Row
            HStack {
                Button(action: onProfileTap) {

                    if let userImage = item.media?.parentImageURL,
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

                    VStack(alignment: .leading, spacing: 2) {
                        Text(authorName)
                            .font(.custom("Outfit-Medium", size: 14))
                        Text(timeAgo)
                            .font(.custom("Outfit-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .buttonStyle(.plain)
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
            }
                    .padding(10)
            
            // MARK: - Content
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.custom("Outfit-Medium", size: 14))
                
                HStack {
                    Text(description)
                        .font(.custom("Outfit-Regular", size: 13))
                        .foregroundColor(Color(hex: "#949494"))
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Label(startTime, image: "CalenderIcon")
                        Label(endTime, image: "CalenderIcon")
                    }
                    .font(.custom("Outfit-Regular", size: 13))
                }
                
                Label(location, image: "LocationPin")
                    .font(.custom("Outfit-Regular", size: 13))
            }
            .padding(.horizontal, 10)
            
     
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
                    //.padding(.bottom, 12)
                    
                }
                Button(action: onJoinCommunityTap) {
                    HStack {
                        Spacer()
                        Text("Join Community")
                            .font(.custom("Outfit-Medium", size: 16))
                        Image("joinCommunity")
                            .resizable()
                            .frame(width: 28, height: 28)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.black)
                    .foregroundColor(.white)
                }
                .padding(.top, -12)

            }
            
            // MARK: - Actions
            HStack {

                Button {
                    onLikeTap(item.itemsuccess?.isLiked ?? false)
                } label: {
                    Label {
                        Text("\(item.engagement?.likesCount ?? 0)")
                    } icon: {
                        Image((item.itemsuccess?.isLiked ?? false)
                              ? "PawLiked"
                              : "PawUnliked")
                    }
                }
                
//                Button(action: onShareTap) {
//                    Label("Share", image: "Share")
//                }
                
                Button(action: onShareTap) {
                    Label("\(shareCount)", image: "Share")
                }
                
                Spacer()
                
                
                Button(action: {
               //    isBookmarked.toggle()
//                    print("Save tapped")
                    onSaveTap()
                    if ((item.itemsuccess?.isSave ?? false) == false) {
                        showSavedPopup = true
                    }
                    
                }) {
                    HStack(spacing: 6) {
                        Text("Interested")
                            .font(.custom("Outfit-Regular", size: 14))
                            .foregroundColor((item.itemsuccess?.isSave ?? false) ? Color(hex: "#258694") : .black) // Blue when saved
                        
                        Image((item.itemsuccess?.isSave ?? false) ? "intrestedFilledimage" : "intrestedEmptyimage")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
                
                
                .font(.custom("Outfit-Regular", size: 14))
                .foregroundColor(.black)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 6)
        .padding(.horizontal)
        
        
    }
        
    private func intValue(_ value: Comments?) -> Int {
        switch value {
        case .integer(let v): return v
        case .string(let v): return Int(v) ?? 0
        default: return 0
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

//#Preview {
//    EventCard(event:EventModel(title: "Event Title", time: "May 25, 4:00 PM", duration: "30 Mins.", location: "San Luis Obispo County", image: "event_dog", likes: 200, shares: 10), onCommentTap: {})
//}
