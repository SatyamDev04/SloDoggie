//
//  GalleryCardView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 24/07/25.
//
import SwiftUI

struct GalleryGridView: View {
    let userId: String
    @ObservedObject var viewModel: ProfileViewModel
    let mediaItems: [PostGalleryList]
    let onSelect: (Int) -> Void

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 10),
        count: 3
    )

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
 
            ForEach(mediaItems.indices, id: \.self) { index in
                let item = mediaItems[index]
                let media = mediaItems[index].mediaPath?.first
 
                ZStack {
 
                    // VIDEO
                    if media?.type?.lowercased() == "video",
                       let url = media?.url {
                        VideoThumbnailView11(videoURL: url)
                    }
                    // IMAGE
                    else {
                        AsyncImage(url: URL(string: media?.url ?? "")) { image in
                            image
                                .resizable()
                                //.aspectRatio(contentMode: .fill)
                                .frame(height: 135)
                                .frame(maxWidth: .infinity)
                        } placeholder: {
                            ZStack {
                               Color.gray.opacity(0.2)
                               ProgressView()
                           }
                        }
//                        Image.loadImage(media?.url)
//                            .frame(height: 135)
//                            .frame(maxWidth: .infinity)
                       
                    }
                    
                }
                .frame(height: 135)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(10)
                .onTapGesture {
                    onSelect(index)
                }
                .onAppear {
                    viewModel.loadMoreIfNeeded(userId: userId, currentItem: item)
               }
            }
            
        }
        .padding(.horizontal)

      }
    
   }
