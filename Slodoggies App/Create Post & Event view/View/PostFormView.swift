//
//  PostFormView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 29/07/25.
//

import SwiftUI

enum PrivacyOption: String, CaseIterable, Identifiable {
    case publicOption = "Public"
    case followersOnly = "Followers Only"
    case privateOnly = "Private (Only me)"
    
    var id: String { self.rawValue }
}

struct PostFormView: View {
    @State private var description = ""
    @State private var hashtags = ""
    @State private var addAddress = ""
    @State private var useCurrentLocation = false
    @State private var selectedPrivacy: PrivacyOption = .publicOption
    @State private var showSuccessPopView: Bool = false
    
    @State private var selectedPet: Pets? = nil
    @State private var pets: [Pets] = [
        Pets(name: "Jimmi", imageName: "dog1"),
        Pets(name: "Barry", imageName: "dog2"),
        Pets(name: "Billi", imageName: "dog3"),
        Pets(name: "Julia", imageName: "dog4")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Who's This Post About?")
                .font(.custom("Outfit-Medium", size: 16))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(pets) { pet in
                        VStack(spacing: 6) {
                            Image(pet.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 38, height: 38)
                                .clipShape(Circle())
                            
                            Text(pet.name)
                                .font(.caption)
                                .foregroundColor(selectedPet?.id == pet.id ? .white : .primary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                        }
                        .frame(width: 58, height: 78)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedPet?.id == pet.id ? Color(hex: "#258694") : Color.clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .onTapGesture {
                            withAnimation {
                                selectedPet = pet
                            }
                        }
                    }
                    Button(action: {
                        // Add new pet action
                    }) {
                        ZStack {
                            Rectangle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                .frame(width: 58, height: 78)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                            Image("AddStoryIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 38, height: 38)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            
            Text("Upload Media")
                .font(.custom("Outfit-Medium", size: 16))
            UploadMediaView()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Write Post")
                    .font(.custom("Outfit-Medium", size: 16))
                
                PlaceholderTextEditor(placeholder: "Enter Description", text: $description)
                    .frame(height: 120)
            }
            
            CustomTextField(title: "Hashtags", placeholder: "Add #tags", text: $hashtags)
            
            Text("Location")
                .font(.custom("Outfit-Medium", size: 20))
            Button(action: {}) {
                HStack {
                    Image("mage_location")
                    Text("Use My Current Location")
                        .foregroundColor(.black)
                        .font(.custom("Outfit-Regular", size: 14))
                }
            }
            TextField("Add Address", text: $addAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 40)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Privacy Settings")
                    .font(.custom("Outfit-Medium", size: 16))
                    .foregroundColor(.black)
                
                ForEach(PrivacyOption.allCases) { option in
                    HStack {
                        Text(option.rawValue)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(selectedPrivacy == option ? "FilledRadioBtn" : "EmptyRadioBtn")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle()) // makes the whole row tappable
                    .onTapGesture {
                        selectedPrivacy = option
                    }
                }
            }
            
            Button(action: {
                showSuccessPopView = true
            }){
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
        }
        .overlay(
            Group {
                if showSuccessPopView {
                    PostCreatedSuccPopUp(isVisible: $showSuccessPopView)
                }
            }
        )
        .padding()
     }
  }

struct PlaceholderTextEditor: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
            }
            TextEditor(text: $text)
                .padding(8)
                .background(Color.clear)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
     }
  }
