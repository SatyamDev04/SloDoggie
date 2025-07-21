//
//  MediaViewerView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 16/07/25.
//

import SwiftUI
import AVKit

struct MediaViewerView: View {
    let items: [MediaItem]
    @Binding var selectedIndex: Int?

    @State private var players: [Int: AVPlayer] = [:]

    var body: some View {
        TabView(selection: Binding(
            get: { selectedIndex ?? 0 },
            set: { selectedIndex = $0 }
        )) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                ZStack {
                    Color.black.ignoresSafeArea()

                    if item.mediaType == .image {
                        Image(item.thumbnail)
                            .resizable()
                            .scaledToFit()
                            .tag(index)
                    } else if let videoURL = item.videoURL {
                        VideoPlayer(player: getPlayer(for: index, url: videoURL))
                            .tag(index)
                    } else {
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            Text("Video not found")
                                .foregroundColor(.white)
                        }
                        .tag(index)
                    }
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .background(Color.black)
        .onChange(of: selectedIndex) { newIndex in
            handlePlaybackChange(newIndex: newIndex)
        }
        .onTapGesture {
            selectedIndex = nil
        }
    }

    // Store or retrieve player for a given index
    private func getPlayer(for index: Int, url: URL) -> AVPlayer {
        if let existing = players[index] {
            return existing
        } else {
            let player = AVPlayer(url: url)
            players[index] = player
            return player
        }
    }

    // Pause all except current, and restart the selected one
    private func handlePlaybackChange(newIndex: Int?) {
        for (index, player) in players {
            if index == newIndex {
                player.seek(to: .zero)
                player.play()
            } else {
                player.pause()
            }
        }
    }
}
