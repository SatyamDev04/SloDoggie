//
//  BusiPostFormView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 08/09/25.
//

import SwiftUI
import PhotosUI
import AVKit
import AVFoundation

struct BusiPostFormView: View {
    @State private var descriptionText = ""
    @State private var hashtags = ""
    @State private var address = ""
    @State private var useCurrentLocation = false
    @StateObject private var viewModel = BusiPostEventViewModel()
    @Binding var showBusiPostSuccessPopView: Bool
    @State private var errorMessage: String? = nil
    @State private var showError = false
    
    var backAction: () -> () = {}
    let gridLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Upload Media
            Text("Upload Media")
                .font(.custom("Outfit-Medium", size: 14))

            if viewModel.selectedMedia.count < 6 {
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
                    errorMessage = "You can't select more than 6 items"
                    showError = true
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

            // Post Details
            VStack(alignment: .leading, spacing: 8) {
                Text("Write Post")
                    .font(.custom("Outfit-Medium", size: 14))

                PlaceholderTextEditor(placeholder: "Enter Description", text: $descriptionText)
                    .frame(height: 120)

                CustomTextField(title: "Hashtags", placeholder: "Add #tags(Optional)", text: $hashtags)

                Text("Current Location")
                    .font(.custom("Outfit-Medium", size: 14))
                    .padding(.top, 10)

                Button(action: {}) {
                    HStack {
                        Image("mage_location")
                        Text("Use My Current Location")
                            .foregroundColor(.black)
                            .font(.custom("Outfit-Regular", size: 14))
                    }
                }
                .padding(.bottom, 10)

                Text("Your Address")
                    .font(.custom("Outfit-Medium", size: 14))
                    .padding(.top, -6)

                TextField("Enter your current address(Optional)", text: $address)
                    .padding()
                    .frame(height: 48)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
            }
            .padding(.top, -8)

            // Submit Button
            Button(action: {
                if validateForm() {
                    showBusiPostSuccessPopView = true
                }
            }) {
                Text("Post")
                    .font(.custom("Outfit-Bold", size: 16))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#258694"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 24)
            .frame(height: 34)
            .padding(.bottom, 24)
        }
        .padding()
        .alert(isPresented: $showError) {
            Alert(title: Text(""), message: Text(errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
    }

    // MARK: - Validation
    private func validateForm() -> Bool {
        if descriptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter post description")
            return false
        }
        backAction()
        return true
    }

    private func showErrorPopup(_ message: String) {
        errorMessage = message
        showError = true
    }
}

// ------------------------
// NOTE: PlaceholderTextEditor and CustomTextField are referenced in your original code.
// If you don't have them, replace usages with regular TextEditor/TextField or add your implementations.
// ------------------------

#if DEBUG
struct BusiPostFormView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewBoolWrapper { binding in
            BusiPostFormView(showBusiPostSuccessPopView: binding)
        }
    }

    // Small helper to provide a Binding<Bool> in previews
    struct PreviewBoolWrapper<Content: View>: View {
        @State private var value: Bool = false
        let content: (Binding<Bool>) -> Content

        init(@ViewBuilder content: @escaping (Binding<Bool>) -> Content) {
            self.content = content
        }

        var body: some View {
            content($value)
        }
    }
}
#endif
