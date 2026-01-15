//
//  EditPetProfileView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import SwiftUI

struct PetProfileView: View {
    @State var pet: PetsDetailData
    @StateObject private var viewModel = PetProfileViewModel()
    @State private var showImagePicker = false
    @State var showSuccessPopView: Bool = false
    @EnvironmentObject private var coordinator: Coordinator
    // @EnvironmentObject var userData: UserData // Not used; remove to reduce type-check load
    @State private var showmanagedByPicker = false
    @Binding var isPresented: Bool
    @State var deleteProfilePopView: Bool = false
    @State private var showAgePicker = false

    let petAges = ["<1"] + (1...20).map { String($0) }
    let managedByOptions = ["Pet Mom", "Pet Dad", "Guardian", "Other"]

    var backAction: () -> () = {}
    @State private var managedBy: String = ""

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                headerBar

                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#258694"))

                ScrollView {
                    avatarSection

                    formSection

                    saveButton

                    Spacer(minLength: 0)
                }
            }
            
            if viewModel.showActivity{
                CustomLoderView(isVisible: $viewModel.showActivity)
            }
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text(""),
                message: Text(viewModel.errorMessage ?? "Something went wrong"),
                dismissButton: .default(Text("OK"))
            )
        }
        .overlay(overlaysGroup)
        .confirmationDialog("Choose an option", isPresented: $viewModel.showActionSheet, titleVisibility: .visible) {
            Button("Camera") {
                viewModel.imageSource = .camera
                showImagePicker = true
            }
            Button("Gallery") {
                viewModel.imageSource = .photoLibrary
                showImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showImagePicker) {
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

    // MARK: - Sections

    private var headerBar: some View {
        HStack(spacing: 20) {
            Button(action: {
                coordinator.pop()
            }) {
                Image("Back")
                    .resizable()
                    .frame(width: 24, height: 24)
            }

            Text("Edit Pet Profile")
                .font(.custom("Outfit-Medium", size: 22))
                .foregroundColor(Color(hex: "#221B22"))

            Spacer()

            Button(action: {
                deleteProfilePopView = true
            }) {
                Image("deleteIcon 1")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 20)
    }

    private var avatarSection: some View {
        ZStack {
            if let imageURL = pet.petImage {
                Image.loadImage(imageURL)
                    .scaledToFill()
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
            } else {
                Image("DummyIcon 1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { viewModel.showActionSheet = true }) {
                        Image("UploadIcon")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(4)
                            .background(Color(hex: "#258694"))
                            .cornerRadius(8)
                    }
                    .offset(x: -26, y: -16)
                }
            }
        }
        .frame(width: 170, height: 170)
    }

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            EditProfileCustomTextField(title: "Pet Name", text: nonOptionalBinding(for: $pet.petName))
            EditProfileCustomTextField(title: "Pet Breed", text: nonOptionalBinding(for: $pet.petBreed))

            DropdownSelector(
                title: "Pet Age",
                text: nonOptionalBinding(for: $pet.petAge),
                placeholderTxt: "Enter pet age",
                isPickerPresented: $showAgePicker,
                options: petAges
            )
            .padding(.top)
            .padding(.leading, 20)
            .padding(.trailing, 20)

            EditProfileCustomTextField(title: "Pet Bio", text: nonOptionalBinding(for: $pet.petBio))

            // If needed later:
            // DropdownSelector(
            //     title: "Managed By",
            //     text: $managedBy,
            //     placeholderTxt: "Select Managed By",
            //     isPickerPresented: $showmanagedByPicker,
            //     options: managedByOptions
            // )
            // .padding(.top)
            // .padding(.leading, 20)
            // .padding(.trailing, 20)
        }
    }

    private var saveButton: some View {
        Button(action: {
            if validateForm() {
                let petIdString = pet.id.map { String($0) } ?? ""
                viewModel.addPetApi(
                    name: pet.petName ?? "",
                    breed: pet.petBreed ?? "",
                    age: pet.petAge ?? "",
                    bio: pet.petBio ?? "",
                    petId: petIdString
                ) { status in
                    if status {
                        showSuccessPopView = true
                        NotificationCenter.default.post(name: .profileDidUpdate,object: nil)
                    }
                }
            }
        }) {
            Text("Save Changes")
                .font(.custom("Outfit-Bold", size: 16))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: "#258694"))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding(.top)
        .padding(.leading, 61)
        .padding(.trailing, 61)
    }

    private var overlaysGroup: some View {
        Group {
            if deleteProfilePopView {
                DeletePetProfile(petID: "\(pet.id ?? 0)", isPresented: $deleteProfilePopView,
                                 ondelete: {
                    coordinator.pop()
                    }
                )

            }
            if showSuccessPopView {
                PetProfileUpdatedSuccPopUp(isVisible: $showSuccessPopView)
            }
        }
    }

    // MARK: - Helpers

    private func nonOptionalBinding(for optional: Binding<String?>) -> Binding<String> {
        Binding<String>(
            get: { optional.wrappedValue ?? "" },
            set: { newValue in
                optional.wrappedValue = newValue.isEmpty ? nil : newValue
            }
        )
    }

    private func isEmptyOrNil(_ value: String?) -> Bool {
        guard let v = value?.trimmingCharacters(in: .whitespacesAndNewlines), !v.isEmpty else {
            return true
        }
        return false
    }

    private func validateForm(skipBackAction: Bool = false) -> Bool {
        if isEmptyOrNil(pet.petName) {
            showErrorPopup("Enter pet name")
            return false
        }
        if isEmptyOrNil(pet.petBreed) {
            showErrorPopup("Enter pet breed")
            return false
        }
        if isEmptyOrNil(pet.petAge) {
            showErrorPopup("Enter pet age")
            return false
        }
        if isEmptyOrNil(pet.petBio) {
            showErrorPopup("Enter pet bio")
            return false
        }
        if !skipBackAction {
            backAction()
        }
        return true
    }

    private func showErrorPopup(_ message: String) {
        viewModel.errorMessage = message
        viewModel.showError = true
    }
}

struct CustomDropdown: View {
    var title: String
    @Binding var selection: String
    var options: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("Outfit-Medium", size: 14))
                .foregroundColor(.black)
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        selection = option
                    }
                }
            } label: {
                HStack {
                    Text(selection.isEmpty ? "Select \(title)" : selection)
                        .foregroundColor(selection.isEmpty ? .gray : .black)
                    Spacer()
                    Image("DropdownIcon")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "#949494"))
                )
            }
        }
    }
}

struct EditProfileCustomTextField: View {
    var title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("Outfit-Medium", size: 14))
                .foregroundColor(.black)
            TextField("Enter \(title.lowercased())", text: $text)
                .padding()
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "#9C9C9C"))
                )
                .font(.custom("Outfit-Regular", size: 15))
        }
        .padding(.top)
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}

#Preview {
    PetProfileView(
        pet: PetsDetailData(
            id: 0,
            ownerUserID: 0,
            petName: nil,
            petBreed: nil,
            petAge: nil,
            petImage: nil,
            petBio: nil,
            createdAt: nil,
            updatedAt: nil,
            deletedAt: nil
        ),
        isPresented: .constant(true)
    )
}
