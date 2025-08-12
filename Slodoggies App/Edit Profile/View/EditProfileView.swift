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
    @EnvironmentObject private var coordinator: Coordinator

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20){
                Button(action: {
                    coordinator.pop()
                }){
                    Image("Back")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text("Edit Profile")
                    .font(.custom("Outfit-Medium", size: 22))
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: "#221B22"))
                //.padding(.leading, 100)
                
                Spacer()
                
                Button(action: {
                    coordinator.push(.settingView)
                }){
                    Image("SettingIcon")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            //.padding(.bottom,2)
            
            Divider()
                .frame(height: 2)
                .background(Color(hex: "#258694"))
            
            // MARK: - Pet Image
            ScrollView{
                ZStack(alignment: .bottomTrailing) {
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                    } else {
                        Image("People1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Image("UploadImageIcon")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.teal))
                    }
                    .offset(x: -10, y: -0)
                }
                
                // MARK: - Input Fields
                Group {
                    PersonProfileCustomTextField(title: "Pet Parent Name", text: $viewModel.parentName)
                    
                    PersonProfileCustomTextField(title: "Mobile Number", text: $viewModel.mobileNumber)
                    
                    PersonProfileCustomTextField(title: "Email", text: $viewModel.email)
                    
                    // Pet Age Dropdown
                    CustomDropdown(title: "Relation TO Pet", selection: $viewModel.relationToPet, options: viewModel.managedByOptions)
                        .padding(.top)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    PersonProfileCustomTextField(title: "Bio", text: $viewModel.Bio)
                    
                }
                
                // MARK: - Save Button
                Button(action: {
                   // viewModel.saveChanges()
                    showSuccessPopView = true
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
                ImagePicker(image: $viewModel.selectedImage)
            }
        }
        .overlay(
            Group {
                if showSuccessPopView {
                    ProfileUpdatedSuccPopUp(isVisible: $showSuccessPopView)
                }
             }   
          )
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
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#949494")))
        }
       // .padding()
        .padding(.top)
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}
#Preview {
    EditProfileView()
}
