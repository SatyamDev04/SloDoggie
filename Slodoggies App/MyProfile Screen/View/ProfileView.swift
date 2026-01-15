//
//  ProfileView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 22/07/25.
//

import SwiftUI

struct ProfileView: View {

    // MARK: - ViewModels
    var userID: String
    @StateObject private var viewModel = ProfileViewModel()
//    @StateObject private var viewModelGallery = SavedViewModel()
    // MARK: - Environment
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var tabRouter: TabRouter
    @EnvironmentObject private var userData: UserData

    // MARK: - States
    @State private var showAddPetSheet = false

    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 16) {
                
                headerSection
                
                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#258694"))
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        petsSection
                        
                        selectedPetSection
                        
                        ownerInfoSection
                        
                        galleryHeader
                        
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
            }
            .padding(.bottom)
//            .overlay(addPetOverlay)
            if viewModel.showActivity{
                CustomLoderView(isVisible: $viewModel.showActivity)
            }
            if showAddPetSheet {
//                AddYourPetView(isVisible: $showAddPetSheet)
//                    .onAppear { tabRouter.isTabBarHidden = true }
//                    .onDisappear { tabRouter.isTabBarHidden = false }
//                    .transition(.opacity)
                PetInfoPopupView(pets: [],backAction:  {
                    showAddPetSheet = false
                    tabRouter.isTabBarHidden = false
                },errorHandler: { msg in
                    viewModel.errorMessage = msg
                    viewModel.showError = true
                } , comesFrom: "TabBar")
            }
        }
        .onAppear {
            viewModel.ProfileDetailsApi()
            
            if viewModel.galleryItems.isEmpty {
                viewModel.loadInitialData(userId: userID)
            }
        }

        // LISTEN FOR PROFILE UPDATE
        .onReceive(
            NotificationCenter.default.publisher(for: .profileDidUpdate)
        ) { _ in
            viewModel.ProfileDetailsApi()
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text(viewModel.errorMessage ?? ""))
        }
    }
}

// MARK: - UI SECTIONS
extension ProfileView {
    // MARK: Header
    private var headerSection: some View {
        HStack(spacing: 20) {
            Button(action: {
                tabRouter.selectedTab = .home
            }) {
                Image("Back")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            Text("My Profile")
                .font(.custom("Outfit-Medium", size: 22))
                .foregroundColor(Color(hex: "#221B22"))
            
            Spacer()
            
            settingsButton
        }
        .padding(.horizontal, 20)
    }
    
//    private var backButton: some View {
//        
//        
//    }
    
    private var settingsButton: some View {
        Button {
            let type = UserDefaults.standard.string(forKey: "userType")
            type == "Professional" ?
                coordinator.push(.busiSettingsView) :
                coordinator.push(.settingView)
        } label: {
            Image("SettingIcon")
                .resizable()
                .frame(width: 24, height: 24)
        }
    }

    // MARK: My Pets Section
    private var petsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("My Pets")
                .font(.custom("Outfit-Medium", size: 16))
                .padding(.leading, 20)

            Divider()
                .frame(height: 1)
            .background(Color(hex: "#949494"))
            .padding(.horizontal, 14)

            petsScrollView
        }
    }
    
    private var petsScrollView: some View {
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
                }
                addPetButton
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
    }
    
    private var addPetButton: some View {
        Button {
            showAddPetSheet = true
            tabRouter.isTabBarHidden = true
        } label: {
            Image("AddStoryIcon")
                .frame(width: 50, height: 50)
                .background(Color.gray.opacity(0.2))
                .clipShape(Circle())
        }
    }

    // MARK: Selected Pet Card
    private var selectedPetSection: some View {
        Group {
            if let selected = viewModel.selectedPet {
                PetCardView(pet: selected)
                StatusDetailsView(userID:"\(selected.ownerUserID ?? 0)", postCount: viewModel.data?.postCount, followersCount: viewModel.data?.followerCount, followingCount: viewModel.data?.followingCount)
            } else {
                EmptyPetCardView(uID: userID)
            }
        }
    }

    // MARK: Owner Information
    private var ownerInfoSection: some View {
        Group {
            if let user = viewModel.user {
                OwnerCardView(user: user)
            }
        }
    }

    // MARK: Gallery Header
    private var galleryHeader: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Gallery")
                .font(.custom("Outfit-Medium", size: 16))
                .padding(.leading)
            
            Divider()
                .frame(height: 1)
                .background(Color(hex: "#949494"))
                .padding(.horizontal, 20)
        }
    }

    // MARK: Gallery Section
    private var gallerySection: some View {
        Group {
            if viewModel.galleryItems.isEmpty {
                emptyGalleryView
            } else {
                GalleryGridView(userId:UserDetail.shared.getUserId() , viewModel: viewModel, mediaItems: viewModel.galleryItems) { index in
                    coordinator.push(.savedPostsView(UserDetail.shared.getUserId(), "MyProfile"))
                }
            }
        }
    }
    
    private var emptyGalleryView: some View {
        VStack {
            Image("DogFoot")
                .resizable()
                .frame(width: 60, height: 60)
            
            Text("No Post Yet")
                .bold()
            
            if userID == UserDetail.shared.getUserId(){
                Button("Create Post") { }
                    .foregroundColor(.teal)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: Add Pet Overlay
//    private var addPetOverlay: some View {
//        Group {
//            if showAddPetSheet {
////                AddYourPetView(isVisible: $showAddPetSheet)
////                    .onAppear { tabRouter.isTabBarHidden = true }
////                    .onDisappear { tabRouter.isTabBarHidden = false }
////                    .transition(.opacity)
//                PetInfoPopupView(pets: [],backAction:  {
//                    showAddPetSheet = false
//                }, comesFrom: "Profile")
//            }
//        }
//    }
}

#Preview {
    ProfileView(userID: "")
}

extension Notification.Name {
    static let profileDidUpdate = Notification.Name("profileDidUpdate")
}
