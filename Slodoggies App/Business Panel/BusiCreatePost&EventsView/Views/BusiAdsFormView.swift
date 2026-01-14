//
//  BusiAdsFormView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/09/25.
//


import SwiftUI
import _PhotosUI_SwiftUI

struct BusiAdsFormView: View {
    @State private var businessName = ""
    @State private var email = ""
    @State private var location = ""
    @State private var website = ""
    @State private var contactNumber = ""
    @State private var selectedDay = "Sunday"
    
    @State private var logoImage: UIImage? = nil
    @State private var verificationDoc: UIImage? = nil
    
    @State private var categories: [String] = []
    @State private var newCategory = ""
    @State private var title = ""
    @State private var description = ""
    @State private var expiryDateTime : Date?
    @State private var termsText = ""
    @State private var ShowDaysSelection : Bool = false
    @State private var service = ""
    @State private var showServicePicker = false
    @State private var showContactInfo = false
    @State private var mobileNumber = ""
    var errorHandler : (String) -> Void = { _ in }
    @EnvironmentObject private var coordinator: Coordinator
//    @ObservedObject var viewModel: BusiAdsViewModel
    @ObservedObject var viewModel: CreatePostViewModel
    var addressTap : () -> Void = { }
    let gridLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
            if viewModel.selectedMedia.count < 6 {
                Text("Upload Media")
                    .font(.custom("Outfit-Medium", size: 14))
                    .padding(.top)
                
                    PhotosPicker(
                        selection: $viewModel.pickerItems,
                        maxSelectionCount: max(0, 6 - viewModel.selectedMedia.count),
                        matching: .any(of: [.images, .videos])
                    ) {
                        VStack {
                            Image("material-symbols_upload")
                                .font(.title)
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
                                .foregroundColor(Color(hex: "#258694"))
                        )
                    }
                    .onChange(of: viewModel.pickerItems) { newItems in
                        Task {
                            await viewModel.addMedia(from: newItems)
                        }
                    }
                } else {
                    VStack {
                        Image("material-symbols_upload")
                            .font(.title)
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
                            .foregroundColor(Color(hex: "#258694"))
                    )
                    .onTapGesture {
                        errorHandler("You can't select more than 6 items")
//                        errorMessage = "You can't select more than 6 items"
//                        showError = true
                    }
                }

                // Selected Media Grid
                LazyVGrid(columns: gridLayout, spacing: 10) {
                    ForEach(Array(viewModel.selectedMedia.enumerated()), id: \.1.id) { idx, media in
                        ZStack(alignment: .topTrailing) {
                            if let image = media.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else if let url = media.videoURL {
                                VideoThumbnailView(videoURL: url)
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                Rectangle()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(Color.gray.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }

                            Button(action: {
                                viewModel.removeMedia(at: idx)
                            }) {
                                Image("redcrossicon")
                                    .resizable()
                                    .frame(width: 17, height: 17)
                            }
                            .offset(x: 6, y: -6)
                        }
                    }
                }
                .padding(.top)


                
                Text("Ad Title")
                    .font(.custom("Outfit-Medium", size: 14))
                TextField("Enter Title", text: $title)
                    .padding(.vertical, 12) // increases height inside
                    .padding(.horizontal, 10) // keeps horizontal spacing nice
                    .cornerRadius(8)
                    .font(.custom("Outfit-Regular", size: 15))
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                            //.padding(.top)
                
            VStack(alignment: .leading, spacing: 8) {
                Text("Ad Desription")
                    .font(.custom("Outfit-Medium", size: 14))

                PlaceholderTextEditor(placeholder: "Enter Description", text: $description)
                    .frame(height: 120)
                    //.padding(.top)
            }
                
                VStack(alignment: .leading) {
                    Text("Category")
                        .font(.custom("Outfit-Medium", size: 14))
                        .foregroundColor(.black)

                    HStack {
                        TextField("Category name", text: $newCategory)
                            .font(.custom("Outfit-Regular", size: 15))
                            .padding()
                            .frame(height: 50)
                        
                        Button(action: {
                            categories.append(newCategory)
                            newCategory = ""   //  clear text field
                        }) {
                            Text("+")
                                .font(.system(size: 25, weight: .regular, design: .default))
                                .foregroundColor(Color(hex: "#258694"))
                        }
                        .frame(width: 20, height: 10)
                        .padding(.trailing, 10)
                        .disabled(newCategory.isEmpty) // disable when empty
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.8))
                    )
                }
                if !categories.isEmpty{
                    WrapHStack(categories: categories) { category in
                        HStack {
                            Text(category)
                                .font(.custom("Outfit-Regular", size: 12))
                            Button(action: {
                                categories.removeAll { $0 == category }
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 10))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                    }
                }
               
                Group {
                    Text("Service")
                        .font(.custom("Outfit-Medium", size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                }
                
                DropdownSelector(
                    title: "",
                    text: $service,
                    placeholderTxt: "Select Amount",
                    isPickerPresented: $showServicePicker,
                    options: viewModel.serviceList
                )
                .padding(.top, -20)
               
                BusiDatePickerField(selectedDate: $expiryDateTime, title: "Expiry Date And Time")
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Terms & Conditions")
                        .font(.custom("Outfit-Medium", size: 14))

                    PlaceholderTextEditor(placeholder: "Enter Here", text: $termsText)
                        .frame(height: 120)
                        //.padding(.top)
                }
                
                CustomTextField(title: "Service Location", placeholder: "San Luis Obispo", text: $viewModel.address)
                    .onTapGesture {
                        self.addressTap()
                    }
                
//                if ShowDaysSelection {
//                    AvailabilitySelectorView(
//                        availableDays: $availableDays,
//                        fromTime: $fromTime,
//                        toTime: $toTime
//                    ) {
//                        ShowDaysSelection = false
//                    }
//                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title + Toggle
                    HStack {
                        Text("Contact Info. Display")
                            .font(.custom("Outfit-Medium", size: 14))
                        
                        Spacer()
                        
                        Toggle("", isOn: $showContactInfo)
                            .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: .black))
                                .scaleEffect(0.7)
                                .frame(height: 14) // Optional, improves alignment in HStack
                                //.offset(y: -2)
                    }
                    
                    // Mobile number field
                    TextField("Enter Mobile Number", text: $mobileNumber)
                        .padding()
                        .keyboardType(.numberPad)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                }
               // .padding(.horizontal)
               
                // Submit Button
                Button(action: {
                    if validateForm() {
                        print("======ADS data=====\n",(adsDataModel(adTitle: title,media: viewModel.selectedMedia,adDescription: description,category: categories, service: service,expiryDate: "\(expiryDateTime ?? Date())",expiryTime: "",tNc: termsText, address: viewModel.address, latitude: "\(viewModel.latitude ?? 0.0)",longitude: "\(viewModel.longitude ?? 0.0)", contactShowStatus: showContactInfo ? 1 : 0, contactInfo: mobileNumber)))
                        coordinator.push(.budgetView(adsDataModel(adTitle: title,media: viewModel.selectedMedia,adDescription: description,category: categories, service: service,expiryDate: "\(expiryDateTime ?? Date())",expiryTime: "",tNc: termsText, address: viewModel.address, latitude: "\(viewModel.latitude ?? 0.0)",longitude: "\(viewModel.longitude ?? 0.0)", contactShowStatus: showContactInfo ? 1 : 0, contactInfo: mobileNumber)))
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
                .padding(.top)
                .padding(.bottom)
            }
            .padding(.horizontal,20)
        }
    }
    
    // MARK: - UI Helpers
    @ViewBuilder
    func uploadArea(image: Binding<UIImage?>) -> some View {
        Button(action: {
            // Pick image
        }) {
            VStack {
                Image("Upload")
                Text("Upload Here")
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(Color(hex: "#258694"))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundColor(Color(hex: "#258694"))
            )
            .background(Color(hex: "#00637A").opacity(0.1))
        }
        .frame(height: 80)
    }
    
    @ViewBuilder
    func uploadedImageView(image: UIImage, onRemove: @escaping () -> Void) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .cornerRadius(8)
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
            .offset(x: 5, y: -5)
        }
    }
    
    // MARK: Validation
    private func validateForm() -> Bool {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter ads title")
            return false
        }
        if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter description")
            return false
        }
        if categories.isEmpty {
            showErrorPopup("Add ads category")
            return false
        }
        if service.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Select a service")
            return false
        }
        if expiryDateTime == nil {
            showErrorPopup("Select Expiry Date And Time")
            return false
        }
        if termsText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter terms & conditions")
            return false
        }
        if viewModel.address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter address")
            return false
        }
        if mobileNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter contact number")
            return false
        }
            return true
        }
        
        private func showErrorPopup(_ message: String) {
//            errorMessage = message
            errorHandler(message)
        }
}

struct BusiDatePickerField: View {
    @Binding var selectedDate: Date?
    @State private var showDatePicker = false
    @State private var fieldWidth: CGFloat = 0
    
    var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.custom("Outfit-Regular", size: 15))
                .foregroundColor(.black)
            
            ZStack(alignment: .topLeading) {
                HStack {
                    Text(selectedDate != nil ? formatDate(selectedDate!) : "Select Date And Time")
                        .foregroundColor(selectedDate != nil ? .black : .gray.opacity(0.6))
                        .font(.custom("Outfit-Regular", size: 14))
                    Spacer()
                    
                    Image("datetimeicon")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(height: 48)
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                fieldWidth = geo.size.width
                        }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .onTapGesture {
                    withAnimation {
                        showDatePicker.toggle()
                    }
                }
                
                if showDatePicker {
                    VStack(spacing: 0) {
                        Divider()
                        DatePicker(
                            "",
                            selection: Binding(
                                get: { selectedDate ?? Date() },
                                set: { selectedDate = $0 }
                            ),
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .padding()
                        
                        HStack {
                            Spacer()
                            Button("Done") {
                                withAnimation {
                                    showDatePicker = false
                                }
                            }
                            .padding(.bottom, 8)
                        }
                        .padding(.horizontal)
                    }
                    .frame(width: fieldWidth)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .offset(y: 50) // push it below the field
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        // add bottom spacing dynamically
        .padding(.bottom, showDatePicker ? 60 : 12)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview{
    BusiAdsFormView(viewModel: CreatePostViewModel())
}
