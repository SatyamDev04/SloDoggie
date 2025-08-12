//
//  ProfileView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 22/07/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @StateObject private var viewModelGallery = SavedViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @State private var showAddPetSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 20){
                    Button(action: {
                        coordinator.pop()
                    }){
                        Image("Back")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    Text("My Profile")
                        .font(.custom("Outfit-Medium", size: 22))
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#221B22"))
                    //.padding(.leading, 100)
                    
                    Spacer()
                    
                    Button(action: {
                        coordinator.push(.settingView)
                    }){
                        Image("SettingIcon")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                //.padding(.bottom,2)
                
                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#656565"))
                
                Text("My Pets")
                    .font(.headline)
                    .padding(.leading, 20)
                
                Divider()
                    .frame(height: 1)
                    .background(Color(hex: "#949494"))
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.pets) { pet in
                            Image(pet.image)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(viewModel.selectedPet?.id == pet.id ? Color.blue : .clear, lineWidth: 2)
                                )
                                .onTapGesture {
                                    viewModel.selectedPet = pet
                                }
                        }
                        
                        Button(action: {
                            showAddPetSheet = true
                        }) {
                            Image("AddStoryIcon")
                                .frame(width: 50, height: 50)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                }
                
                if let selected = viewModel.selectedPet {
                    PetCardView(pet: selected)
                    StatsView(pet: selected)
                } else {
                    EmptyPetCardView()
                }
                
                if let user = viewModel.user {
                    OwnerCardView(user: user)
                }
                
                Text("Gallery")
                    .font(.headline)
                    .padding(.leading)
                
                if viewModel.galleryItems.isEmpty {
                    VStack {
                        Image("DogFoot")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.teal)
                        Text("No Post Yet").bold()
                        Button("Create Post") {
                            // action
                        }
                        .foregroundColor(.teal)
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    GalleryGridView(mediaItems: viewModelGallery.mediaItems) { index in
                        viewModelGallery.selectItem(at: index)
                    }
                    .fullScreenCover(isPresented: Binding<Bool>(
                        get: { viewModelGallery.selectedIndex != nil },
                        set: { newValue in
                            if !newValue {
                                viewModelGallery.closeViewer()
                            }
                        }
                    )) {
                        if let selectedIndex = viewModelGallery.selectedIndex {
                            MediaViewerView(items: viewModelGallery.mediaItems, selectedIndex: $viewModelGallery.selectedIndex)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showAddPetSheet) {
            AddYourPetView(isVisible: .constant(true))
                .environmentObject(coordinator) // pass coordinator if needed
        }
    }
}

#Preview {
    ProfileView()
}
