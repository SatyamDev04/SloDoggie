//
//  BusinessRegistrationView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 13/08/25.
//

import SwiftUI
import PhotosUI
import GooglePlaces

struct BusinessRegistrationView: View {

    @StateObject var viewModel = BusinessRegistrationViewModel()
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
                    VStack(alignment: .leading, spacing: 16) {
                        
                        CustomTextField(title: "Business Name", placeholder: "Enter Name", text: $viewModel.businessName)
                        
                        emailField
                        
                        uploadLogoSection
                        
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
                
                if viewModel.isEmailVerified {
                    Image("Verified")
                } else {
                    Button("Verify") {
                        if viewModel.isValidEmail(viewModel.email) {
                            viewModel.sendOtp(Email_phone: viewModel.email) { success in
                                if success {
                                    UserDefaults.standard.set("profile", forKey: "signUp")
                                    coordinator.push(.verifyPhone(profileDetails(email_Phone: viewModel.email,fullName: viewModel.providerName,otp: viewModel.OTP)))
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
extension BusinessRegistrationView {
    var headerView: some View {
        HStack {
            Button(action: { coordinator.pop() }) {
                Image("Back")
                    .foregroundColor(Color(hex: "#258694"))
            }
            Spacer().frame(width: 20)
            Text("Business Registration")
                .font(.custom("Outfit-Medium", size: 20))
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Upload Logo
extension BusinessRegistrationView {
    var uploadLogoSection: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text("Upload Business Logo")
                .font(.custom("Outfit-Medium", size: 14))

            PhotosPicker(
                selection: $viewModel.logoPickerItems,
                maxSelectionCount: 1,
                matching: .images
            ) {
                uploadPlaceholder
            }
            .onChange(of: viewModel.logoPickerItems) { _ in
                Task { await viewModel.loadLogoImages() }
            }

            imagesGrid(images: viewModel.selectedLogoImages,
                       removeAction: viewModel.removeLogo)
        }
    }
}

// MARK: - Categories
extension BusinessRegistrationView {
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

//            if !viewModel.categories.isEmpty {
//                WrapHStack(categories: viewModel.categories) { category in
//                    HStack {
//                        Text(category)
//                            .font(.custom("Outfit-Regular", size: 12))
//                        Button(action: {
//                            viewModel.removeCategory(category)
//                        }) {
//                            Image(systemName: "xmark")
//                                .font(.system(size: 12))
//                        }
//                    }
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 4)
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(6)
//                }
//            }
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
extension BusinessRegistrationView {
    
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
extension BusinessRegistrationView {
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
extension BusinessRegistrationView {
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

            imagesGrid(images: viewModel.selectedDocImages,
                       removeAction: viewModel.removeDoc)
        }
    }
}

// MARK: - Helpers
extension BusinessRegistrationView {

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

    func imagesGrid(images: [UIImage], removeAction: @escaping (Int) -> Void) -> some View {
        LazyVGrid(columns: gridLayout, spacing: 10) {
            ForEach(Array(images.enumerated()), id: \.offset) { index, img in
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: img as! UIImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Button(action: {
                        removeAction(index)
                    }) {
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

// MARK: - Submit Button
extension BusinessRegistrationView {
   
    var submitButton: some View {
        Button(action: {
            if let error = viewModel.validate() {
                print("❌ Validation failed: \(error)")
                viewModel.showError = true
                viewModel.errorMessage = error
            } else {
                viewModel.AddYourBusinessApi { success in
                    if success {
                        coordinator.push(.addServiceView(mode: .add, index: 0))
                    }
                }
            }
        }) {
            Text("Submit & Next")
                .foregroundColor(.white)
                .font(.custom("Outfit-Medium", size: 16))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: "#258694"))
                .cornerRadius(10)
        }
    }
}

// MARK: - WrapHStack
struct WrapHStack<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let categories: Data
    let content: (Data.Element) -> Content
    @State private var totalHeight = CGFloat.zero
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return ZStack(alignment: .topLeading) {
            ForEach(categories, id: \.self)
            {
                category in self.content(category) .padding(.all, 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > geometry.size.width) {
                            width = 0
                            height -= d.height }
                        let result = width
                        if category == categories.last! { width = 0 } else { width -= d.width }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if category == categories.last! { height = 0 }
                        return result
                    }) } }
        .background(viewHeightReader($totalHeight)) }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry in
            DispatchQueue.main.async {
                binding.wrappedValue = geometry.size.height
            }
            return Color.clear
        }
    }
}
#Preview(){
    BusinessRegistrationView()
}
