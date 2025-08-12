//
//  ProviderView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import SwiftUI

struct ProviderProfileView: View {
    @StateObject private var viewModel = ProviderProfileViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        VStack {
            HStack(spacing: 20){
                Button(action: {
                     coordinator.pop()
                }){
                    Image("Back")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text("Services")
                    .font(.custom("Outfit-Medium", size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: " #221B22"))
                //.padding(.leading, 100)
            }
            
            .padding()
            .padding(.leading, -180)
            .padding(.horizontal,25)
            .padding(.bottom,2)
            
            Divider()
                .frame(height: 2)
                .background(Color(hex: "#258694"))
            ProviderHeaderView(provider: viewModel.provider, followAction: viewModel.toggleFollow)

            Picker("", selection: $viewModel.selectedTab) {
                Text("Services").tag(ProviderProfileViewModel.Tab.services)
                Text("Rating & Reviews").tag(ProviderProfileViewModel.Tab.reviews)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            

            ScrollView {
                if viewModel.selectedTab == .services {
                    ServicesTabView(provider: viewModel.provider)
                } else {
                    ReviewsTabView(reviews: viewModel.provider.reviews)
                }
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
 
  #Preview {
     ProviderProfileView()
  }
