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
    @EnvironmentObject private var coordinator: Coordinator
    // Popup state
    @State private var showImagePopup = false
    @State private var popupPhotos: [String] = []
    @State private var popupIndex: Int = 0
    
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
                        ReviewsTabView(reviews: $viewModel.reviews)
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
         }
      }
   }

struct MockData {
    static let provider = ProviderModel(
        id: UUID(),
        name: "Pawfect Pet Care",
        rating: 4.6,
        address: "123 Pet Lane, San Diego, CA",
        phone: "(123) 456-7890",
        website: "pawfectpets.com",
        description: "Business Description : Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad ",
        isFollowing: false,
        services: [
            Service(id: UUID(), title: "Full Grooming Package", description: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et.", price: 100, photos: ["1","2","3","4","5","1","2","3","4","5"]),
            Service(id: UUID(), title: "Nail Trimming", description: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et.", price: 100, photos: ["1","2","3","4","5","1","2","3","4","5"]),
            Service(id: UUID(), title: "Bath & Brush", description: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et.", price: 100, photos: ["1","2","3","4","5","1","2","3","4","5"])
        ],
        reviews: [
            Review(id: UUID(), reviewerName: "Courtney Henry", rating: 5, comment: "Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullamco exercitation. Ullamco tempor adipisicing et voluptate duis sit esse aliqua", timeAgo: "2 mins ago"),
            Review(id: UUID(), reviewerName: "Cameron Williamson", rating: 4, comment: "Good service, will recommend.", timeAgo: "1 day ago")
        ],
        galleryImages: ["dog1", "dog2", "dog3", "dog4", "dog5", "dog6"]
    )
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
