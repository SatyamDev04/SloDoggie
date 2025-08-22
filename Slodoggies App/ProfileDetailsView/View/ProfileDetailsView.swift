//
//  DetailsView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI

struct ProfileDetailsView: View {
    @StateObject private var viewModel = ProfileDetailsViewModel()
    @StateObject private var viewModelGallery = SavedViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @State private var showAddPetSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 20){
                Button(action: {
                    coordinator.pop()
                }){
                    Image("Back")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text("Jimmi")
                    .font(.custom("Outfit-Medium", size: 22))
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: "#221B22"))
                //.padding(.leading, 100)
                
            }
            .padding(.leading)
            
            Divider()
                .frame(height: 2)
                .background(Color(hex: "#656565"))
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.pets) { pet in
                                Image(pet.image)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(viewModel.selectedPet?.id == pet.id ? Color(hex: "#258694") : .clear, lineWidth: 2.5)
                                    )
                                    .onTapGesture {
                                        viewModel.selectedPet = pet
                                    }
                            }
                        }
                        .padding(.top, 4)
                        .padding(.bottom, 4)
                        .padding(.horizontal)
                    }
                    
                    if let selected = viewModel.selectedPet {
                        PetCardDetailsView(pet: selected)
                        StatusDetailsView(pet: selected)
                    } else {
                        EmptyPetCardDetailView()
                    }
                    
                    if let user = viewModel.user {
                        OwnerCardDetailsView(user: user)
                    }
                    
                    Text("Gallery")
                        .font(.custom("Outfit-Medium", size: 16))
                        .padding(.leading)
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color(hex: "#949494"))
                        .padding(.horizontal, 20)
                        //.padding(.top)
                    
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
        }.padding(.bottom)
    }
}

#Preview {
    ProfileDetailsView()
}
