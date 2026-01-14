//
//  AddYourPetView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 24/07/25.
//

import SwiftUI

struct AddYourPetView: View {
    @State private var petName = ""
    @State private var petBreed = ""
    @State private var petAge = ""
    @State private var petBio = ""
    @State private var managedBy = "Pet Mom"
    @State private var showImagePicker = false
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showAgePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var showManagerPicker = false
    @Binding var isVisible: Bool
    @StateObject private var viewModel = PetInfoViewModel()
    @State private var errorMessage: String? = nil
    @State private var showActionSheet = false
    @State private var showError = false
    var backAction : () -> () = {}
    let petAges = ["1 Years", "2 Years", "3 Years","4 Years","5 Years","6 Years","7 Years","8 Years","9 Years","10 Years","11 Years", "12 Years", "13 Years","14 Years","15 Years","16 Years","17 Years","18 Years","19 Years","20 Years" ]
    let managerOptions = ["Pet Mom", "Pet Dad", "Guardian"]

    var body: some View {
        ZStack {
            // Background dimming
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isVisible = false
                    }) {
                        Image("CancelIcon")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .padding()
                }
                
                // Main Card
                VStack(alignment: .leading, spacing: 25) {
                    Text("Tell us about your pet!")
                        .font(.custom("Outfit-Medium", size: 18))
                    
                    Divider()
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Profile Image + Upload Button
                            VStack {
                                ZStack(alignment: .bottomTrailing) {
                                    // Profile Image
                                    if let image = viewModel.selectedImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 90, height: 90)
                                            .clipShape(Circle())
                                    } else {
                                        Image("User")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 90, height: 90)
                                            .clipShape(Circle())
                                    }
                                    
                                    // Upload Button (overlapping bottom-right corner)
                                    Button(action: { showActionSheet = true }) {
                                        Image("UploadIcon")
                                            .resizable()
                                            .frame(width: 18, height: 18)
                                            .padding(4)
                                            .background(Color(hex: "#258694"))
                                            .cornerRadius(8)
                                            //.clipShape(Circle())
                                            //.offset(x: 22, y: 22)
                                    }
                                    //.offset(x: 5, y: 5)
                                }
                                Text("Add Photo")
                                    .font(.custom("Outfit-Medium", size: 14))
                                    .padding(.top, 4)
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Form Fields
                            VStack(alignment: .leading, spacing: 20) {
                                CustomTextField(title: "Pet Name", placeholder: "Enter pet name", text: $petName)
                                
                                CustomTextField(title: "Pet Breed", placeholder: "Enter Breed", text: $petBreed)
                                
                                ScrollDropdownSelector(
                                    title: "Pet Age",
                                    text: $petAge,
                                    placeholderTxt: "Select pet age",
                                    isPickerPresented: $showAgePicker,
                                    options: petAges
                                )
                                
                                CustomTextField(title: "Pet Bio", placeholder: "Enter Bio", text: $petBio)
                            }
                            
                            // Action Buttons
                            HStack {
                                Button(action: { isVisible = false }) {
                                    Text("Cancel")
                                        .font(.custom("Outfit-Medium", size: 16))
                                        .foregroundColor(.black)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .cornerRadius(10)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    if validateForm(){
                                        isVisible = false
                                    }
                                }) {
                                    Text("Add Pet")
                                        .font(.custom("Outfit-Medium", size: 16))
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color(hex: "#258694"))
                                        .cornerRadius(10)
                                }
                            }
                            .padding(.top, 10)
                        }
                        .padding(.vertical)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.8)
                .padding(.horizontal)
            }
            .alert(isPresented: $showError) {
                Alert(
                    title: Text(""),
                    message: Text(errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .toolbar(.hidden, for: .tabBar)
        // Camera/Gallery action sheet
        .confirmationDialog("Choose an option", isPresented: $showActionSheet, titleVisibility: .visible) {
            Button("Camera") {
                imageSource = .camera
                showImagePicker = true
            }
            Button("Gallery") {
                imageSource = .photoLibrary
                showImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        // Image picker sheet
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $viewModel.selectedImage,onImgPick: { img in
                viewModel.imgData = img.jpegData(compressionQuality: 0.8) ?? Data()
            }, onLimitExceeded: { msg in
                viewModel.showError = true
                viewModel.errorMessage = msg
            })
        }
    }
    
    private func validateForm(skipBackAction: Bool = false) -> Bool {
        if petName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter pet name")
            return false
        }
        if petBreed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter pet breed")
            return false
        }
        if petAge.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter pet age")
            return false
        }
        if petBio.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter pet bio ")
            return false
        }
        
        // All fields are filled and valid
        if !skipBackAction {
                backAction()
            }
            return true
    }
    
    private func showErrorPopup(_ message: String) {
        errorMessage = message
        showError = true
    }
}

#Preview {
    AddYourPetView(isVisible: .constant(true))
}

