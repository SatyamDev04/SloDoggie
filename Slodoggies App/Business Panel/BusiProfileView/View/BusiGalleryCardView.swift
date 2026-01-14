//
//  GalleryCardView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 24/07/25.
//
//
import SwiftUI
import AVFoundation
import UIKit
struct BusiGalleryGridView: View {
    
    @ObservedObject var viewModel: BusiProfileViewModal
    let items: [BusiGalleryItem]
    let onSelect: (Int) -> Void
    let onLoadMore: () -> Void
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(items.indices, id: \.self) { index in
                let media = items[index].media?.first
                
                ZStack {
                    
                    // VIDEO
                    if media?.type?.lowercased() == "video",
                       let url = media?.url {
                        
                        if let image = viewModel.videoThumbnails[url] {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 135)
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .cornerRadius(10)
                        } else {
                            Color.gray.opacity(0.3)
                                .frame(height: 135)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(10)
                                .onAppear {
                                    viewModel.loadVideoThumbnail(for: url)
                                }
                        }
                    }
                    // IMAGE
                    else if let imageUrl = media?.url {
                        Image.loadImage(
                            imageUrl,
                            width: 120,
                            height: 135,
                            cornerRadius: 10,
                            contentMode: .fill
                        )
                    } else {
                        Color.gray.opacity(0.3)
                            .frame(height: 135)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                    }
                    
                    // ▶️ Play icon overlay
                    if media?.type?.lowercased() == "video" {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 34))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                    }
                }
                .frame(height: 135)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(10)
                .onTapGesture {
                    onSelect(index)
                }
            }
        }
    }
}

final class VideoThumbnailGenerator {
 
    static let shared = VideoThumbnailGenerator()
    private let cache = NSCache<NSString, UIImage>()
 
    private init() {}
 
    func thumbnail(for urlString: String) async -> UIImage? {
 
        if let cached = cache.object(forKey: urlString as NSString) {
            return cached
        }
 
        guard let url = URL(string: urlString) else { return nil }
 
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
 
        let time = CMTime(seconds: 1, preferredTimescale: 600)
 
        do {
            let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
            let image = UIImage(cgImage: cgImage)
            cache.setObject(image, forKey: urlString as NSString)
            return image
        } catch {
            print("Thumbnail error:", error)
            return nil
        }
    }
}
struct VideoThumbnailView11: View {
 
    let videoURL: String
    @State private var thumbnail: UIImage?
 
    var body: some View {
        ZStack {
 
            if let thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    //.aspectRatio(contentMode: .fill)   // 🔑 MATCH IMAGE
                    .frame(height: 135)              // ✅ SAME HEIGHT
                    .frame(maxWidth: .infinity)      // ✅ SAME WIDTH
            } else {
                Color.gray.opacity(0.3)
            }
 
            Image(systemName: "play.circle.fill")
                .font(.system(size: 34))
                .foregroundColor(.white)
                .shadow(radius: 4)
        }
        .clipped()   // 🔑 FORCE SAME SIZE
        .task {
            thumbnail = await VideoThumbnailGenerator.shared
                .thumbnail(for: videoURL)
        }
    }
}
