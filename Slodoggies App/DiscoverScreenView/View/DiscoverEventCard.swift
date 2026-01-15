//
//  DiscoverEventModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFoundation
import _AVKit_SwiftUI

struct DiscoverEventCard: View {
    let event: DiscoverEventItem
    @State private var currentIndex = 0
    @State private var isLiked = false
    @State private var likeCount = 200
    @State private var isBookmarked = false
    @State private var isSharePresented = false
    @Binding var showSavedPopup: Bool
    @State private var isFollowing = false
   // @Published var eventVM = DiscoverEventViewModel()
    @Binding var isMenuVisible: Bool
    @EnvironmentObject private var coordinator: Coordinator
    var onReportTap: () -> Void = {}
    var onCommentTap: () -> Void = {}
    var onShareTap: () -> Void = {}
    var onLikeTap: (_ isCurrentlyLiked: Bool) -> Void
    var onReportPostTap: () -> Void = {}
    let onJoinCommunityTap: () -> Void
    var mediaImages: [HPostMedia] { event.postMedia }
    @State private var playingIndex: Int? = nil
    @State private var players: [Int: AVPlayer] = [:]
    private var shareCount: Int {
        intValue(event.engagement?.shares)
    }
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 12) {
              // MARK: - Profile Row
                HStack {
                    Button {
                        if event.author.author_type == "Owner"{
                            coordinator.push(.profileDetailsView("\(event.author.userId)",""))
                        }else{
                            coordinator.push(.busiProfileView("Home", "\(event.author.userId)", hideSponsoredButton: true))
                        }
//                        coordinator.push(.profileDetailsView)
                    } label: {
                        
                        if let url = URL(
                            string: event.media.imageUrl?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                        ),
                           ((event.media.imageUrl?.isEmpty) != nil) {
                            
                            WebImage(url: url)
                                .resizable()
                                .indicator(.activity)
                                .transition(.fade(duration: 0.3))
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            
                        } else {
                            
                            Image("DummyIcon 1") // fallback image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text(event.author.name)
                                .font(.custom("Outfit-Medium", size: 14))
                            
                            Button(action: {
                                withAnimation {
                                    isFollowing.toggle()
                                }
                            }) {
                                Text(isFollowing ? "Following" : "Follow")
                                    .font(.custom("Outfit-Regular", size: 12))
                                  //.padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .frame(width: 70)
                                    .background(isFollowing ? Color.clear : Color(hex: "#258694"))
                                    .foregroundColor(isFollowing ? Color(hex: "#258694") : .white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color(hex: "#258694"), lineWidth: 1)
                                    )
                                    .cornerRadius(6)
                            }
                            
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    isMenuVisible.toggle()
                                }
                            }) {
                                Image("ThreeDots")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                
                            }
                            .padding(.top, 14)
                            .frame(width: 10, height: 15)
                            
                        }
                        .padding(10)
                    
                        HStack{
                            Text(event.author.badge)
                                .frame(height: 17)
                                .font(.custom("Outfit-Medium", size: 12))
                                .foregroundColor(Color(red: 0/255, green: 99/255, blue: 122/255))
                                .padding(.leading, 6) .padding(.trailing, 6).background(Color(red: 0/255, green: 99/255, blue: 122/255).opacity(0.1)).cornerRadius(14)
                            Text(event.author.time)
                                .font(.custom("Outfit-Regular", size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, -10)
                        .padding(.leading, 6)
                      }
                     
                   // Spacer()
                }
                .padding(.top, 12)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                
                VStack(alignment: .leading,spacing: 6){
                    HStack{
                        Text(event.content.title)
                            .font(.custom("Outfit-Medium", size: 14))
                        Spacer()
                        Label(event.content.startTime, image: "CalenderIcon")
                            .font(.custom("Outfit-Regular", size: 14))
                            .lineLimit(1)
                    }
                    HStack{
                        Text(event.content.description)
                            .font(.custom("Outfit-Regular", size: 13))
                            .foregroundColor(Color(hex: "#949494"))
                            .lineLimit(2)
                        Spacer()
                        Label(event.content.endTime, image: "CalenderIcon")
                            .font(.custom("Outfit-Regular", size: 14))
                            .lineLimit(1)
                    }
                    
                    Label(event.content.location, image: "LocationPin")
                        .font(.custom("Outfit-Regular", size: 13))
                }
                .padding(.horizontal)
                
//                ZStack(alignment: .bottom) {
//                    TabView(selection: $currentIndex) {
//                        ForEach(mediaImages.indices, id: \.self) { index in
//                            WebImage(url: URL(string: mediaImages[index]))
//                                .resizable()
////                                .placeholder {
////                                        Image("placeholder")
////                                            .resizable()
////                                    }
//                                .scaledToFill()
//                                .clipped()
//                                .tag(index)
//                        }
//                    }
//                    .frame(height: 350)
//                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//
//                    HStack(spacing: 6) {
//                        ForEach(mediaImages.indices, id: \.self) { index in
//                            if currentIndex == index {
//                                Rectangle()
//                                    .fill(Color(hex: "#258694"))
//                                    .frame(width: 20, height: 6)
//                                    .cornerRadius(3)
//                            } else {
//                                Circle()
//                                    .fill(Color.white)
//                                    .frame(width: 6, height: 6)
//                            }
//                        }
//                    }
//                    .padding(.bottom, 60)
//
//                    ZStack(alignment: .trailing) {
//                        Rectangle()
//                            .fill(Color.black)
//                            .frame(height: 50)
//                        
//                        HStack(spacing: 8) {
//                            Text("Join Community")
//                                .font(.custom("Outfit-Medium", size: 16))
//                                .foregroundColor(.white)
//                            Button(action: {
//                                coordinator.push(.groupChatView) // navigate to your route
//                            }) {
//                                Image("joinCommunity") // Profile picture
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 28, height: 28)
//                                    .clipShape(Circle())
//                            }
//                        }
//                        .padding(.trailing, 12)
//                    }
//                }
                if !mediaImages.isEmpty {
                    ZStack(alignment: .bottom) {

                        TabView(selection: $currentIndex) {
                            ForEach(mediaImages.indices, id: \.self) { index in
                                let mediaURL = mediaImages[index].mediaURL ?? ""
                                let thumbnailURL = mediaImages[index].thumbnailURL ?? ""

                                ZStack {
                                    if mediaImages[index].type == .video,
                                       let url = URL(string: mediaURL ?? "") {

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
                            ForEach(mediaImages.indices, id: \.self) { index in
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
                
                // MARK: - Action Bar
                HStack(spacing: 10) {
                    Button {
                        onLikeTap(event.itemsuccess?.isLiked ?? false)
                    } label: {
                        Label {
                            Text("\(event.engagement?.likesCount ?? 0)")
                        } icon: {
                            Image((event.itemsuccess?.isLiked ?? false)
                                  ? "PawLiked"
                                  : "PawUnliked")
                        }
                    }
                    
                    Button(action: {
                        onShareTap()
                    }) {
                        Label("\(shareCount)", image: "Share")
                    }
                    
                    Spacer()
                   
                    Button(action: {
                        isBookmarked.toggle()
                        if isBookmarked {
                            showSavedPopup = true
                        }
                    }) {
                        HStack(spacing: 6) {
                            Text("Interested")
                                .font(.custom("Outfit-Regular", size: 14))
                                .foregroundColor(isBookmarked ? Color(hex: "#258694") : .black) // Blue when saved
                            Image(isBookmarked ? "intrestedFilledimage" : "intrestedEmptyimage")
                         }
                     }
                 }
                .padding(.horizontal)
                .padding(.bottom, 10)
                .font(.custom("Outfit-Regular", size: 14))
                .foregroundColor(.black)
            }
            
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 4)
        .padding(.top)
        .padding(.horizontal)
        
        .overlay(alignment: .topTrailing) {
            if isMenuVisible {
                ZStack {
                    // Full-screen transparent background to detect taps
                    Color.black.opacity(0.001) // invisible but tappable
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                isMenuVisible = false
                            }
                        }
                    
                    // The actual menu
                    VStack(alignment: .leading, spacing: 12) {
                        Button(action: {
                            isMenuVisible = false
                            onReportPostTap()
                        }) {
                            HStack{
                                Image("reportPostIcon")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                
                                Text("Report Post")
                                    .font(.custom("Outfit-Regular", size: 16))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .frame(width: 160, alignment: .leading)
                    .position(x: UIScreen.main.bounds.width - 100, y: 100)
                  }
               }
            }
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
    private func stopAllVideos() {
        players.values.forEach { $0.pause() }
        players.removeAll()
        playingIndex = nil
    }
    private func intValue(_ value: Comments?) -> Int {
        switch value {
            case .integer(let v): return v
            case .string(let v): return Int(v) ?? 0
            default: return 0
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

}

