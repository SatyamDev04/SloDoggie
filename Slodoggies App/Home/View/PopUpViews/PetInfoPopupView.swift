//
//  PetInfoPopupView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 15/07/25.
//
import SwiftUI
import UIKit

struct PetInfoPopupView: View {
    var pets: [PetsDetailData]
    @StateObject private var viewModel = PetInfoViewModel()
    var backAction: () -> () = {}
    var errorHandler: (String) -> () = { _ in }
    var comesFrom: String?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()

            VStack {
                // Close button
                TopCloseButton(backAction: backAction)

                VStack(alignment: .leading, spacing: 25) {
                    
                        HStack {
                            Text("Tell us about your pet!")
                                .font(.custom("Outfit-Medium", size: 18))
                            Spacer()
                            if comesFrom != "TabBar"{
                                Button(action: backAction) {
                                    Text("Skip")
                                        .font(.custom("Outfit-Medium", size: 18))
                                        .foregroundColor(Color(hex: "#258694"))
                                }
                            }
                        }
                    Divider().padding(.top, -10)

                    ScrollView(showsIndicators: false) {

                        // PET LIST
//                        if viewModel.pets.isEmpty {
                        PetListView(viewModel: viewModel, petList: pets, comesFrom: comesFrom ?? "")
//                        }

                        // PHOTO SECTION
                        PetPhotoSection(viewModel: viewModel)
                            .padding(.top)

                        // FORM FIELDS
                        PetFormSection(viewModel: viewModel)

                        // BUTTONS
                        PetButtonsSection(viewModel: viewModel, backAction: backAction,comesFrom:self.comesFrom ?? "")
                            .padding(.top)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding(.top, 40)

            // LOADER
            if viewModel.showActivity {
                CustomLoderView(isVisible: $viewModel.showActivity)
                    .ignoresSafeArea()
            }
        }
        .overlay(
            Group {
                if viewModel.isPresented {
                    AddPetPopUPView(isVisible: $viewModel.isPresented) {
                        viewModel.isPresented = false
                        backAction()
                    }
                    .ignoresSafeArea()
                }
            }
        )
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text(""),
                message: Text(viewModel.errorMessage ?? "Something went wrong"),
                dismissButton: .default(Text("OK"))
            )
        }
        .confirmationDialog("Choose an option", isPresented: $viewModel.showActionSheet) {
            Button("Camera") { viewModel.showImagePicker = true }
            Button("Gallery") { viewModel.showImagePicker = true }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(
                image: $viewModel.selectedImage,
                onImgPick: { img in
                    viewModel.imgData = img.jpegData(compressionQuality: 0.8) ?? Data()
                },
                onLimitExceeded: { msg in
                    viewModel.showError = true
                    viewModel.errorMessage = msg
                }
            )
        }
    }
}
struct TopCloseButton: View {
    let backAction: () -> ()

    var body: some View {
        HStack {
            Spacer()
            Button(action: backAction) {
                Image("CancelIcon")
                    .resizable()
                    .frame(width: 35, height: 35)
            }
        }
        .padding(.top)
        .padding(.horizontal)
    }
}
struct PetListView: View {
    @ObservedObject var viewModel: PetInfoViewModel
    var petList: [PetsDetailData] = []
    var comesFrom: String
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                
                ForEach(comesFrom == "TabBar" ? petList : viewModel.pets, id: \.id) { pet in

                    VStack(spacing: 6) {
                        if let image = pet.petImage {
                            Image.loadImage(image, width: 40, height: 40)
                                .scaledToFill()
                                .clipShape(Circle())
                        } else {
                            Image("download")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }

                        Text(pet.petName ?? "")
                            .font(.custom("Outfit-Medium", size: 12))
                            .foregroundColor(.primary)
                    }
                    .frame(width: 58, height: 78)
                    .background(.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.5))
                    )
                    
                }

            }
        }
    }
}

struct PetPhotoSection: View {
    @ObservedObject var viewModel: PetInfoViewModel

    var body: some View {
        VStack {
            ZStack {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 65, height: 65)
                        .clipShape(Circle())
                } else {
                    Image("User")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                }

                Button(action: { viewModel.showActionSheet = true }) {
                    Image("UploadIcon")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .padding(4)
                        .background(Color(hex: "#258694"))
                        .cornerRadius(8)
                        .offset(x: 22, y: 22)
                }
            }

            Text("Add Photo")
                .font(.custom("Outfit-Medium", size: 14))
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
    }
}
struct PetFormSection: View {
    @ObservedObject var viewModel: PetInfoViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            CustomTextField(title: "Pet Name",
                            placeholder: "Enter pet name",
                            text: $viewModel.petName)

            CustomTextField(title: "Pet Breed",
                            placeholder: "Enter Breed",
                            text: $viewModel.petBreed)

            ScrollDropdownSelector(
                title: "Pet Age",
                text: $viewModel.petAge,
                placeholderTxt: "Select pet age",
                isPickerPresented: $viewModel.showAgePicker,
                options: viewModel.petAges
            )

            VStack(alignment: .leading, spacing: 10) {
                Text("Pet Bio")
                    .font(.custom("Outfit-Medium", size: 14))

                PlaceholderTextEditor(placeholder: "Enter Bio",
                                      text: $viewModel.petBio)
                    .frame(height: 80)
            }
        }
    }
}

struct PetButtonsSection: View {
    @ObservedObject var viewModel: PetInfoViewModel
    let backAction: () -> ()
    var errorHandel:(String) -> () = { _ in}
    var comesFrom:String
    var body: some View {
        HStack {
            Button(action: {
                if comesFrom == "TabBar" {
                    backAction()
                } else {
                    if viewModel.validateForm() {
                        viewModel.addPetApi { success in
                            if success {
                                backAction()
                            }
                        }
                    }
                }
            }) {
                Text(comesFrom == "TabBar" ? "Cancel" : "Continue")
            }
            .font(.custom("Outfit-Medium", size: 16))
            .foregroundColor(.black)
            .frame(minWidth: 150)

            Spacer()

            Button(action: {
                viewModel.addPetApi { success in
                    if success {
                        viewModel.addPetAction()
                    }
                }
            }) {
                Text("Add Pet")
                    .font(.custom("Outfit-Medium", size: 16))
                    .foregroundColor(.white)
                    .padding()
                    .frame(minWidth: 150)
                    .background(Color(hex: "#258694"))
                    .cornerRadius(10)
            }
        }
    }
}
