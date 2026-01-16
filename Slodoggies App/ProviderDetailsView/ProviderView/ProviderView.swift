//
//  ProviderView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import SwiftUI

struct ProviderProfileView: View {
    let businessID: Int
    @StateObject private var viewModel = ProviderProfileViewModel()
    @StateObject private var viewModel1 = BusinessServiceViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    // Popup state
    @State private var showImagePopup = false
    @State private var popupPhotos: [String] = []
    @State private var popupIndex: Int = 0
    
    @State private var showReplyPopup = false
    @State private var replyingTo: UUID? = nil
    @State private var replyText: String = ""
    
    var body: some View {
        ZStack{
            VStack {
                HStack(spacing: 20){
                    Button(action: {
                        coordinator.pop()
                    }) {
                        Image("Back").resizable().frame(width: 24, height: 24)
                    }
                    
                    Text("Services")
                        .font(.custom("Outfit-Medium", size: 20))
                        .foregroundColor(Color(hex: " #221B22"))
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                Divider().frame(height: 2).background(Color(hex: "#258694"))
                
                ProviderHeaderView(provider: viewModel.serviceResponse, followAction: viewModel.toggleFollow)
                    .padding(.top)
                
                CustomSegmentControl(selectedTab: $viewModel.selectedTab)
                    .padding(.horizontal)
                    .padding(.top, 12)
                
                ScrollView {
                    if viewModel.selectedTab == .services {
                        ServicesTabView(
                            provider: viewModel.serviceResponse,
                            onPhotoTap: { photos, index in
                                popupPhotos = photos
                                popupIndex = index
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                    showImagePopup = true
                                }
                            }
                        )
                    } else {
                        ReviewsTabView(businessID: businessID,
                                       reviews: $viewModel.reviews,
                                       ratingCounts: viewModel.ratingCounts,
                                       averageRating: viewModel.averageRating,
                                       totalReviews: viewModel.totalReviews,
                                       onTapReply: { review in
                                           replyingTo = review.id
                                           showReplyPopup = true
                                       },
                                       onSendReply: { reply, reviewId in
                                           if let idx = viewModel.reviews.firstIndex(where: { $0.id == reviewId }) {
                                               viewModel.reviews[idx].reply = ReviewReply(
                                                   authorName: "Rosy Morgan",
                                                   role: "Provider",
                                                   time: "Just now",
                                                   text: reply
                                               )
                                           }
                                           showReplyPopup = false
                                           replyText = ""
                                       },onreviewSuccess: {
                                           viewModel.getServiceDetails(BusinessID: businessID)
                                       })
                    }
                }
                .padding(.top, 12)
            }
            .onAppear() {
                viewModel.getServiceDetails(BusinessID: businessID)
            }
            
            if viewModel.isLoading{
                CustomLoderView(isVisible: $viewModel.isLoading)
            }
            
            // ===== Popup overlay ===== //
            if showImagePopup {
                // Dim background
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { showImagePopup = false }
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
            
         }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text(""),
                message: Text(viewModel.errorMessage ?? "Something went wrong"),
                dismissButton: .default(Text("OK"))
            )
        }
      }
   }


struct CustomSegmentControl: View {
    @Binding var selectedTab: ProviderProfileViewModel.Tab
    let tabs: [ProviderProfileViewModel.Tab] = [.services, .reviews]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                Text(tab == .services ? "Services" : "Rating & Reviews")
                    .frame(maxWidth: .infinity, minHeight: 34) // 👈 Control height here
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
      ProviderProfileView(businessID: 0)
  }
