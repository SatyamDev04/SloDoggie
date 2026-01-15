////
////  VideoCard.swift
////  Slodoggies App
////
////  Created by YATIN  KALRA on 14/07/25.
////
//
//import SwiftUI
//
//struct VideoCard: View {
//    let video: VideoModel
//    let images = ["Post1", "Post1", "Post1"] // Your image asset names
//    @State private var currentIndex = 0
//    @State private var isLiked = false
//    @State private var likeCount = 120
//    @State private var isBookmarked = false
//    @State private var readMoreTapped = false
//    @State private var isSharePresented = false
//    @EnvironmentObject private var coordinator: Coordinator
//    var onCommentTap: () -> Void = {}
//    @State private var isFollowing = false
//    @Binding var isMenuVisible: Bool
//    @State private var showComments = false
//    var onReportTap: () -> Void = {}
//    var onShareTap: () -> Void = {}
//    var onReportPostTap: () -> Void = {}
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            // MARK: - Top Bar
//            HStack(alignment: .top) {
//                // Profile image
//                Button(action: {
//                    coordinator.push(.profileDetailsView) // navigate to your route
//                }) {
//                ZStack {
//                   Image("Lady")
//                       .resizable()
//                       .aspectRatio(contentMode: .fill)
//                       .frame(width: 50, height: 50)
//                       .clipShape(Circle())
//
//                   Image("Dog")
//                       .resizable()
//                       .aspectRatio(contentMode: .fill)
//                       .frame(width: 50, height: 50)
//                       .clipShape(Circle())
//                       .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                       .offset(x: 25,y: 10)
//               }
//               .frame(width: 50, height: 50)
//            }
//            .buttonStyle(PlainButtonStyle())
//            
//                Spacer()
//                VStack(alignment: .leading, spacing: 4) {
//                    HStack {
//                        Text("Lydia Vaccaro")
//                            .font(.custom("Outfit-Medium", size: 12))
//                        Text("with")
//                            .font(.custom("Outfit-Medium", size: 12))
//                        Text("Wixx")
//                            .font(.custom("Outfit-Medium", size: 12))
//                    }
//                    .font(.subheadline)
//
//                    HStack(spacing: 6) {
//                        Text("Pet Mom")
//                            .font(.custom("Outfit-Medium", size: 8))
//                            .padding(.horizontal, 6)
//                            .padding(.vertical, 2)
//                            .background(Color.teal.opacity(0.2))
//                            .foregroundColor(.teal)
//                            .cornerRadius(6)
//
//                        Text("5 Min.")
//                            .font(.custom("Outfit-Regular", size: 12))
//                            .foregroundColor(.gray)
//                    }
//                }
//
//                Button(action: {
//                    withAnimation {
//                        isFollowing.toggle()
//                    }
//                }) {
//                    Text(isFollowing ? "Following" : "Follow")
//                        .font(.custom("Outfit-Regular", size: 12))
//                    //.padding(.horizontal, 12)
//                        .padding(.vertical, 6)
//                        .frame(width: 70)
//                        .background(isFollowing ? Color.clear : Color(hex: "#258694"))
//                        .foregroundColor(isFollowing ? Color(hex: "#258694") : .white)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 6)
//                                .stroke(Color(hex: "#258694"), lineWidth: 1)
//                        )
//                        .cornerRadius(6)
//                }
//                
//                Spacer()
//                
//                Button(action: {
//                    withAnimation {
//                        isMenuVisible.toggle()
//                    }
//                }) {
//                    Image("ThreeDots")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 20, height: 20)
//                        .padding(.trailing, 10)
//                }
//                .padding(.top, 24)
//                .frame(width: 10, height: 15)
//            }
//            .padding(10)
//            
//            // MARK: - Text Content
//            VStack(alignment: .leading, spacing: 4) {
//                Text("🐶 Say hello to Jimmi! Three years of cuddles, chaos, and unconditional love. Here’s to more adventures with my favorite fur companion! 🐾 #JimmiTheDog #LifeWithPets #SloDoggiesLove #PetParentGoals #DogVibesOnly")
//                    .font(.custom("Outfit-Regular", size: 13))
//                    .lineLimit(readMoreTapped ? nil : 2) 
//
//                   if !readMoreTapped {
//                       Button("Read More") {
//                           readMoreTapped = true
//                       }
//                       .font(.custom("Outfit-Regular", size: 13))
//                       .foregroundColor(Color(hex: "#258694"))
//                   }
//            }
//            .padding(.horizontal, 10)
//
//            ZStack(alignment: .bottom) {
//                TabView(selection: $currentIndex) {
//                    ForEach(0..<images.count, id: \.self) { index in
//                        ZStack {
//                            Image(images[index])
//                                .resizable()
//                                .scaledToFill()
//                                .frame(height: 350)
//                                .clipped()
//
//                            // Center Play Button
//                            Image("PlayButton")
//                                .resizable()
//                                .frame(width: 50, height: 50)
//                                .foregroundColor(.white)
//                                .shadow(radius: 4)
//                        }
//                        .tag(index)
//                    }
//                }
//                .frame(height: 350)
//                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//
//                // Video progress bar (dummy progress)
//                Rectangle()
//                    .fill(Color.white.opacity(0.7))
//                    .frame(height: 4)
//                    .overlay(
//                        GeometryReader { geometry in
//                            // Dummy progress value, you can replace with actual video progress
//                            let progress: CGFloat = 0.4
//                            Rectangle()
//                                .fill(Color(hex: "#258694"))
//                                .frame(width: geometry.size.width * progress)
//                        }
//                    )
//            
//                HStack(spacing: 6) {
//                    ForEach(0..<images.count, id: \.self) { index in
//                        if currentIndex == index {
//                            Rectangle()
//                                .fill(Color(hex: "#258694"))
//                                .frame(width: 20, height: 6)
//                                .cornerRadius(3)
//                        } else {
//                            Circle()
//                                .fill(Color.white)
//                                .frame(width: 6, height: 6)
//                        }
//                    }
//                }
//                .padding(.bottom, 10)
//            }
//
//            
//            HStack(spacing: 10) {
//                Button(action: {
//                    isLiked.toggle()
//                    likeCount += isLiked ? 1 : -1
//                }) {
//                    Label("\(likeCount)", image: isLiked ? "PawLiked" : "PawUnliked")
//                        .frame(width: 60, height: 30)
//                }
//
//                Button(action: {
//                    onCommentTap()
//                }) {
//                    Label("20", image: "Comment")
//                }
//                Button(action: {
//                    onShareTap()
//                }) {
//                    Label("10", image: "Share")
//                }
//
//                Spacer()
//                
//                Button(action: {
//                    isBookmarked.toggle()
//                    print("Save tapped")
//                }) {
//                    HStack(spacing: 6) {
//                        Text("Save")
//                            .font(.custom("Outfit-Regular", size: 14))
//                            .foregroundColor(isBookmarked ? Color(hex: "#258694") : .black) // Blue when saved
//                        
//                        Image(isBookmarked ? "savedfillicon" : "savedIcon")
//                            .resizable()
//                            .frame(width: 24, height: 25)
//                    }
//                }
//            }
//            .padding(10)
//            .font(.custom("Outfit-Regular", size: 14))
//            .foregroundColor(Color.black)
//            .font(.subheadline)
//
//         }
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 4)
//        .padding(.horizontal)
//        
//        .overlay(alignment: .topTrailing) {
//            if isMenuVisible {
//                ZStack {
//                    // Full-screen transparent background to detect taps
//                    Color.black.opacity(0.001) // invisible but tappable
//                        .ignoresSafeArea()
//                        .onTapGesture {
//                            withAnimation {
//                                isMenuVisible = false
//                            }
//                        }
//                    
//                    // The actual menu
//                    VStack(alignment: .leading, spacing: 12) {
//                        Button(action: {
//                            isMenuVisible = false
//                            onReportPostTap()
//                        }) {
//                            HStack{
//                                Image("reportPostIcon")
//                                    .resizable()
//                                    .frame(width: 18, height: 18)
//                                
//                                Text("Report Post")
//                                    .font(.custom("Outfit-Regular", size: 16))
//                                    .foregroundColor(.black)
//                            }
//                        }
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(12)
//                    .shadow(radius: 4)
//                    .frame(width: 160, alignment: .leading)
//                    .position(x: UIScreen.main.bounds.width - 80, y: 70)
//                 }
//             }
//         }
//    }
//}
//
//private func presentShareSheet(items: [Any]) {
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let rootVC = windowScene.windows.first?.rootViewController else { return }
//        
//        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
//        
//        // Show as half-screen (iOS 15+)
//        if let sheet = activityVC.sheetPresentationController {
//            sheet.detents = [.medium(), .large()] // half + full
//            sheet.prefersGrabberVisible = true
//            sheet.selectedDetentIdentifier = .medium // start at half screen
//        }
//
//    rootVC.present(activityVC, animated: true)
//    }
//
//#Preview {
//    VideoCard(video: VideoModel(title: "Say hello to Jimmi!", description: "Three years of cuddles...", tags: ["#LifeWithPets", "#SloDoggiesLove"], thumbnail: "video_dog", likes: 200, comments: 100, shares: 15), isMenuVisible: .constant(true))
//}
