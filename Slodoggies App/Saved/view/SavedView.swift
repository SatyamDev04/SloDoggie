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
        let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

        var body: some View {
            HStack(spacing: 20){
                Button(action: {
                    coordinator.pop()
                }){
                    Image("Back")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text("Settings")
                    .font(.custom("Outfit-Medium", size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: " #221B22"))
                //.padding(.leading, 100)
            }
            .padding(.leading, -180)
            .padding(.horizontal,25)
            //.padding(.bottom,2)
            
            Divider()
                .frame(height: 2)
                .background(Color(hex: "#258694"))
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(Array(viewModel.mediaItems.enumerated()), id: \.offset) { index, item in
                        ZStack {
                            Group {
                                if let uiImage = UIImage(named: item.thumbnail) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } else {
                                    // Fallback placeholder (use system image or your own)
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
                            viewModel.selectItem(at: index)
                        }
                    }
                }
                .padding()
            }
            .fullScreenCover(isPresented: Binding<Bool>(
                get: { viewModel.selectedIndex != nil },
                set: { newValue in
                    if !newValue {
                        viewModel.closeViewer()
                    }
                }
            )) {
                if let selectedIndex = viewModel.selectedIndex {
                    MediaViewerView(items: viewModel.mediaItems, selectedIndex: $viewModel.selectedIndex)
                }
            }
        }
    }

#Preview {
    SavedView()
}
