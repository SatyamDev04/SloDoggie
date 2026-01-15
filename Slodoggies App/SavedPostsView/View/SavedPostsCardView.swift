//
//  SavedPostsCardView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 08/09/25.
//

import SwiftUI

struct SavedPostsCardView: View {
    @ObservedObject var viewModel: SavedPostsViewModel
    let item: SavedPostDataModel
    let images = ["Post1", "Post1", "Post1"] // Your image asset names
    
    @State private var currentIndex = 0
    @State private var isLiked = false
    @State private var likeCount = 120
    @State private var isBookmarked = false
    @State private var showReportPopup = false
    @State private var isExpanded = false
    var onCommentTap: () -> Void = { }
    @State private var isSharePresented = false
    @EnvironmentObject private var coordinator: Coordinator
    @State private var showMenu = false
    var onEditTap: () -> Void = {}
    var onDeleteTap: () -> Void = {}
    var onShareTap: () -> Void = {}
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - Top Bar
            HStack(alignment: .top) { // adjust spacing here
//                ZStack {
                    Button(action: {
//                        coordinator.push(.profileDetailsView)
                    }) {
                        ZStack {

                            // USER IMAGE (Back Circle)
                            Group {
                                if let userImg = item.getUserDetail?.image, !userImg.isEmpty {
                                    Image.loadImage(userImg, width: 40, height: 40)
                                        .scaledToFill()
                                } else {
                                    Image("NoUserFound")
                                        .resizable()
                                        .scaledToFill()
                                }
                            }
                            .clipShape(Circle())

                            // PET IMAGE (Front Circle - Overlapping)
                            Group {
                                if let petImg = item.getPetDetail?.petImage, !petImg.isEmpty {
                                    Image.loadImage(petImg, width: 40, height: 40)
                                        .scaledToFill()
                                } else {
                                    Image("NoPetImg")
                                        .resizable()
                                        .scaledToFill()
                                }
                            }
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 3))
                            .offset(x: 22, y: 8)   // Perfect overlap position
                        }
                        .frame(width: 40, height: 40)
                    }
                    .buttonStyle(PlainButtonStyle())

//                }
//                .padding(.trailing, 30)
//                .frame(width: 50, height: 50) // slightly bigger so both fit well
                
//                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) { // reduce gap between words
                        Text(item.getUserDetail?.name ?? "")
                            .font(.custom("Outfit-Medium", size: 12))
                        Text("with")
                            .font(.custom("Outfit-Medium", size: 12))
                        Text(item.getPetDetail?.petName ?? "")
                            .font(.custom("Outfit-Medium", size: 12))
                    }
                    .font(.subheadline)

                     HStack(spacing: 6) {
//                        Text("Pet Mom")
//                            .font(.custom("Outfit-Medium", size: 8))
//                            .padding(.horizontal, 6)
//                            .padding(.vertical, 2)
//                            .background(Color.teal.opacity(0.2))
//                            .foregroundColor((Color(hex: "#258694")))
//                            .cornerRadius(6)
                         let postTime = item.createdAt
                         Text(postTime?.timeAgo() ?? "")
                            .font(.custom("Outfit-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading, 20)

                Spacer()
                
                Button(action: {
                    withAnimation {
                      showMenu.toggle()
                    }
                }) {
                    Image("ThreeDots")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.top, 20)
                }
                .frame(width: 10, height: 12)

            }
            .padding(10)
            
            // MARK: - Text Content
            VStack(alignment: .leading, spacing: 4) {
                Text(item.postTitle ?? "")
                    .font(.custom("Outfit-Regular", size: 13))
                    .lineLimit(isExpanded ? nil : 2) // ✅ expands when true
                    .animation(.easeInOut, value: isExpanded)

                Button(isExpanded ? "Read Less" : "Read More") {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
                .font(.custom("Outfit-Regular", size: 13))
                .foregroundColor(Color(hex: "#258694"))
            }
            .padding(.top, -16)
            .padding(.horizontal, 10)

            ZStack(alignment: .bottom) {

                let mediaList = item.getPostMedia ?? []

                TabView(selection: $currentIndex) {
                    ForEach(mediaList.indices, id: \.self) { index in
                        let mediaURL = mediaList[index].mediaPath ?? ""

                        if !mediaURL.isEmpty {
                            Image.loadImage(mediaURL)
//                                .resizable()
                                .scaledToFill()
                                .clipped()
                                .tag(index)
                        } else {
                            Image("NoPetImg")
                                .resizable()
                                .scaledToFill()
                                .clipped()
                                .tag(index)
                        }
                    }
                }
                .frame(height: 350)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                // Pagination Indicators
                HStack(spacing: 6) {
                    ForEach(0..<mediaList.count, id: \.self) { index in
                        if currentIndex == index {
                            Rectangle()
                                .fill(Color(hex: "#258694"))
                                .frame(width: 20, height: 6)
                                .cornerRadius(3)
                        } else {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 6, height: 6)
                        }
                    }
                }
                .padding(.bottom, 10)
            }

            
            HStack(spacing: 10) {
                Button(action:  {
//                    viewModel.toggleLike(itemId: item.id ?? 0)
                }) {
                    Label("\(item.getPostLikeCount ?? 0)", image: item.itemSuccess?.isLiked ?? true ? "PawLiked" : "PawUnliked")
                        .frame(width: 60, height: 30)
                }

//                Button(action: {
//                    item.itemSuccess?.isLiked?.toggle()
//                    item.getPostLikeCount += item.itemSuccess?.isLiked ? 1 : -1
//                }) {
//                    Label("\(item.getPostLikeCount)", image: item.itemSuccess?.isLiked ?? true ? "PawLiked" : "PawUnliked")
//                        .frame(width: 60, height: 30)
//                }

                Button(action: {
                    onCommentTap()
                }) {
                    Label("\(item.getPostCommentCount ?? 0)", image: "Comment")
                }
                    
                Button(action: {
                    onShareTap()
                    print("Share tapped")
                }) {
                    Label("\(item.getPostShareCount ?? 0)", image: "Share")
                }
  
                Spacer()
  
                Text("Save")
                    .font(.custom("Outfit-Regular", size: 14))
                
                Button(action: {
                    isBookmarked.toggle()
                    print("Export tapped")
                }) {
                    Image(isBookmarked ? "savedfillicon" : "savedIcon")
                        .resizable()
                        .frame(width: 24, height: 25)
                }
            }
            .padding(10)
            .font(.custom("Outfit-Regular", size: 14))
            .foregroundColor(Color.black)
            .font(.subheadline)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 4)
        .padding(.horizontal)
        
        .overlay(alignment: .topTrailing) {
            if showMenu {
                // Background tap handler
                Color.black.opacity(0.001) // transparent hit area
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }

                // Menu
                VStack(alignment: .leading, spacing: 12) {
                    // Edit Button
                    Button(action: {
                        showMenu = false
                        onEditTap()
                    }) {
                        HStack(spacing: 12) {
                            Image("PencilIcons")
                                .resizable()
                                .frame(width: 20, height: 22)
                                .foregroundColor(Color(hex: "#258694"))
                            
                            Text("Edit")
                                .font(.custom("Outfit-Regular", size: 16))
                                .foregroundColor(.black)
                        }
                    }
                    
                    // Delete Button
                    Button(action: {
                        showMenu = false
                        onDeleteTap()
                    }) {
                        HStack(spacing: 12) {
                            Image("delete")
                                .resizable()
                                .frame(width: 20, height: 22)
                            
                            Text("Delete")
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
                .position(x: UIScreen.main.bounds.width - 70, y: 100)
            }
          }
        }
      }

private func presentShareSheet(items: [Any]) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // ✅ Show as half-screen (iOS 15+)
        if let sheet = activityVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()] // half + full
            sheet.prefersGrabberVisible = true
            sheet.selectedDetentIdentifier = .medium // start at half screen
        }
        
        rootVC.present(activityVC, animated: true)
    }


//#Preview {
//    SavedPostsCardView()
//}
