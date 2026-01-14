//
//  EditProfileView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//


import SwiftUI

struct EditProfileView: View {
    @StateObject private var viewModel = EditProfileViewModel()
    @State private var showImagePicker = false
    @State var showSuccessPopView: Bool = false
//    @State private var parentName = ""
//    @State private var mobileNo = ""
//    @State private var email = ""
//    @State private var Bio = ""
//    @State private var relationToPet = ""
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject var userData: UserData
    @State private var showRelationToPetPicker = false
    let relationToPetOptions = ["Pet Mom", "Pet Dad", "Guardian", "Other"]
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage? = nil
    @State private var showActionSheet = false
    @State private var showManagerPicker = false
    var backAction : () -> () = {}
    @State private var errorMessage: String? = nil
    @State private var showError = false
    
    var body: some View {
        ZStack{
            VStack(spacing: 20) {
                HStack(spacing: 20){
                    Button(action: {
                        coordinator.pop()
                    }){
                        Image("Back")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Text("Edit Profile")
                        .font(.custom("Outfit-Medium", size: 22))
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#221B22"))
                    
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                //.padding(.bottom,2)
                
                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#258694"))
                
                // MARK: - Pet Image
                ScrollView{
                    ZStack {
                        // Outer Circle Background (light teal border)
                        //                    Circle()
                        //                        .fill(Color(red: 229/255, green: 239/255, blue: 242/255))
                        //                        .frame(width: 160, height: 160)
                        
                        // Profile Image
                        //                    if let image = viewModel.selectedImage {
                        //                        Image(uiImage: image)
                        //                            .resizable()
                        //                            .scaledToFill()
                        //                            .frame(width: 140, height: 140)
                        //                            .clipShape(Circle())
                        //                    } else {
                        //                        Image("People1")
                        //                            .resizable()
                        //                            .scaledToFill()
                        //                            .frame(width: 140, height: 140)
                        //                            .clipShape(Circle())
                        //                    }
                        if let img = viewModel.selectedImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                            
                        }else if viewModel.profileImage != "" {
                            
                            Image.loadImage(viewModel.profileImage)
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                            
                        }else {
                            Image("NoUserFound")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                        }
                        // Upload Button (bottom-right)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: { showActionSheet = true }) {
                                    Image("UploadIcon")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .padding(4)
                                        .background(Color(hex: "#258694"))
                                        .cornerRadius(8)
                                        .offset(x: -18, y: -10)
                                }
                                //.offset(x: -16, y: -16)
                            }
                        }
                    }
                    .frame(width: 160, height: 160)
                    
                    
                    // MARK: - Input Fields
                    VStack(alignment: .leading, spacing: 20) {
                        PersonProfileCustomTextField(title: "Pet Parent Name", text: $viewModel.parentName)
                         
                        phoneField
                        
                        emailField
                        
                        PersonProfileCustomTextField(title: "Bio", text: $viewModel.Bio)
                    }
                    
                    // MARK: - Save Button
                    Button(action: {
                        if viewModel.validateForm() {
                            viewModel.editYourDetailApi { success in
                                if success {

                                    // 🔔 Notify ProfileView to refresh
                                    NotificationCenter.default.post(
                                        name: .profileDidUpdate,
                                        object: nil
                                    )

                                    showSuccessPopView = true
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
                    
                    Spacer()
                }
                //.padding()
                
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $viewModel.selectedImage,onImgPick: { image in
                        viewModel.selectedImage = image
                        viewModel.imgData = image.jpegData(compressionQuality: 0.8) ?? Data()
                    }, onLimitExceeded: { msg in
                        viewModel.errorMessage = msg
                        viewModel.showError = true
                    })
                }
            }
            .overlay(
                Group {
                    if showSuccessPopView {
                        ProfileUpdatedSuccPopUp(isVisible: $showSuccessPopView)
                    }
                 }
              )
            if viewModel.showActivity {
                CustomLoderView(isVisible: $viewModel.showActivity)
                    .ignoresSafeArea()
            }
          }
//          .onAppear {
//              viewModel.getYourDetailApi()
//          }
        
        //  Add this below
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text(""),
                message: Text(viewModel.errorMessage ?? "Something went wrong"),
                dismissButton: .default(Text("OK"))
            )
        }
        
        // Camera/Gallery action sheet
        .confirmationDialog("Choose an option", isPresented: $showActionSheet) {
            Button("Camera") {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    imageSource = .camera
                    showImagePicker = true
                }
            }

            Button("Gallery") {
                imageSource = .photoLibrary
                showImagePicker = true
            }

            Button("Cancel", role: .cancel) {}
        }

        // Image picker sheet
        .sheet(isPresented: $showImagePicker) {
            ImagePickers(
                sourceType: imageSource,
                selectedImage: $viewModel.selectedImage
            )
        }
    }
    
    private var phoneField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Mobile Number")
                .font(.custom("Outfit-Medium", size: 14))
            
            HStack {
                Text("🇺🇸 +1")
                
                TextField("(555) 123 456", text: $viewModel.mobileNumber)
                    .keyboardType(.numberPad)
//                    .disabled(viewModel.isPhoneVerified)
                
                if viewModel.isPhoneVerified {
                    Image("Verified")
                } else {
                    Button("Verify") {
                        if viewModel.isValidPhone(viewModel.mobileNumber) {
                            viewModel.sendOtp(Email_phone: viewModel.mobileNumber) { success in
                                if success {
                                    UserDefaults.standard.set("VerifyEmailPhone", forKey: "signUp")
                                    coordinator.push(.verifyPhone(profileDetails(email_Phone: viewModel.mobileNumber,fullName: viewModel.parentName,otp: viewModel.OTP),onPop: { status in
                                        if status == "Verified"{
                                            viewModel.verifiedNum = viewModel.mobileNumber
                                            viewModel.isPhoneVerified = true
                                        }
                                    }))
                                }
                            }
                        }else{
                            viewModel.showError = true
                            viewModel.errorMessage = "Please enter valid phone number"
                        }
                    }
                    .foregroundColor(Color(hex: "#258694"))
                }
            }
            .padding(.horizontal, 12)
            .frame(height: 48)
            .background(Color.white)
            .cornerRadius(10)
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#9C9C9C")))
        }
        .padding(.top)
        .padding(.horizontal, 20)
    }
    
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Email")
                .font(.custom("Outfit-Medium", size: 14))
            
            HStack {
                TextField("Enter email", text: $viewModel.email)
                    .autocapitalization(.none)
//                    .disabled(viewModel.isEmailVerified)
                
                if viewModel.isEmailVerified {
                    Image("Verified")
                } else {
                    Button("Verify") {
                        if viewModel.isValidEmail(viewModel.email) {
                            viewModel.sendOtp(Email_phone: viewModel.email) { success in
                                if success {
                                    UserDefaults.standard.set("VerifyEmailPhone", forKey: "signUp")
                                    coordinator.push(.verifyPhone(profileDetails(email_Phone: viewModel.email,fullName: viewModel.parentName,otp: viewModel.OTP),onPop: { status in
                                        if status == "Verified"{
                                            viewModel.verifiedEmail = viewModel.email
                                            viewModel.isEmailVerified = true
                                        }
                                    }))
                                }
                            }
                        }else{
                            viewModel.showError = true
                            viewModel.errorMessage = "Please enter valid email"
                        }
                    }
                    .foregroundColor(Color(hex: "#258694"))
                }
            }
            .padding(.horizontal, 12)
            .frame(height: 48)
            .background(Color.white)
            .cornerRadius(10)
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#9C9C9C")))
        }
        .padding(.top)
        .padding(.horizontal, 20)
    }
}

struct EditCustomDropdown: View {
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
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#949494")))
             }
          }
       }
    }

struct PersonProfileCustomTextField: View {
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
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#9C9C9C")))
        }
       // .padding()
        .padding(.top)
        .padding(.horizontal, 20)
    }
}

#Preview {
    EditProfileView()
}
