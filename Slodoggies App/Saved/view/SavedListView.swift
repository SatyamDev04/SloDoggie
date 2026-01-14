//
//  SavedView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 16/07/25.
//

import SwiftUI

struct SavedView: View {

    @StateObject private var viewModel = SavedViewModel()
    @EnvironmentObject private var coordinator: Coordinator

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                headerView()

                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#258694"))

                Spacer()

                if viewModel.mediaItems.isEmpty && !viewModel.showActivity {
                    noDataView()
                    Spacer()
                } else {
                    gridView()
                }
            }

            if viewModel.showActivity{
                CustomLoderView(isVisible: $viewModel.showActivity)
            }
        }
        .onAppear {
            viewModel.loadInitialData()
        }

    }
}

// MARK: - Header
extension SavedView {

    @ViewBuilder
    private func headerView() -> some View {
        HStack(spacing: 20) {
            Button {
                coordinator.pop()
            } label: {
                Image("Back")
                    .resizable()
                    .frame(width: 24, height: 24)
            }

            Text("Saved")
                .font(.custom("Outfit-Medium", size: 20))
                .foregroundColor(Color(hex: "#221B22"))

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

// MARK: - Grid View
extension SavedView {

    @ViewBuilder
    private func gridView() -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(Array(viewModel.mediaItems.enumerated()), id: \.offset) { index, item in
                    gridCell(item: item)
                        .onTapGesture {
                            //viewModel.selectItem(at: index)
                          //  coordinator.push(.savedPostsView)
                            coordinator.push(.savedPostsView("", "Saved"))
                        }
                }
            }
            .padding()
        }
    }
    @ViewBuilder
    private func gridCell(item: MediaItem) -> some View {
        ZStack {
            // Video thumbnail
            if item.mediaType == .video, let videoURL = item.videoURL {
                if let image = viewModel.videoThumbnails[videoURL] {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 130)
                        .clipped()
                        .cornerRadius(10)
                } else {
                    Color.gray.opacity(0.3)
                        .frame(width: 120, height: 130)
                        .cornerRadius(10)
                        .onAppear {
                            viewModel.loadVideoThumbnail(for: videoURL)
                        }
                }
            }
            // Regular image
            else if !item.thumbnail.isEmpty {
                Image.loadImage(
                    item.thumbnail,
                    width: 120,
                    height: 130,
                    cornerRadius: 10,
                    contentMode: .fill
                )
            } else {
                placeholderView(for: item)
            }

            // ▶️ Play icon overlay
            if item.mediaType == .video {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
            }
        }
        .frame(width: 120, height: 130)
        .clipped()
        .cornerRadius(10)
    }

}

// MARK: - Empty State
extension SavedView {

    @ViewBuilder
    private func noDataView() -> some View {
        VStack(spacing: 12) {
           
            VStack(spacing: 12) {
                Image(systemName: "bookmark")
                    .font(.system(size: 40))
                    .foregroundColor(.gray.opacity(0.6))
                
                Text("No Saved Posts")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .padding(.top, 50) // push it slightly below header
        }
        .padding()
    }
}

// MARK: - Placeholder
extension SavedView {

    @ViewBuilder
    private func placeholderView(for item: MediaItem) -> some View {
        ZStack {
            Color.gray.opacity(0.3)
            Image(systemName: item.mediaType == .video ? "video" : "photo")
                .font(.system(size: 30))
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Preview
#Preview {
    SavedView()
}
