//
//  EditBusinessView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 02/09/25.
//

import SwiftUI
import PhotosUI
import GooglePlaces

struct EditBusinessView: View {

    @StateObject var viewModel = EditBusinessViewModal()
    @EnvironmentObject private var coordinator: Coordinator
    @State private var showAddressSheet = false
    
    let gridLayout = [GridItem(.flexible()),
                      GridItem(.flexible()),
                      GridItem(.flexible())]

    var body: some View {
        ZStack{
            VStack {
                headerView
                ProgressView(value: 0.4)
                    .tint(Color(hex: "#258694"))
                
                ScrollView {
                    
                uploadLogoSection
                
                    VStack(alignment: .leading, spacing: 16) {
                        
                        CustomTextField(title: "Business Name", placeholder: "Enter Name", text: $viewModel.businessName)
                        
                        CustomTextField(title: "Provider Name", placeholder: "Enter Provider Name", text: $viewModel.providerName)
                        
                        emailField
                        
                        categoriesSection
                        
                        addressSection
                        
                        CustomTextField(title: "Website", placeholder: "URL", text: $viewModel.website)
                        phoneField
                        
                        availabilitySection
                        
                        verificationDocsSection
                        
                        submitButton
                    }
                    .padding(.horizontal, 20)
                }
            }
            .onAppear(){
                viewModel.getYourBusinessDetailApi()
            }
            if viewModel.showActivity {
                CustomLoderView(isVisible: $viewModel.showActivity)
                    .ignoresSafeArea()
            }
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text(viewModel.errorMessage ?? ""))
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
                
//                if viewModel.isEmailVerified {
//                    Image("Verified")
//                } else {
//                    Button("Verify") {
//                        if viewModel.isValidEmail(viewModel.email) {
//                            viewModel.sendOtp(Email_phone: viewModel.email) { success in
//                                if success {
//                                    UserDefaults.standard.set("profile", forKey: "signUp")
//                                    coordinator.push(.verifyPhone(profileDetails(email_Phone: viewModel.email,fullName: viewModel.providerName,otp: viewModel.OTP)))
//                                }
//                            }
//                        }else{
//                            viewModel.showError = true
//                            viewModel.errorMessage = "Please enter valid email"
//                        }
//                    }
//                    .foregroundColor(Color(hex: "#258694"))
//                }
            }
            .padding(.horizontal, 12)
            .frame(height: 48)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
        }
    }
    private var phoneField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Mobile Number")
                .font(.custom("Outfit-Medium", size: 14))
            
            HStack {
                TextField("(555) 123 456", text: $viewModel.contactNumber)
                    .keyboardType(.numberPad)
                    .disabled(viewModel.isPhoneVerified)
                
                if viewModel.isPhoneVerified {
                    Image("Verified")
                } else {
                    Button("Verify") {
                        if viewModel.isValidPhone(viewModel.contactNumber) {
                            viewModel.sendOtp(Email_phone: viewModel.contactNumber) { success in
                                if success {
                                    UserDefaults.standard.set("profile", forKey: "signUp")
                                    coordinator.push(.verifyPhone(profileDetails(email_Phone: viewModel.contactNumber,fullName: viewModel.providerName,otp: viewModel.OTP)))
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
}

// MARK: - Header
extension EditBusinessView {
    var headerView: some View {
        HStack {
            Button(action: { coordinator.pop() }) {
                Image("Back")
                    .foregroundColor(Color(hex: "#258694"))
            }
            Spacer().frame(width: 20)
            Text("Edit Business")
                .font(.custom("Outfit-Medium", size: 20))
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Upload Logo
extension EditBusinessView {

        var uploadLogoSection: some View {
            ZStack {
    
                Circle()
                    .fill(Color(red: 229/255, green: 239/255, blue: 242/255))
                    .frame(width: 160, height: 160)
    
                // 1. Picked new image
                if let image = viewModel.selectedLogoImages.first {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                // Existing API logo
                }
                else if !viewModel.apiProfileURL.isEmpty {
                           Image.loadImage(viewModel.apiProfileURL)
                               .scaledToFill()
                               .frame(width: 140, height: 140)
                               .clipShape(Circle())

                       // 3️⃣ Fallback
                       }
                else {
                    Image("DummyIcon")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                }
    
                // Upload Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        PhotosPicker(
                            selection: $viewModel.logoPickerItems,
                            maxSelectionCount: 1,
                            matching: .images
                        ) {
                            Image("UploadImageIcon")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .background(Circle().fill(Color.teal))
                        }
                        .offset(x: -18, y: -12)
                    }
                }
            }
            .frame(width: 170, height: 170)
            .onChange(of: viewModel.logoPickerItems) { _ in
                Task { await viewModel.loadLogoImages() }
            }
        }
}

// MARK: - Categories
extension EditBusinessView {
    var categoriesSection: some View {
        VStack(alignment: .leading) {
            Text("Category")
                .font(.custom("Outfit-Medium", size: 14))

            HStack {
                TextField("Category name", text: $viewModel.newCategory)
                    .padding()
                Button(action: viewModel.addCategory) {
                    Text("+")
                        .font(.system(size: 25))
                        .padding(.trailing, 10)
                        .foregroundColor(Color(hex: "#258694"))
                }
                .disabled(viewModel.newCategory.isEmpty)
            }
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.8)))

            if !viewModel.categories.isEmpty{
                WrapHStack(categories: viewModel.categories) { category in
                    HStack {
                        Text(category)
                            .font(.custom("Outfit-Regular", size: 12))
                        Button(action: { viewModel.categories.removeAll { $0 == category }
                        })
                        { Image(systemName: "xmark")
                                .font(.system(size: 12))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 8) .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.1)) .cornerRadius(6) } }
        }
    }
}

// MARK: - Address Section
extension EditBusinessView {
    
    var addressSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            addressField(
                title: "Business Address",
                text: $viewModel.businessAddress,
                placeholder: "Enter Business Address"
            )
            .disabled(true)                 // ❗ prevents keyboard
            .onTapGesture {
                showAddressSheet = true     // sheet opens normally
            }


            addressField(title: "City", text: $viewModel.city, placeholder: "Enter City")
            addressField(title: "State", text: $viewModel.state, placeholder: "Enter State")
            addressField(title: "Zip Code", text: $viewModel.zipCode, placeholder: "Enter Zip Code")
        }
       
        .sheet(isPresented: $showAddressSheet) {
                    AddressSearchSheet { selectedAddress in
//                        viewModel.businessAddress = selectedAddress
                        showAddressSheet = false
                        viewModel.fillAddress(selectedAddress)
                    }
                }
    }

    func addressField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Outfit-Medium", size: 14))
            TextField(placeholder, text: text)
                .padding()
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5))
                )
        }
    }
    
    

}

// MARK: - Availability
extension EditBusinessView {
    var availabilitySection: some View {
        VStack(alignment: .leading) {
            Text("Available Days/Hours")
                .font(.custom("Outfit-Medium", size: 14))

            HStack {
                TextField("Sunday", text: $viewModel.availableDays)
                    .padding()
                Button(action: {
                    viewModel.showDaysSelection = true
                }){
                    Image("tabler_calendar-time")
                        .padding(.trailing, 8)
                }
            }
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

            if viewModel.showDaysSelection {
                AvailabilitySelectorView(
                    availableDays: $viewModel.availableDays,
                    fromTime: $viewModel.fromTime,
                    toTime: $viewModel.toTime
                ) {
                    viewModel.showDaysSelection = false
                }
            }
        }
    }
}

// MARK: - Verification Docs
extension EditBusinessView {
    var verificationDocsSection: some View {
        VStack(alignment: .leading) {
            Text("Upload Verification Docs. (Optional)")
                .font(.custom("Outfit-Medium", size: 14))

            PhotosPicker(
                selection: $viewModel.docPickerItems,
                maxSelectionCount: 10,
                matching: .images
            ) {
                uploadPlaceholder
            }
            .onChange(of: viewModel.docPickerItems) { _ in
                Task { await viewModel.loadDocImages() }
            }

            verificationGrid()
        }
    }
}

// MARK: - Helpers
extension EditBusinessView {

    var uploadPlaceholder: some View {
        VStack {
            Image("material-symbols_upload")
            Text("Upload Here")
                .font(.custom("Outfit-Medium", size: 14))
                .foregroundColor(Color(hex: "#258694"))
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 229/255, green: 239/255, blue: 242/255))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
        )
    }

    func verificationGrid() -> some View {
        LazyVGrid(columns: gridLayout, spacing: 10) {
            ForEach(viewModel.verificationDocs, id: \.id) { doc in
                ZStack(alignment: .topTrailing) {

                    // Image
                    Group {
                        switch doc {
                        case .existing(let url):
                            Image.loadImage(url)
                                //.resizable()

                        case .new(let image):
                            Image(uiImage: image)
                                .resizable()
                        }
                    }
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .cornerRadius(8)

                    // ❌ Red Cross Button
                    Button {
                        viewModel.removeVerificationDoc(doc)
                    } label: {
                        Image("redcrossicon")   // your asset
                            .resizable()
                            .frame(width: 18, height: 18)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .offset(x: 6, y: -6)
                }
            }
        }
    }

}

// MARK: - Submit Button
extension EditBusinessView {
   
    var submitButton: some View {
        Button(action: {
            if let error = viewModel.validate() {
                print("❌ Validation failed: \(error)")
                viewModel.showError = true
                viewModel.errorMessage = error
            } else {
                viewModel.AddYourBusinessApi { success in
                    if success {
                        coordinator.pop()
                       // coordinator.push(.addServiceView(mode: .add, index: 0))
                    }
                }
            }
        }) {
            Text("Submit")
                .foregroundColor(.white)
                .font(.custom("Outfit-Medium", size: 16))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: "#258694"))
                .cornerRadius(10)
        }
    }
}

#Preview(){
    EditBusinessView()
}
