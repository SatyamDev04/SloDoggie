//
//  AddYourPetView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 24/07/25.
//

import SwiftUI

struct AddYourPetView: View {
    @State private var petName = ""
    @State private var petBreed = ""
    @State private var petAge = ""
    @State private var petBio = ""
    @State private var managedBy = "Pet Mom"
    @State private var showAgePicker = false
    @State private var showManagerPicker = false
    @Binding var isVisible: Bool
    
    var backAction : () -> () = {}
    let petAges = ["1", "2", "3", "4", "5+"]
    let managerOptions = ["Pet Mom", "Pet Dad", "Guardian"]

    var body: some View {
        ZStack {
            // Background dimming
            Color(hex: "#3C3C434A").opacity(0.5)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        isVisible = false
                            // backAction()
                    }) {
                        Image("CancelIcon")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.blue)
                    }
                }
                .padding(.top)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 25) {
                
                Text("Tell us about your pet!")
                    .font(.custom("Outfit-Medium", size: 18))
                    .padding(.bottom, 4)
                
                Divider()
                ScrollView{
                    VStack {
                        ZStack {
                            Image("User")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 65, height: 65)
                                .clipShape(Circle())
                            
                            Image("UploadIcon")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .padding(4)
                                .background(Color(hex: "#258694"))
                                .clipShape(Circle())
                                .offset(x: 22, y: 22)
                            
                        }
                        Text("Add Photo")
                            .font(.custom("Outfit-Medium", size: 14))
                            .padding(.top, 4)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        CustomTextField(title: "Pet Name", placeholder: "Enter pet name", text: $petName)
                        CustomTextField(title: "Pet Breed", placeholder: "Enter Breed", text: $petBreed)
                        
                        CustomDropdownField(title: "Pet Age", text: $petAge, placeholderTxt: .constant("Enter pet age"), isPickerPresented: $showAgePicker, options: petAges)
                        CustomTextField(title: "Pet Bio", placeholder: "Enter Bio", text: $petBio)
                    }
                    
                    HStack {
                        Button(action: {
                            isVisible = false
                        }) {
                            Text("Cancel")
                                .font(.custom("Outfit-Medium", size: 16))
                                .foregroundColor(.black)
                                .padding()
                                .frame(minWidth: 150)
                        }
                                              
                        Spacer()
                        
                        Button(action: {
                            isVisible = false
                            //backAction()
                        }) {
                            Text("Add Pet")
                                .font(.custom("Outfit-Medium", size: 16))
                                .foregroundColor(.white)
                                .padding()
                                .frame(minWidth: 150)
                                .background(Color(hex: "#258694"))
                                .cornerRadius(10)
                        }
                      }
                    .padding(.top)
                }
              }
            .scrollIndicators(.hidden)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .frame(maxHeight: UIScreen.main.bounds.height * 0.8)
//            .padding(.bottom)
            }
//            .ignoresSafeArea(edges: .bottom)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}


  #Preview {
     AddYourPetView(isVisible: .constant(true))
  }
