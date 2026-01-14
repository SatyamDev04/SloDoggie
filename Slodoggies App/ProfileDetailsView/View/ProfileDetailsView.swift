//
//  DetailsView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI

struct ProfileDetailsView: View {
    let userID: String
    let petName: String
    @StateObject private var viewModel = ProfileDetailsViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @State private var showAddPetSheet = false
    @State private var isFollowing = false
    @State private var navigateToMessage = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                
                headerView
                
                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#258694"))
                
                ScrollView {
                    contentView
                }
                .sheet(isPresented: $showAddPetSheet) {
                    AddYourPetView(isVisible: .constant(true))
                        .environmentObject(coordinator)
                }
            }
            .padding(.bottom)
            
            if viewModel.showActivity{
                CustomLoderView(isVisible: $viewModel.showActivity)
            }
        }
        .onAppear(){
            viewModel.petName = self.petName
            viewModel.ProfileDetailsApi(userId: userID)
            
            if viewModel.galleryItems.isEmpty {
                viewModel.loadInitialData(userId: userID)
            }
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text(viewModel.errorMessage ?? ""))
        }
    }
    
    private var headerView: some View {
        HStack(spacing: 20) {
            Button(action: { coordinator.pop() }) {
                Image("Back")
                    .resizable()
                    .frame(width: 24, height: 24)
            }

            Text(viewModel.selectedPet?.petName ?? "")
                .font(.custom("Outfit-Medium", size: 22))
                .foregroundColor(Color(hex: "#221B22"))
        }
        .padding(.leading)
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            petSelectionView
            selectedPetSection
            
            followAndMessageButtons
            
            if let user = viewModel.user {
                OwnerCardDetailsView(user: user)
            }
            
            gallerySection
            
            if viewModel.isLoadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
    }

    private var petSelectionView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.pets, id: \.id) { pet in
                    if let image = pet.petImage {
                        Image.loadImage(image, width: 50, height: 50)
                            .scaledToFill()
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(
                                    viewModel.selectedPet?.id == pet.id ?
                                    Color(hex: "#258694") : .clear,
                                    lineWidth: 2.5
                                )
                            )
                            .onTapGesture { viewModel.selectedPet = pet }
                        
                    } else {
                        Image("NoPetImg")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(
                                    viewModel.selectedPet?.id == pet.id ?
                                    Color(hex: "#258694") : .clear,
                                    lineWidth: 2.5
                                )
                            )
                            .onTapGesture { viewModel.selectedPet = pet }
                    }
//                    Image(pet.petImage ?? "")
//                        .resizable()
//                        .frame(width: 50, height: 50)
//                        .clipShape(Circle())
                        
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal)
        }
    }

    private var selectedPetSection: some View {
        Group {
            if let selected = viewModel.selectedPet {
                PetCardDetailsView(pet: selected)
                StatusDetailsView(userID: "\(selected.ownerUserID ?? 0)", postCount: viewModel.data?.postCount, followersCount: viewModel.data?.followerCount, followingCount: viewModel.data?.followingCount)
            } else {
                EmptyPetCardView(uID: userID)
            }
        }
    }
    
    private var followAndMessageButtons: some View {
        HStack(spacing: 16) {
            
            Button(action: { isFollowing.toggle() }) {
                Text(isFollowing ? "Following" : "Follow")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(hex: "#258694"))
                    .cornerRadius(10)
            }
            
            Button(action: { coordinator.push(.chatView) }) {
                Text("Message")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(Color(hex: "#258694"))
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.teal, lineWidth: 1)
                    )
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }

    private var gallerySection: some View {
        VStack(alignment: .leading) {
            Text("Gallery")
                .font(.custom("Outfit-Medium", size: 16))
                .padding(.leading)

            Divider()
                .frame(height: 1)
                .background(Color(hex: "#949494"))
                .padding(.horizontal, 20)

            if viewModel.galleryItems.isEmpty {
                noGalleryView
            } else {
                GaleryCardDetailsView(userId: userID, viewModel: viewModel, mediaItems: viewModel.galleryItems) { _ in
                    coordinator.push(.savedPostsView(userID, "OtherProfile"))
                }
            }
        }
    }

    private var noGalleryView: some View {
        VStack {
            Image("DogFoot")
                .resizable()
                .frame(width: 60, height: 60)
            Text("No Post Yet").bold()
            if userID != UserDetail.shared.getUserId(){
                Button("Create Post") { }
                    .foregroundColor(.teal)
            }
        }
        .frame(maxWidth: .infinity)
    }

}

#Preview {
    ProfileDetailsView(userID: "", petName: "")
}
