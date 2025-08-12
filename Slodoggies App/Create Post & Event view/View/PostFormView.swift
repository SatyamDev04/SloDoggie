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
    @State private var privacy = "Public"
    @State private var selectedPrivacy: PrivacyOption = .publicOption
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Who's This Post About?")
            Button(action: {
                
            }) {
                Image("StoryPlusIcon")
                    .frame(width: 50, height: 50)
            }

            UploadMediaView()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Write Post")
                    .font(.headline)

                PlaceholderTextEditor(placeholder: "Enter Description", text: $description)
                    .frame(height: 120)
            }
            
           // CustomTextField(title: "Write Post", placeholder: "Enter Description", text: $description)
             //   .textFieldStyle(RoundedBorderTextFieldStyle())
            CustomTextField(title: "Hashtags", placeholder: "Add #tags", text: $hashtags)
                //.textFieldStyle(RoundedBorderTextFieldStyle())

//          Toggle("use my current location", isOn: $useCurrentLocation)
            
            Text("Location")
            Button(action: {}) {
                HStack{
                    Image("mage_location")
                    Text("Use My Current Location")
                        .foregroundColor(.black)
                }
            }
            TextField("Add Address", text: $addAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 40)

            VStack(alignment: .leading, spacing: 8) {
                Text("Privacy Settings")
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(.black)

                ForEach(PrivacyOption.allCases) { option in
                    HStack {
                        Text(option.rawValue)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(selectedPrivacy == option ? "FilledRadioBtn" : "EmptyRadioBtn")
                            .frame(width: 16, height: 16)
                            .onTapGesture {
                                selectedPrivacy = option
                        }
                    }
                    .padding(.vertical, 4)
                }
             }

            Button("Post") {
              // Submit logic
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.teal)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
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
