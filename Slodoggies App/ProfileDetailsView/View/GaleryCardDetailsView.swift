//
//  GaleryCardDetailsView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI

struct GaleryCardDetailsView: View {
    let mediaItems: [MediaItem]
    let onSelect: (Int) -> Void

    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(Array(mediaItems.enumerated()), id: \.offset) { index, item in
                ZStack {
                    Group {
                        if let uiImage = UIImage(named: item.thumbnail) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            ZStack {
                                Color.gray.opacity(0.3)
                                Image(systemName: item.mediaType == .video ? "video" : "photo")
                                    .font(.system(size: 30))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .frame(height: 110)
                    .clipped()
                    .cornerRadius(8)

                    if item.mediaType == .video {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                }
                .onTapGesture {
                    onSelect(index)
                }
             }
          }
        .padding()
      }
   }
