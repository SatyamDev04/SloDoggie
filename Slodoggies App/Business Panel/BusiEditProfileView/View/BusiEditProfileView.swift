//
//  BusiEditProfileView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 28/08/25.
//

import SwiftUI

struct BusiEditProfileView: View {
    @StateObject private var viewModel = EditProfileViewModel()
    @State private var showImagePicker = false
    @State var showSuccessPopView: Bool = false
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject var userData: UserData
    
    var body: some View {
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
                
                Button(action: {
                    let userType = UserDefaults.standard.string(forKey: "userType")
                    if userType == "Professional" {
                        coordinator.push(.busiSettingsView)
                    }else{
                        coordinator.push(.settingView)
                    }
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
            ScrollView {
                ZStack {
                    // Outer Circle Background (light teal border)
                    Circle()
                        .fill(Color(red: 229/255, green: 239/255, blue: 242/255))
                        .frame(width: 160, height: 160)

                    // Profile Image
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                    } else {
                        if let uiImage = UIImage(named: "") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                        } else {
                            Image("DummyIcon") // your default placeholder asset
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                        }
                    }

                    // Upload Button (bottom-right)
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                showImagePicker = true
                            }) {
                                Image("UploadImageIcon")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.white)
                                    .background(Circle().fill(Color.teal))
                            }
                            .offset(x: -18, y: -12)
                        }
                    }
                }
                .frame(width: 170, height: 170)
                //.background(Circle().fill(Color.teal)
                
                // MARK: - Input Fields
                Group {
                    BusiPersonProfileCustomTextField(title: "Pet Parent Name", text: $viewModel.parentName)
                    
                    BusiPersonProfileCustomTextField(title: "Bio", text: $viewModel.Bio)
                    
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
            // Image picker sheet
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $viewModel.selectedImage,onImgPick: { _ in
//                    viewModel.imgData = img.jpegData(compressionQuality: 0.8) ?? Data()
                }, onLimitExceeded: { _ in
//                    viewModel.showError = true
//                    viewModel.errorMessage = msg
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
       }
    }

struct BusiEditCustomDropdown: View {
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

struct BusiPersonProfileCustomTextField: View {
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
    BusiEditProfileView()
}
