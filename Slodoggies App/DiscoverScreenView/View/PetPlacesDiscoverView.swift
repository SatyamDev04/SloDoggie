//
//  PetPlacesDiscoverView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI
import SDWebImageSwiftUI

// MARK: - PetPlacesDiscoverView (Parent)
struct PetPlacesDiscoverView: View {
    @StateObject private var viewModel = DiscoverViewModel()
    @State private var selectedPlace: PetPlace?
    @State private var showPopup = false

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ],
                spacing: 16
            ) {
                ForEach(viewModel.petPlaces) { place in
                    PetPlaceCard(place: place)
                        .onTapGesture {
                            selectedPlace = place
                            showPopup = true
                        }
                }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
        .onAppear {
            viewModel.fetchPetPlaces(page: 1)
        }
        if viewModel.showActivity {
            CustomLoderView(isVisible: $viewModel.showActivity)
                .ignoresSafeArea()
                .zIndex(999)
        }
        
    }
}

// MARK: - PetPlaceCard (Single Card UI)
struct PetPlaceCard: View {
    let place: PetPlace

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            ZStack {
                if let imageUrl = place.image,
                   !imageUrl.isEmpty {
                    Image.loadImage(imageUrl)
//                    WebImage(url: url)
//                        .resizable()
                        .scaledToFill()
//                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                } else {
                    Image("download")
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(height: 120)              // ✅ fixed height
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .clipped()

            Text(place.title)
                .font(.custom("Outfit-SemiBold", size: 14))
                .foregroundColor(.black)
                .lineLimit(1)

            Text(place.location)
                .font(.custom("Outfit-Regular", size: 12))
                .foregroundColor(Color(hex: "#9C9C9C"))
                .lineLimit(1)

            Text(place.distance)
                .font(.custom("Outfit-Regular", size: 12))
        }
        .padding(8)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: "#CEE1E5"), lineWidth: 0.5)
        )
    }
}



#Preview{
    PetPlacesDiscoverView()
}
