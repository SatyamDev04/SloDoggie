//
//  ProviderView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import SwiftUI

struct BusiServiceView: View {
    
  //  @StateObject private var viewModel = BusiServiceViewModel()
    @StateObject private var viewModel1 = BusinessServiceViewModel()
    @EnvironmentObject private var coordinator: Coordinator

    // Add popup state here
    @State private var showReplyPopup = false
    @State private var replyingTo: UUID? = nil
    @State private var replyText: String = ""
    @EnvironmentObject var tabRouter: TabRouter
    
    @State private var showDeletePopUp = false
    @State private var serviceIndexToDelete: Int? = nil
    
    @State private var showImagePopup = false
    @State private var popupPhotos: [String] = []
    @State private var popupIndex: Int = 0
    
    var body: some View {
        ZStack {
            VStack {
                // Header
                HStack(spacing: 20) {
                    Button(action: {
                        tabRouter.selectedTab = .home
                    }) {
                        Image("Back")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Text("Services")
                        .font(.custom("Outfit-Medium", size: 20))
                        .foregroundColor(Color(hex: "#221B22"))
                    Spacer()
                }
                .padding(.horizontal, 20)

                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#258694"))

                BusiServiceHeaderView(
                    provider: viewModel1.businessServiceResponse,
                    isLoading: viewModel1.isLoading
                )
                // Tab Picker
                BusiCustomSegmentControl(selectedTab: $viewModel1.selectedTab)
                    .padding(.horizontal)
                    .padding(.top, 12)
                // Scroll content
                ScrollView {
                    if viewModel1.selectedTab == .services {
                        BusiServiceTabView(
                            provider: viewModel1.businessServiceResponse,
                            serviceIndex: popupIndex,
                            onPhotoTap: { photos, index in
                                popupPhotos = photos
                                popupIndex = index
                                withAnimation { showImagePopup = true }
                            },
                            onDeleteTap: { index in
                                serviceIndexToDelete = index
                                showDeletePopUp = true    // ✅ SHOW POPUP
                            }
                        )

                    } else {
//                        BusiServiceReviewsTabView(
//                            reviews: $viewModel.reviews,
//                            onTapReply: { review in
//                                replyingTo = review.id
//                                showReplyPopup = true
//                            },
//                            onSendReply: { reply, reviewId in
//                                if let idx = viewModel.reviews.firstIndex(where: { $0.id == reviewId }) {
//                                    viewModel.reviews[idx].reply = ReviewReply(
//                                        authorName: "Rosy Morgan",
//                                        role: "Provider",
//                                        time: "Just now",
//                                        text: reply
//                                    )
//                                }
//                                showReplyPopup = false
//                                replyText = ""
//                            }
//                        )
                        BusiServiceReviewsTabView(
                            reviews: $viewModel1.reviews,
                            ratingCounts: viewModel1.ratingCounts,
                            averageRating: viewModel1.averageRating,
                            totalReviews: viewModel1.totalReviews,
                            onTapReply: { review in
                                replyingTo = review.id
                                showReplyPopup = true
                            },
                            onSendReply: { reply, reviewId in
                                if let idx = viewModel1.reviews.firstIndex(where: { $0.id == reviewId }) {
                                    viewModel1.reviews[idx].reply = ReviewReply(
                                        authorName: "Rosy Morgan",
                                        role: "Provider",
                                        time: "Just now",
                                        text: reply
                                    )
                                }
                                showReplyPopup = false
                                replyText = ""
                            }
                        )

                    }
                }
            }
            if viewModel1.isLoading{
                CustomLoderView(isVisible: $viewModel1.isLoading)
            }
            
            if showImagePopup {
                // Dim background
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showImagePopup = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                
                // Popup card
                ImagePopupView(
                    photos: popupPhotos,
                    selectedIndex: $popupIndex,
                    onClose: { withAnimation { showImagePopup = false } }
                )
                .padding(.horizontal, 16)
                .transition(.scale.combined(with: .opacity))
                .zIndex(2)
            }
            
            
            
            if showDeletePopUp {
                DeleteServicePopUp(
                    isVisible: $showDeletePopUp
                ) { action in
                    tabRouter.isTabBarHidden = false
                    
                    showDeletePopUp = false
                    
                    if action == "Yes" {
                        print("delete api called")
                        viewModel1.deleteService(serviceId: "\(viewModel1.businessServiceResponse?.services?[serviceIndexToDelete ?? 0].serviceID ?? 0)", index: serviceIndexToDelete ?? 0)

                    } else {
                        print("User cancelled delete")
                    }
                }

                .ignoresSafeArea()   // forces full-screen coverage
                .transition(.opacity)
            }

            // Global Popup
            if showReplyPopup {
                CommentReplyPopupView(isPresented: $showReplyPopup) { reply in
                    if let id = replyingTo {
                        if let idx = viewModel1.reviews.firstIndex(where: { $0.id == id }) {
                            viewModel1.reviews[idx].reply = ReviewReply(
                                authorName: "Rosy Morgan",
                                role: "Provider",
                                time: "Just now",
                                text: reply
                            )
                        }
                    }
                    showReplyPopup = false
                    replyText = ""
                }
                .transition(.opacity)
                .animation(.easeInOut, value: showReplyPopup)
            }
        }.onAppear() {
            viewModel1.getBusinessServiceDetails()
        }
        .onChange(of: coordinator.shouldRefreshServices) { refresh in
            if refresh {
                viewModel1.getBusinessServiceDetails()
                coordinator.shouldRefreshServices = false
            }}
    }
}


//struct BusiServiceMockData {
//    static let provider = BusiServiceModel(
//        id: UUID(),
//        name: "Pawfect Pet Care",
//        rating: 4.6,
//        address: "123 Pet Lane, San Diego, CA",
//        phone: "(123) 456-7890",
//        website: "pawfectpets.com",
//        description: "About: Trusted pet sitters with 5+ years of experience, offering loving care for your pets while you’re away. Fully insured and certified.",
//        isFollowing: false,
//        services: [
//            BusiService(id: UUID(), title: "Full Grooming Package", description: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et.", price: 100, photos: ["1","2","3","4","5","1","2","3","4","5"]),
//            BusiService(id: UUID(), title: "Nail Trimming", description: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et.", price: 100, photos: ["1","2","3","4","5","1","2","3","4","5"]),
//            BusiService(id: UUID(), title: "Bath & Brush", description: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et.", price: 100, photos: ["1","2","3","4","5","1","2","3","4","5"])
//        ],
//        reviews: [
//            BusiServiceReview(id: UUID(), reviewerName: "Courtney Henry", rating: 5, comment: "Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullamco exercitation. Ullamco tempor adipisicing et voluptate duis sit esse aliqua", timeAgo: "2 mins ago"),
//            BusiServiceReview(id: UUID(), reviewerName: "Cameron Williamson", rating: 4, comment: "Good service, will recommend.", timeAgo: "1 day ago")
//        ],
//        galleryImages: ["dog1", "dog2", "dog3", "dog4", "dog5", "dog6"]
//    )
// }
 
struct BusiCustomSegmentControl: View {
   // @Binding var selectedTab: BusiServiceViewModel.Tab
    @Binding var selectedTab: BusinessServiceViewModel.Tab
    let tabs: [BusinessServiceViewModel.Tab] = [.services, .reviews]
   
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                Text(tab == .services ? "Services" : "Rating & Reviews")
                    .frame(maxWidth: .infinity, minHeight: 34)
                    .background(selectedTab == tab ? Color(hex: "#258694") : Color.clear)
                    .foregroundColor(selectedTab == tab ? .white : .black)
                    .font(.custom("Outfit-Medium", size: 12))
                    .cornerRadius(8)
                    .onTapGesture {
                        selectedTab = tab
                }
            }
        }
        .padding(10) // Padding inside background
        .background(Color.blue.opacity(0.1)) // Light background container
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

  #Preview {
      BusiServiceView()
  }
