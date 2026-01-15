//
//  PostFormView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 29/07/25.
//
import SwiftUI
import PhotosUI

enum BusiPrivacyOption: String, CaseIterable, Identifiable {
    case publicOption = "Public"
    case followersOnly = "Followers Only"
    case privateOnly = "Private (Only me)"

    var id: String { self.rawValue }
}

struct PostFormView: View {
    @State private var description = ""
    @State private var hashtags = ""
    @State private var address = ""
    @State private var showAddPetSheet = false
    @State private var useCurrentLocation = false
    @State private var selectedPrivacy: BusiPrivacyOption = .publicOption
    
    @StateObject private var viewModel = CreatePostViewModel()
    @State private var selectedPetID : Int?
    @State private var lat : Double?
    @State private var long : Double?
//    @Binding var showPostSuccessPopView: Bool
    @Binding var pets: [PetsDetailData]
    
    @State private var selectedPet: PetsDetailData? = nil
    @State private var errorMessage: String? = nil
    @State private var showError = false
    @State private var postData :PostData?
    var backAction: (PostData) -> () = { _ in}
    var onPetAddBtnTap:() -> () = { }
    var errorHandler: (String) -> () = { _ in }
    var body: some View {
        ZStack{
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if UserDefaults.standard.string(forKey: "userType") == "Owner"{
                        SectionTitle("Who's This Post About?")
                        PetsScrollView(pets: $pets, selectedPet: $selectedPet,onPetAddTap: {
                            onPetAddBtnTap()
                        },selectedPetId: { id in
                            self.selectedPetID = id
                        })
                    }
                    SectionTitle("Upload Media")
                    UploadMediaSection(
                        viewModel: viewModel,
                        errorMessage: $errorMessage,showError: { msg in
                            errorHandler(msg)
                        }
                    )
                    
                    SelectedMediaGrid(
                        viewModel: viewModel,
                        errorMessage: $errorMessage,
                        showError: $showError
                    )
                    
                    // POST INPUT SECTION
//                    PostWriteSection(
//                        description: $description,
//                        hashtags: $hashtags,
//                        address: $address
//                    )
                    VStack(alignment: .leading, spacing: 12) {

                        SectionTitle("Write Post")

                        PlaceholderTextEditor(placeholder: "Enter Description", text: $description)
                            .frame(height: 120)

                        CustomTextField(title: "Hashtags", placeholder: "Add #tags", text: $hashtags)

                        CurrentAddressSection { address, coordinate in
                            self.address = address
                            self.lat = coordinate.latitude
                            self.long = coordinate.longitude
                        }
                        
                        SectionTitle("Your Address")
                        
                        TextField("Address", text: $address)
                            .padding()
                            .frame(height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4))
                            )
                    }
                  
                    SubmitButton {
                        
                        if validateForm() {
//                            showPostSuccessPopView = true
                            
                            self.backAction(PostData(petId: "\(self.selectedPetID ?? 0)",postTitle: self.description,media: viewModel.selectedMedia,hashtag: self.hashtags,address: self.address,latitude: "\(self.lat ?? 0.0)",longitude: "\(self.long ?? 0.0)"))
                        }
                    }
                }
                .padding()
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"),
                  message: Text(errorMessage ?? "Unknown error"),
                  dismissButton: .default(Text("OK")))
        }
    }
}

// MARK: VALIDATION

extension PostFormView {
    private func validateForm() -> Bool {
        if UserDefaults.standard.string(forKey: "userType") == "Owner"{
            if selectedPetID == nil {
                showErrorPopup("Select a pet for this post")
                return false
            }
        }
        if viewModel.selectedMedia.isEmpty {
            showErrorPopup("Select atleast one media")
            return false
        }
        if description.trimmingCharacters(in: .whitespaces).isEmpty {
            showErrorPopup("Enter post description")
            return false
        }else if address.trimmingCharacters(in: .whitespaces).isEmpty {
            showErrorPopup("Address field can't be empty")
            return false
        }
        return true
    }

    private func showErrorPopup(_ message: String) {
//        errorMessage = message
//        showError = true
        errorHandler(message)
    }
}

struct SectionTitle: View {
    let title: String
    init(_ title: String) { self.title = title }
    
    var body: some View {
        Text(title)
            .font(.custom("Outfit-Medium", size: 14))
    }
}
struct CurrentAddressSection: View {

    @StateObject private var locationVM = LocationManagerDelegate()
    
    var onSelect: (String, CLLocationCoordinate2D) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Current Location")
                .font(.custom("Outfit-Medium", size: 14))
                .padding(.top, 10)
            
            Button(action: {
                locationVM.onAddressFetched = { address, coordinate in
                    onSelect(address, coordinate)
                }
                locationVM.requestLocation()
            }) {
                HStack {
                    Image("mage_location")
                    Text("Use My Current Location")
                        .foregroundColor(.black)
                        .font(.custom("Outfit-Regular", size: 14))
                }
            }
            .padding(.bottom, 10)
            .frame(height: 40)
        }
    }
}

struct PetsScrollView: View {
    @Binding var pets: [PetsDetailData]
    @Binding var selectedPet: PetsDetailData?
    var onPetAddTap: () -> () = { }
    var selectedPetId: (Int) -> () = { _ in}
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                
                // Add Pet Button
                Button(action: {
                    onPetAddTap()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            .frame(width: 58, height: 78)
                        Image("AddStoryIcon")
                            .resizable()
                            .frame(width: 38, height: 38)
                    }
                }
                
                // Existing Pets
                ForEach(pets, id: \.id) { pet in
                    PetItemView(pet: pet, isSelected: selectedPet?.id == pet.id)
                        .onTapGesture {
                            selectedPet = pet
                            selectedPetId(selectedPet?.id ?? 0)
                            if let index = pets.firstIndex(where: { $0.id == pet.id }) {
                                let moved = pets.remove(at: index)
                                pets.insert(moved, at: 0)
                            }
                        }
                }
            }
        }
    }
}
struct PetItemView: View {
    let pet: PetsDetailData
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 6) {
            if pet.petImage != nil {
                
                Image.loadImage(pet.petImage,width: 38,height: 38)
                .scaledToFill()
                .clipShape(Circle())
                    
            }else{
                Image("download")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 38, height: 38)
                    .clipShape(Circle())
                
            }
            
            Text(pet.petName ?? "")
                .font(.custom("Outfit-Medium", size: 12))
                .foregroundColor(isSelected ? .white : .primary)
        }
        .frame(width: 58, height: 78)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color(hex: "#258694") : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
    }
}
struct UploadMediaSection: View {
    @ObservedObject var viewModel: CreatePostViewModel
    @Binding var errorMessage: String?
//    @Binding var showError: Bool
    var showError:(String) -> () = { _ in}
    var body: some View {
        VStack {
            if viewModel.selectedMedia.count < 6 {
                PhotosPicker(
                    selection: $viewModel.pickerItems,
                    maxSelectionCount: 6 - viewModel.selectedMedia.count,
                    matching: .any(of: [.images, .videos])
                ) {
                    UploadPlaceholder()
                }
                .onChange(of: viewModel.pickerItems) { items in
                    Task { await viewModel.addMedia(from: items) }
                }
            } else {
                UploadPlaceholder()
                    .onTapGesture {
                        showError("You can't upload more than 6 items")
//                        errorMessage = "You can't upload more than 6 items"
//                        showError = true
                    }
            }
        }
    }
}
struct UploadPlaceholder: View {
    var body: some View {
        VStack {
            Image("material-symbols_upload")
            Text("Upload Here")
                .font(.custom("Outfit-Medium", size: 14))
                .foregroundColor(Color(hex: "#258694"))
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 229/255, green: 239/255, blue: 242/255)))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(Color(hex: "#258694"))
        )
    }
}
struct SelectedMediaGrid: View {
    @ObservedObject var viewModel: CreatePostViewModel
    @Binding var errorMessage: String?
    @Binding var showError: Bool

    let grid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: grid, spacing: 10) {
            ForEach(Array(viewModel.selectedMedia.enumerated()), id: \.1.id) { idx, media in
                ZStack(alignment: .topTrailing) {
                    
                    if let img = media.image {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else if let url = media.videoURL {
                        VideoThumbnailView(videoURL: url)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    Button(action: { viewModel.removeMedia(at: idx) }) {
                        Image("redcrossicon")
                            .resizable()
                            .frame(width: 17, height: 17)
                    }
                    .offset(x: 6, y: -6)
                }
            }
        }
    }
}
struct SubmitButton: View {
    let action: () -> ()

    var body: some View {
        Button(action: action) {
            Text("Post")
                .font(.custom("Outfit-Bold", size: 16))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: "#258694"))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}
struct PlaceholderTextEditor: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
            }

            TextEditor(text: $text)
                .padding(.horizontal, 12)
                .background(Color.clear)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5))
        )
    }
}
