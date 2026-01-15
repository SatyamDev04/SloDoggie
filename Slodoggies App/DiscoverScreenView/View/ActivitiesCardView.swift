//
//  Activity.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ActivitiesCardView: View {
    let activity: PostActivitiesItem
    let images = ["BeachImage", "Post1", "BeachImage"] // Your image asset names
    @State private var currentIndex = 0
    @State private var isLiked = false
    @State private var isBookmarked = false
    @State private var isSharePresented = false
    @State private var isExpanded = false
    @State private var isFollowing = false
    @Binding var isMenuVisible: Bool
    @EnvironmentObject private var coordinator: Coordinator
    var onCommentTap: () -> Void = {}
    var onShareTap: () -> Void = {}
    var onReportPostTap: () -> Void = {}
    
    let onLikeTap: (_ isCurrentlyLiked: Bool) -> Void
    var onFollowTap: () -> Void = {}
    var onSaveTap: () -> Void = {}
    
    var mediaImages: [String] {
        activity.postMedia?
            .compactMap { $0.type?.lowercased() == "image" ? $0.mediaUrl : nil } ?? []
    }
    private var likeCount: Int {
        intValue(activity.engagement?.likes)
    }

    private var commentCount: Int {
        intValue(activity.engagement?.comments)
    }

    private var shareCount: Int {
        intValue(activity.engagement?.shares)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // MARK: - Top Bar
            HStack(alignment: .top) {
                // Profile image
//                Button(action: {
//                    coordinator.push(.profileDetailsView) // navigate to your route
//                }) {
//                    ZStack {
//                        if activity.media?.petImageUrl != ""{
//                            if let petUrlString = activity.media?.petImageUrl,
//                               !petUrlString.isEmpty,
//                               let petUrl = URL(string: petUrlString) {
//                                WebImage(url: petUrl)
//                                    .resizable()
//                                    .indicator(.activity)
//                                    .scaledToFill()
//                                    .frame(width: 40, height: 40)
//                                    .clipShape(Circle())
//                            } else {
//                                Image("NoPetImg")
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 40, height: 40)
//                                    .clipShape(Circle())
//                            }
//                        }
//                        
//                        // PARENT IMAGE (foreground, offset)
//                        if let parentUrlString = activity.media?.parentImageUrl,
//                           !parentUrlString.isEmpty,
//                           let parentUrl = URL(string: parentUrlString) {
//                            WebImage(url: parentUrl)
//                                .resizable()
//                                .indicator(.activity)
//                                .scaledToFill()
//                                .frame(width: 50, height: 50)
//                                .clipShape(Circle())
//                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                                .offset(x: 25, y: 10)
//                        } else {
//                            Image("download")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 50, height: 50)
//                                .clipShape(Circle())
//                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                                .offset(x: 25, y: 10)
//                        }
//                    }
//                    .frame(width: 50, height: 50)
//                }
//                .buttonStyle(PlainButtonStyle())
                ZStack {
                    // 👤 USER IMAGE (MAIN)
                    Group {
                        if let userImage = activity.media?.parentImageUrl,
                           !userImage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            
                            Image.loadImage(
                                userImage,
                                width: 40,
                                height: 40,
                                cornerRadius: 20,
                                contentMode: .fill
                            )
                           // .clipShape(Circle())
                            
                        } else {
                            Image("NoUserFound")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                    }
                    .onTapGesture {
                        if activity.author?.author_type == "Owner"{
                            coordinator.push(.profileDetailsView(activity.userId ?? "", ""))
                        }else{
                            coordinator.push(.busiProfileView("Home", activity.userId ?? "", hideSponsoredButton: true))
                        }
                    }
                    
                    Group{
                        if activity.author?.petName != ""{
                            // PET IMAGE (OVERLAY – SAME SIZE AS YOUR DESIGN)
                            
                            if let petImage = activity.media?.petImageUrl,
                               !petImage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                
                                Image.loadImage(
                                    petImage,
                                    width: 40,
                                    height: 40,
                                    cornerRadius: 20,
                                    contentMode: .fill
                                )
                                //.clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 2)
                                )
                                .offset(x: 25, y: 10)
                                
                            } else {
                                Image("NoUserFound")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(Color.white, lineWidth: 2)
                                    )
                                    .offset(x: 15, y: 15)
                            }
                        }
                    }
                    .onTapGesture {
//                        if activity.author?.author_type == "Owner"{
                        coordinator.push(.profileDetailsView("\(activity.author?.userId ?? 0)", activity.author?.petName ?? ""))
//                        }else{
//                            coordinator.push(.busiProfileView("Home", activity.userId ?? "", hideSponsoredButton: true))
//                        }
                    }
                }
                .frame(width: 50, height: 50)
                Spacer()
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(activity.author?.name ?? "")
                            .font(.custom("Outfit-Medium", size: 12))
                        if activity.author?.petName != ""{
                            Text("with")
                                .font(.custom("Outfit-Medium", size: 12))
                            Text(activity.author?.petName ?? "")
                                .font(.custom("Outfit-Medium", size: 12))
                        }
                    }
                    
                    HStack(spacing: 6) {
                        Text(activity.author?.pet_type ?? "")
                            .font(.custom("Outfit-Medium", size: 8))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.teal.opacity(0.2))
                            .foregroundColor(.teal)
                            .cornerRadius(6)
                        
                        Text(activity.content?.time ?? "")
                            .font(.custom("Outfit-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                    
                }
                .padding(.top, 4)
                .padding(.leading, -20)
                
                Button(action: {
                    withAnimation {
                       // isFollowing.toggle()
                        onFollowTap()
                    }
                }) {
                    Text((activity.itemsuccess?.iAmFollowing ?? false) ? "Following" : "Follow")
                        .font(.custom("Outfit-Regular", size: 12))
                        .frame(width: 70, height: 26)
                        .background((activity.itemsuccess?.iAmFollowing ?? false) ? Color.clear : Color(hex: "#258694"))
                        .foregroundColor((activity.itemsuccess?.iAmFollowing ?? false) ? Color(hex: "#258694") : .white)
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
                .padding(.top, 24)
                .frame(width: 10, height: 15)
                
            }
            .padding(10)
            
            // MARK: - Text Content
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.content?.title ?? "")
                    .font(.custom("Outfit-Bold", size: 13))
                
                Text(activity.content?.description ?? "")
                    .font(.custom("Outfit-Regular", size: 13))
                    .lineLimit(isExpanded ? nil : 2) // expands when true
                    .animation(.easeInOut, value: isExpanded)

                Button(isExpanded ? "Read Less" : "Read More") {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
                .font(.custom("Outfit-Regular", size: 13))
                .foregroundColor(Color(hex: "#258694"))
            }
            .padding(.horizontal, 10)

            ZStack(alignment: .bottom) {
                TabView(selection: $currentIndex) {
                    ForEach(mediaImages.indices, id: \.self) { index in
                        WebImage(url: URL(string: mediaImages[index]))
                            .resizable()
                            .scaledToFill()
                            .clipped()
//                          .cornerRadius(10)
                            .tag(index)
                    }
                }
                .frame(height: 350)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                HStack(spacing: 6) {
                    ForEach(mediaImages.indices, id: \.self) { index in
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
                Button {
                    onLikeTap(activity.itemsuccess?.isLiked ?? false)
                } label: {
                    Label(
                        "\(likeCount)",
                        image: (activity.itemsuccess?.isLiked ?? false) ? "PawLiked" : "PawUnliked"
                    )
                }
                
                
                Button(action: onCommentTap) {
                    Label("\(commentCount)", image: "Comment")
                }

                Button(action: onShareTap) {
                    Label("\(shareCount)", image: "Share")
                }
                
                Spacer()
                
                Button(action: {
                    onSaveTap()
                  // isBookmarked.toggle()
                    print("Export tapped")
                }) {
                    HStack(spacing: 6) {
                        Text("Save")
                            .font(.custom("Outfit-Regular", size: 14))
                            .foregroundColor((activity.itemsuccess?.isSave ?? false) ? Color(hex: "#258694") : .black) // Blue when saved
                        Image((activity.itemsuccess?.isSave ?? false) ? "savedfillicon" : "savedIcon")
                            .frame(width: 24, height: 25)
                    }
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
                    .position(x: UIScreen.main.bounds.width - 80, y: 70)
                 }
             }
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

//#Preview {
//    ActivitiesCardView(isMenuVisible: .constant(true))
//}
