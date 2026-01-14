import SwiftUI

struct AddYourDetailPopUpView: View {
    @StateObject private var viewModel = AddYourDetailViewModel()
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showActionSheet = false
    @State private var showImagePicker = false
    @EnvironmentObject private var coordinator: Coordinator
    
    var backAction: () -> () = {}
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            
            VStack {
                headerView
                
                mainFormView
            }
            .padding(.top, 72)
            
            if viewModel.showActivity {
                CustomLoderView(isVisible: $viewModel.showActivity)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            viewModel.getYourDetailApi()
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text(""),
                message: Text(viewModel.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
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
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(
                image: $viewModel.selectedImage,
                onImgPick: { img in
                    viewModel.setImage(img)
                },
                onLimitExceeded: { _ in }
            )
        }
    }
}

extension AddYourDetailPopUpView {
    
    // MARK: - Header
    private var headerView: some View {
        HStack {
            Spacer()
            Button(action: { backAction() }) {
                Image("CancelIcon")
                    .resizable()
                    .frame(width: 35, height: 35)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Main Form
    @ViewBuilder
    private var mainFormView: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text("Add Your Details")
                .font(.custom("Outfit-Medium", size: 18))
            
            Divider()
            
            ScrollView {
                VStack(spacing: 20) {
                    imagePickerSection
                    nameField
                    phoneField
                    emailField
                    bioField
                    submitButton
                }
                .padding(.vertical)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    // MARK: - Subviews
    private var imagePickerSection: some View {
        VStack {
            ZStack {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                } else {
                    Image("User")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                }
                
                Button(action: { showActionSheet = true }) {
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
    }
    
    private var nameField: some View {
        CustomTextField(title: "Pet Parent Name", placeholder: "Enter name", text: $viewModel.name)
    }
    
    private var phoneField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Mobile Number")
                .font(.custom("Outfit-Medium", size: 14))
            
            HStack {
                Text("🇺🇸 +1")
                
                TextField("(555) 123 456", text: $viewModel.phone)
                    .keyboardType(.numberPad)
                    .disabled(viewModel.isPhoneVerified)
                
                if viewModel.isPhoneVerified {
                    Image("Verified")
                } else {
                    Button("Verify") {
                        if viewModel.isValidPhone(viewModel.phone) {
                            viewModel.sendOtp(Email_phone: viewModel.phone) { success in
                                if success {
                                    UserDefaults.standard.set("profile", forKey: "signUp")
                                    coordinator.push(.verifyPhone(profileDetails(email_Phone: viewModel.phone,fullName: viewModel.name,otp: viewModel.OTP)))
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
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
        }
    }
    
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Email")
                .font(.custom("Outfit-Medium", size: 14))
            
            HStack {
                TextField("Enter email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .disabled(viewModel.isEmailVerified)
                
                if viewModel.isEmailVerified {
                    Image("Verified")
                } else {
                    Button("Verify") {
                        if viewModel.isValidPhone(viewModel.email) {
                            viewModel.sendOtp(Email_phone: viewModel.email) { success in
                                if success {
                                    UserDefaults.standard.set("profile", forKey: "signUp")
                                    coordinator.push(.verifyPhone(profileDetails(email_Phone: viewModel.email,fullName: viewModel.name,otp: viewModel.OTP)))
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
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
        }
    }
    
    private var bioField: some View {
        CustomTextField(title: "Bio", placeholder: "Enter Bio...", text: $viewModel.bio)
    }
    
    private var submitButton: some View {
        Button(action: {
            if viewModel.validateForm() {
                viewModel.AddYourDetailApi { success in
                    if success {
                        backAction()
                    }
                }
            }
        }) {
            Text("Submit")
                .font(.custom("Outfit-Medium", size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: "#258694"))
                .cornerRadius(10)
        }
    }
}
